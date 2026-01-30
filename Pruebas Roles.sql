-- ROL ADMINISTRADOR

SELECT * FROM gestionhospital.auditoria_hospital;
SELECT * FROM gestionhospital.usuarios;


-- ROL MEDICO
INSERT INTO gestionhospital.historias_clinicas (paciente_id, medico_id, diagnostico, tratamiento)
VALUES (1, 1, 'Paciente presenta cuadro febril', 'Paracetamol 500mg cada 8 horas');

SELECT * FROM gestionhospital.facturas;

-- ROL RECEPCION
UPDATE gestionhospital.facturas SET estado_pago = 'pagado' WHERE factura_id = 1;

SELECT * FROM gestionhospital.historias_clinicas;
