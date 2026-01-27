-- ----------------------------------------------------- INDICES ---------------------------------------------------

-- Paciente por cédula 
create index idx_paciente_cedula
on paciente(cedula);

-- Citas por fecha 
create index idx_citas_fecha
on citas_medicas(fecha_cita);

-- Citas por médico 
create index idx_citas_medico
on citas_medicas(medico_id);

-- Historias clínicas por paciente
create index idx_historia_paciente
ON historias_clinicas(paciente_id);

-- Facturas por estado de pago
create index idx_factura_estado
on facturas(estado_pago);

-- Usuarios por rol (seguridad)
create index idx_usuario_rol
on usuarios(rol);
