-- procedimiento de login..
delimiter //
create procedure sp_login_seguro(
    in p_username varchar(50),
    in p_password varchar(255)
)
begin
    select usuario_id, rol, medico_id 
    from usuarios 
    where username = p_username 
    and password_hash = sha2(p_password, 256);
end //
delimiter ;


-- Procedimiento agendar cita
delimiter //
create procedure sp_agendar_cita_completa(
    in p_paciente_id int,
    in p_medico_id int,
    in p_fecha date,
    in p_hora time,
    in p_monto decimal(10,2)
)
begin
    declare exit handler for sqlexception begin rollback; end;
    start transaction;
        insert into citas_medicas (paciente_id, medico_id, fecha_cita, hora_cita)
        values (p_paciente_id, p_medico_id, p_fecha, p_hora);
        
        insert into facturas (cita_id, monto_total)
        values (last_insert_id(), p_monto);
    commit;
end //
delimiter ;


-- procedimiento registrar atencion
delimiter //
create procedure sp_registrar_atencion_completa(
    in p_paciente_id int, in p_medico_id int, in p_diagnostico text,
	in p_tratamiento text, in p_medicamento varchar(255), in p_dosis text
)
begin
    declare exit handler for sqlexception begin rollback; end;
    start transaction;
        insert into historias_clinicas (paciente_id, medico_id, diagnostico, tratamiento)
        values (p_paciente_id, p_medico_id, p_diagnostico, p_tratamiento);

        insert into recetas (historia_id, medicamento, dosis_instrucciones)
        values (last_insert_id(), p_medicamento, p_dosis);
    commit;
end //
delimiter ;

-- procedimiento crear medico 
delimiter //
create procedure sp_crear_medico_acceso(
    in p_nombre varchar(100), in p_apellido varchar(100), in p_codigo varchar(20),
    in p_email varchar(100), in p_especialidad_id int, in p_username varchar(50),
    in p_password varchar(255)
)
begin
    declare exit handler for sqlexception begin rollback; end;

    start transaction;
        insert into medico (nombre, apellido, codigo_profesional, email, especialidad_id)
        values (p_nombre, p_apellido, p_codigo, p_email, p_especialidad_id);
        
        insert into usuarios (username, password_hash, rol, medico_id)
        values (p_username, sha2(p_password, 256), 'medico', last_insert_id());
    commit;
end //
delimiter ;

-- Consulta de expediente
delimiter //
create procedure sp_consultar_expediente(in p_paciente_id int)
begin
    select h.fecha_registro, m.apellido as medico, h.diagnostico, r.medicamento
    from historias_clinicas h
    left join recetas r on h.historia_id = r.historia_id
    join medico m on h.medico_id = m.medico_id
    where h.paciente_id = p_paciente_id
    order by h.fecha_registro desc;
end //
delimiter ;

