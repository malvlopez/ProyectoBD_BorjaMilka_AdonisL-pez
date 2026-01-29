-- ---------
-- Funcion, calcular el dinero total recaudado de un medico.
------------
Delimiter //
create function fn_ingresos_medicos(p_medico_id int)
returns varchar(255)
deterministic
begin
	declare total_dinero decimal (10,2);
    declare total_citas int;
    declare resultado varchar(255);
    
    select sum(f.monto_total), count(c.cita_id)
    into total_dinero, total_citas
    from citas_medicas c
    join facturas f on c.cita_id = f.cita_id
    where c.medico_id = p_medico_id and f.estado_pago = 'pagado';
    set total_dinero = ifnull(total_dinero, 0);
    set total_citas = ifnull(total_citas, 0);
    set resultado = concat ('citas: ', total_citas, 'Total: $', total_dinero);
    return resultado;
end //
delimiter ;
SELECT fn_ingresos_medicos(1) AS Reporte_Financiero;
DROP FUNCTION IF EXISTS fn_ingresos_medicos;

-- ---------
-- Funcion, cuenta las citas de un medico en el mes (futuras y pasadas)
------------
delimiter //
create function fn_conteo_citas_mes(m_id int) 
returns int
deterministic
begin
    declare cantidad int;
    select count(*) into cantidad 
    from citas_medicas 
    where medico_id = m_id 
    and month(fecha_cita) = month(curdate()) 
    and year(fecha_cita) = year(curdate());
    
    return cantidad;
end //
delimiter ;

select concat(apellido, " ", nombre), fn_conteo_citas_mes(medico_id) 
as citas_del_mes from medico;

-- ---------
-- Funcion, proteccion de cedula de paciente.
------------
delimiter //
create function fn_cedula_privada(p_paciente_id int)
returns varchar(15)
deterministic
begin
    declare v_cedula varchar(10);
    declare v_formateada varchar(15);
    select cedula into v_cedula from paciente where paciente_id = p_paciente_id;
    set v_formateada = concat(left(v_cedula, 2), 'xxxxxx', right(v_cedula, 2));
    return v_formateada;
end //
delimiter ;

select fn_cedula_privada(2) as identificacion, upper(apellido) 
as paciente from paciente; 

-- ---------
-- Funcion, porcentaje citas canceladas
------------
delimiter //
create function fn_porcentaje_cancelacion(p_medico_id int)
returns varchar(50)
deterministic
begin
    declare v_totales int;
    declare v_canceladas int;
    declare v_resultado decimal(5,2);
    select count(*) into v_totales from citas_medicas where medico_id = p_medico_id;
    select count(*) into v_canceladas from citas_medicas 
    where medico_id = p_medico_id and estado = 'cancelada';
    if v_totales > 0 then
        set v_resultado = (v_canceladas * 100) / v_totales;
        return concat(v_resultado, '% de cancelaciones');
    else
        return 'sin citas registradas';
    end if;
end //
delimiter ;
select concat(apellido, " ", nombre), fn_porcentaje_cancelacion(medico_id) 
as eficiencia from medico;
    
