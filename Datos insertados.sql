
-- Insertar especialidades

insert into especialidades (nombre_especialidad) values
('Cardiología'),
('Pediatría'),
('Traumatología'),
('Medicina General'),
('Ginecología');

-- Insertar medicos

insert into medico (nombre, apellido, codigo_profesional, email, especialidad_id) values
('Pepe', 'Carrillo', 'MED001', 'pcarrillo@gmail.com', 1),
('Anahi', 'Torres', 'MED002', 'atorres@gmail.com', 2),
('Ronny', 'Gavilanes', 'MED003', 'rgavilanes@gmail.com', 3),
('Amelia', 'Borja', 'MED004', 'aborja@gmail.com', 4),
('Fausto', 'Flores', 'MED005', 'fflores@gmail.com', 5);

-- Insertar pacientes

insert into paciente (cedula, nombre, apellido, fecha_nacimiento, genero, telefono) values
('1702030401','Randy','Paez','1998-05-10','m','0981310131'),
('1702030402','Karla','Guachamin','2000-07-20','f','0991928220'),
('0902030403','Pavel','Valencia','1995-02-15','m','0911393633'),
('1702030404','Camila','Noroña','2002-09-01','f','0994104794'),
('0902030405','Danny','Aguilar','1988-11-30','m','0935485005'),
('1702030406','Katherine','	Henao','1999-04-18','f','0992460626'),
('1702030407','Moises','Narvaez','1990-06-25','m','0976737857'),
('1702030408','Mabel','Choez','2001-01-12','f','0938088088'),
('0902030409','Esteban','Luzuriaga','1997-08-09','m','0949569989'),
('1702030410','Fabianna','Murillo','2003-12-05','f','0987261171');

-- Insertar citas medicas

insert into citas_medicas (paciente_id, medico_id, fecha_cita, hora_cita, estado) values
(1,1,'2026-01-28','09:00','programada'),
(2,1,'2026-02-12','10:00','programada'),
(3,2,'2026-02-01','11:00','completada'),
(4,3,'2026-01-30','08:30','programada'),
(5,4,'2026-02-07','09:30','cancelada');

-- Insertar Historias clínicas
insert into historias_clinicas (paciente_id, medico_id, diagnostico, tratamiento) values
(1,1,'Gripe común','Reposo, líquidos y paracetamol'),
(2,2,'Dolor abdominal','Exámenes y control médico'),
(3,3,'Esguince leve','Reposo y antiinflamatorios'),
(4,4,'Control general','Chequeo de rutina');

-- Insertar Recetas
insert into recetas (historia_id, medicamento, dosis_instrucciones) values
(1,'Paracetamol 500mg','Tomar una tableta cada 8 horas por 3 días'),
(2,'Omeprazol 20mg','Una cápsula diaria por 7 días'),
(3,'Ibuprofeno 400mg','Cada 8 horas por 5 días');

-- Insertar Facturas
insert into facturas (cita_id, monto_total, estado_pago) values
(1,20.00,'pagado'),
(3,25.00,'pagado'),
(4,15.00,'pendiente');

-- Insertar Usuarios
insert into usuarios (username, password_hash, rol, medico_id) values
('admin1','hash_admin','admin',NULL),
('drgarcia','hash_medico','medico',1),
('recep1','hash_recepcion','recepcion',NULL);
