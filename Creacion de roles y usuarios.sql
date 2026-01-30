-- Creacion de roles
create role 'rol_admin', 'rol_medico', 'rol_recepcion';

-- Asignacion de permisos

grant all privileges on gestionhospital.* to 'rol_admin';


grant select, insert, update on gestionhospital.paciente to 'rol_medico';
grant select, insert, update on gestionhospital.historias_clinicas to 'rol_medico';
grant select, insert, update on gestionhospital.recetas to 'rol_medico';
grant select on gestionhospital.especialidades to 'rol_medico';

grant select, insert, update on gestionhospital.citas_medicas to 'rol_recepcion';
grant select, insert, update on gestionhospital.facturas to 'rol_recepcion';
grant select on gestionhospital.paciente to 'rol_recepcion';


-- Creacion de usuarios doctores
create user 'pcarrillo'@'localhost' identified by 'PassDoc2026!';
create user 'atorres'@'localhost' identified by 'PassDoc2026!';
create user 'rgavilanes'@'localhost' identified by 'PassDoc2026!';
create user 'aborja'@'localhost' identified by 'PassDoc2026!';
create user 'fflores'@'localhost' identified by 'PassDoc2026!';

-- Asignacion de rol a usuarios
grant 'rol_medico' to 'pcarrillo'@'localhost', 'atorres'@'localhost', 
'rgavilanes'@'localhost', 'aborja'@'localhost', 'fflores'@'localhost';

set default role all to 
    'pcarrillo'@'localhost', 
    'atorres'@'localhost', 
    'rgavilanes'@'localhost', 
    'aborja'@'localhost', 
    'fflores'@'localhost';
    
insert into usuarios (username, password_hash, rol, medico_id) values
('pcarrillo', 'hash_pepe_2026', 'medico', 1),
('atorres', 'hash_anahi_2026', 'medico', 2),
('rgavilanes', 'hash_ronny_2026', 'medico', 3),
('aborja', 'hash_amelia_2026', 'medico', 4),
('fflores', 'hash_fausto_2026', 'medico', 5);

-- Creacion de usuarios recepcion
create user 'lvalencia'@'localhost' identified by 'RecepPass01!';
create user 'jquispe'@'localhost' identified by 'RecepPass02!';
create user 'mrodriguez'@'localhost' identified by 'RecepPass03!';

grant 'rol_recepcion' to 'lvalencia'@'localhost', 
'jquispe'@'localhost', 'mrodriguez'@'localhost';

set default role all to 
    'lvalencia'@'localhost', 
    'jquispe'@'localhost', 
    'mrodriguez'@'localhost';
    
insert into usuarios (username, password_hash, rol, medico_id) values 
('lvalencia', 'hash_recep_01', 'recepcion', null),
('jquispe', 'hash_recep_02', 'recepcion', null),
('mrodriguez', 'hash_recep_03', 'recepcion', null);


-- Creacion de usuarios administradores.
create user 'mborja'@'localhost' identified by 'AdminMilka2026!';
create user 'alopez'@'localhost' identified by 'AdminAdonis2026!';

grant 'rol_admin' to 'mborja'@'localhost', 'alopez'@'localhost';

set default role all to 'mborja'@'localhost', 'alopez'@'localhost';

insert into usuarios (username, password_hash, rol, medico_id) values
('mborja', 'hash_milka_2026', 'admin', null),
('alopez', 'hash_adonis_2026', 'admin', null);



select * from usuarios;