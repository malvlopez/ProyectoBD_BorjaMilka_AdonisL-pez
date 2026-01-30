-- PRUEBA DE INSERT 
insert into paciente (cedula, nombre, apellido, fecha_nacimiento, genero, telefono)
values ('1712345678', 'Prueba', 'Paciente', '1990-05-15', 'm', '0990000000');

-- PRUEBA DE UPDATE
update historias_clinicas 
set diagnostico = 'Diagnóstico actualizado para prueba de auditoría' 
where historia_id = 1;

-- PRUEBA DE DELETE
insert into citas_medicas (paciente_id, medico_id, fecha_cita, hora_cita, estado)
values (1, 1, '2026-12-31', '08:00:00', 'cancelada');

delete from citas_medicas where fecha_cita = '2026-12-31';

-- PRUEBA DE UPDATE FACTURAS
update facturas set estado_pago = 'anulado' where factura_id = 6;

-- PRUEBA DE CAMBIO DE CONTRASEÑA
update usuarios 
set password_hash = sha2('nueva_clave_secreta', 256) 
where username = 'admin';



use gestionhospital;
select 
*
from auditoria_hospital;

