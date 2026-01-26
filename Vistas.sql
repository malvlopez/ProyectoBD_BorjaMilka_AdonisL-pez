-- ---------------------------------------------------------------- VISTAS ------------------------------------------------------------------------------------
-- Vista Citas médicas programadas para mañana
create view vista_citas_manana as
select 
    p.nombre as paciente,
    p.apellido,
    m.nombre as medico,
    e.nombre_especialidad,
    c.fecha_cita,
    c.hora_cita
from citas_medicas c
join paciente p on c.paciente_id = p.paciente_id
join medico m on c.medico_id = m.medico_id
join especialidades e on m.especialidad_id = e.especialidad_id
where c.fecha_cita = curdate() + interval 1 day
  and c.estado = 'programada';
  
select * from vista_citas_manana;

-- Vista Historial clínico por paciente
create view vista_historial_clinico as
select 
    p.cedula,
    p.nombre,
    p.apellido,
    h.diagnostico,
    h.tratamiento,
    h.fecha_registro
from historias_clinicas h
join paciente p on h.paciente_id = p.paciente_id;

select * from vista_historial_clinico;

-- Vista Agenda de médicos
create view vista_agenda_medica as
select 
    m.nombre as medico,
    m.apellido,
    c.fecha_cita,
    c.hora_cita,
    c.estado
from medico m
left join citas_medicas c on m.medico_id = c.medico_id;

select*from vista_agenda_medica;

-- Vista Facturación general
create view vista_facturacion as
select 
    f.factura_id,
    f.monto_total,
    f.estado_pago,
    f.fecha_emision,
    c.fecha_cita
from facturas f
join citas_medicas c on f.cita_id = c.cita_id;

select * from vista_facturacion;