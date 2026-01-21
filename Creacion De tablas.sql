-- Creacion de la DB
create database gestionhospital;
use gestionhospital;

-- tabla especialidades
create table especialidades (
    especialidad_id int auto_increment primary key,
    nombre_especialidad varchar(100) not null unique
) engine=innodb;

-- tabla medico
create table medico (
    medico_id int auto_increment primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    codigo_profesional varchar(20) not null unique,
    email varchar(100),
    especialidad_id int,
    constraint fk_medico_especialidad
        foreign key (especialidad_id)
        references especialidades(especialidad_id)
        on delete set null
) engine=innodb;

-- tabla paciente
create table paciente (
    paciente_id int auto_increment primary key,
    cedula varchar(10) not null unique,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    fecha_nacimiento date not null,
    genero enum('m','f','otro'),
    telefono varchar(15),
    constraint chk_cedula_min check (length(cedula) >= 9)
) engine=innodb;

-- tabla citas_medicas
create table citas_medicas (
    cita_id int auto_increment primary key,
    paciente_id int not null,
    medico_id int not null,
    fecha_cita date not null,
    hora_cita time not null,
    estado enum('programada','completada','cancelada') default 'programada',
    observaciones text,

    constraint fk_cita_paciente
        foreign key (paciente_id) references paciente(paciente_id),

    constraint fk_cita_medico
        foreign key (medico_id) references medico(medico_id),

    unique (medico_id, fecha_cita, hora_cita)
) engine=innodb;

-- tabla historias_clinicas
create table historias_clinicas (
    historia_id int auto_increment primary key,
    paciente_id int not null,
    medico_id int not null,
    fecha_registro timestamp default current_timestamp,
    diagnostico text not null,
    tratamiento text not null,

    constraint fk_historia_paciente
        foreign key (paciente_id) references paciente(paciente_id),

    constraint fk_historia_medico
        foreign key (medico_id) references medico(medico_id)
) engine=innodb;


--