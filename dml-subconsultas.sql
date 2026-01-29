-- -------------------------------------------- DML y Subconsultas --------------------------------------------------
use gestionhospital;
-- --------------------------------------------- Inserts -------------------------------------------------
-- Nuevo paciente
insert into paciente (cedula, nombre, apellido, fecha_nacimiento, genero, telefono)
values ('0934567891', 'Betty', 'Quinto', '1974-01-10', 'f', '0991112233');

-- Nueva historia clínica
insert into historias_clinicas (paciente_id, medico_id, diagnostico, tratamiento)
values (1, 1, 'Gripe', 'Reposo e hidratación');

-- Nueva cita 
insert into citas_medicas
(paciente_id, medico_id, fecha_cita, hora_cita, estado)
values
(1, 2, '2026-02-10', '10:30:00', 'completada');

-- Nueva factura
insert into facturas (cita_id, monto_total)
values (6, 45.50);

-- --------------------------------------------- Updates -------------------------------------------------

-- Cambiar teléfono de un paciente
update paciente
set telefono = '0985837201'
where cedula = '0934567891';

-- Cambiar estado de cita
update citas_medicas
set estado = 'cancelada'
where cita_id = 6;

-- Marcar factura como pagada
update facturas
set estado_pago = 'pagado'
where factura_id = 6;

-- --------------------------------------------- Eliminar -------------------------------------------------
-- Eliminar citas canceladas
delete from citas_medicas
where cita_id = 3
and estado = 'cancelada';

-- Eliminar facturas anuladas
delete from facturas
where factura_id = 2
and estado_pago = 'anulado';

delete from paciente
where paciente_id = 10;

-- --------------------------------------------- Subconsultas -------------------------------------------------


-- Pacientes con historia clínica
select nombre, apellido
from paciente
where paciente_id in (
    select paciente_id
    from historias_clinicas
);

-- Médicos que tienen citas
select nombre, apellido
from medico
where medico_id in (
    select distinct medico_id
    from citas_medicas
);

-- Médicos con más citas que el promedio
select nombre, apellido
from medico
where medico_id in (
    select medico_id
    from citas_medicas
    group by medico_id
    having count(*) > (
        select avg(total)
        from (
            select count(*) as total
            from citas_medicas
            group by medico_id
        ) as promedio
    )
);

-- Pacientes que no tienen citas
select nombre, apellido
from paciente
where paciente_id not in (
    select paciente_id
    from citas_medicas
);

