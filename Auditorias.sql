
use gestionhospital;

create table auditoria_hospital (
    auditoria_id int auto_increment primary key,
    tabla_afectada varchar(50) not null,
    accion enum('insert', 'update', 'delete') not null,
    usuario varchar(100), -- antes decía usuario_responsable
    fecha_evento timestamp default current_timestamp,
    detalles text
) engine=innodb;


-- Trigger al insertar paciente
delimiter //
create trigger tr_auditar_paciente_ins
after insert on paciente
for each row
begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('paciente', 'insert', user(), concat('se registro paciente con cedula: ', new.cedula));
end //
delimiter ;


-- Trigger al actualizar historias clinicas

delimiter //
create trigger tr_auditar_historia_upd
after update on historias_clinicas
for each row
begin
    if old.diagnostico <> new.diagnostico then
        insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        values ('historias_clinicas', 'update', user(), 
                concat('historia id: ', old.historia_id, ' | diagnostico anterior: ', old.diagnostico));
    end if;
end //
delimiter ;


-- Trigger al Eliminar cita medica

delimiter //
create trigger tr_auditar_cita_del
before delete on citas_medicas
for each row
begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('citas_medicas', 'delete', user(), 
            concat('cita eliminada id: ', old.cita_id, ' del paciente id: ', old.paciente_id));
end //
delimiter ;

select * from auditoria_hospital;


-- Auditoría de Anulación de Facturas
delimiter //
create trigger tr_auditar_factura_anulacion
after update on facturas
for each row
begin
    if old.estado_pago <> 'anulado' and new.estado_pago = 'anulado' then
        insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        values ('facturas', 'update', user(), 
                concat('ALERTA: Factura ID ', old.factura_id, ' ANULADA. Monto: $', old.monto_total));
    end if;
end //
delimiter ;

-- Gestion de cambio de contraseñas

DELIMITER //
CREATE TRIGGER tr_auditar_password_update
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    IF old.password_hash <> new.password_hash THEN
        INSERT INTO auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        VALUES ('usuarios', 'update', USER(), 
                CONCAT('Se cambió la contraseña del usuario: ', new.username));
    END IF;
END //
DELIMITER ;

-- Auditar Medicos
delimiter //
create trigger tr_auditar_medico_ins
after insert on medico
for each row
begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('medico', 'insert', user(), concat('nuevo médico registrado: ', new.apellido, ' | código: ', new.codigo_profesional));
end //
delimiter ;

-- auditar nueva receta
delimiter //
create trigger tr_auditar_receta_ins
after insert on recetas
for each row
begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('recetas', 'insert', user(), concat('receta creada para historia id: ', new.historia_id));
end //
delimiter ;
