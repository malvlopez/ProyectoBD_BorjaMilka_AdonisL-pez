
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
