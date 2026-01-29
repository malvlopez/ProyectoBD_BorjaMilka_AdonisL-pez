select * from usuarios;

-- Encriptacion de contraseñas..

SET SQL_SAFE_UPDATES = 0;
update usuarios set password_hash = sha2(password_hash, 256);
SET SQL_SAFE_UPDATES = 1;


-- Evitar inyeccion de SQL

delimiter //
create procedure sp_insertar_medico(
    in p_nombre varchar(100),
    in p_apellido varchar(100),
    in p_codigo varchar(20),
    in p_email varchar(100),
    in p_especialidad int
)
begin
    insert into medico (nombre, apellido, codigo_profesional, email, especialidad_id)
    values (p_nombre, p_apellido, p_codigo, p_email, p_especialidad);
end //
delimiter ;


delimiter //
create function fn_sanitizar_texto(p_cadena varchar(255)) 
returns varchar(255)
deterministic
begin
    declare v_limpio varchar(255);
    set v_limpio = replace(p_cadena, '--', '');
    set v_limpio = replace(v_limpio, ';', '');
    return v_limpio;
end //
delimiter ;


delimiter //
create procedure sp_consultar_historia_paciente(in p_paciente_id int)
begin
    select h.fecha_registro, m.apellido as medico, h.diagnostico, h.tratamiento
    from historias_clinicas h
    join medico m on h.medico_id = m.medico_id
    where h.paciente_id = p_paciente_id;
end //
delimiter ;


delimiter //
create trigger tr_validar_factura_bi
before insert on facturas
for each row
begin
    if new.monto_total <= 0 then
        signal sqlstate '45000' 
        set message_text = 'Error: El monto debe ser un valor numérico positivo.';
    end if;
end //
delimiter ;




