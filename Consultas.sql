-- -----------------------------------------  CONSULTAS -----------------------------------------------

use gestionHospital;

-- Consulta Citas médicas con paciente, médico y especialidad
select 
    p.nombre as paciente,
    p.apellido,
    m.nombre as medico,
    e.nombre_especialidad,
    c.fecha_cita,
    c.hora_cita,
    c.estado
from citas_medicas c
join paciente p on c.paciente_id = p.paciente_id
join medico m on c.medico_id = m.medico_id
join especialidades e on m.especialidad_id = e.especialidad_id;

-- Consulta Cantidad de citas por médico
select  
    m.nombre,
    m.apellido,
    count(c.cita_id) as total_citas
from medico m
left join citas_medicas c on m.medico_id = c.medico_id
group by m.medico_id;

-- Consulta Pacientes con citas programadas
select  
    p.nombre,
    p.apellido,
    c.fecha_cita,
    c.hora_cita
from paciente p
join citas_medicas c on p.paciente_id = c.paciente_id
where c.estado = 'programada';

-- Consulta Pacientes mayores de 25 años
select  
    nombre,
    apellido,
    fecha_nacimiento
from paciente
where year(curdate()) - year(fecha_nacimiento) > 25;

-- Consulta Historias clínicas con datos del paciente
select  
    p.nombre,
    p.apellido,
    h.diagnostico,
    h.tratamiento,
    h.fecha_registro
from historias_clinicas h
join paciente p on h.paciente_id = p.paciente_id;

-- Consulta Recetas con su diagnóstico
select  
    r.medicamento,
    r.dosis_instrucciones,
    h.diagnostico
from recetas r
join historias_clinicas h on r.historia_id = h.historia_id;

-- Consulta Total facturado por estado de pago
select  
    estado_pago,
    sum(monto_total) as total
from facturas
group by estado_pago;

-- Consulta Médicos y su especialidad
select  
    m.nombre,
    m.apellido,
    e.nombre_especialidad
from medico m
join especialidades e on m.especialidad_id = e.especialidad_id;

-- Consulta Pacientes con citas futuras
select distinct
    p.nombre,
    p.apellido,
    c.fecha_cita
from paciente p
join citas_medicas c on p.paciente_id = c.paciente_id
where c.fecha_cita > curdate();

-- Consulta Médicos sin citas registradas
select  
    m.nombre,
    m.apellido
from medico m
left join citas_medicas c on m.medico_id = c.medico_id
where c.cita_id is null;
