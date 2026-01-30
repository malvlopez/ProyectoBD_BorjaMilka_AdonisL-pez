-- MySQL dump 10.13  Distrib 9.5.0, for Win64 (x86_64)
--
-- Host: localhost    Database: gestionhospital
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria_hospital`
--

DROP TABLE IF EXISTS `auditoria_hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_hospital` (
  `auditoria_id` int NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(50) NOT NULL,
  `accion` enum('insert','update','delete') NOT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `fecha_evento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `detalles` text,
  PRIMARY KEY (`auditoria_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_hospital`
--

LOCK TABLES `auditoria_hospital` WRITE;
/*!40000 ALTER TABLE `auditoria_hospital` DISABLE KEYS */;
INSERT INTO `auditoria_hospital` VALUES (1,'paciente','insert','root@localhost','2026-01-29 02:48:26','se registro paciente con cedula: 0934567891'),(2,'historias_clinicas','update','root@localhost','2026-01-29 02:50:24','historia id: 1 | diagnostico anterior: Gripe común'),(4,'paciente','insert','root@localhost','2026-01-30 04:53:31','se registro paciente con cedula: 1712345678'),(5,'historias_clinicas','update','root@localhost','2026-01-30 04:53:38','historia id: 1 | diagnostico anterior: gripe severa con complicaciones'),(6,'citas_medicas','delete','root@localhost','2026-01-30 04:53:54','cita eliminada id: 7 del paciente id: 1');
/*!40000 ALTER TABLE `auditoria_hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citas_medicas`
--

DROP TABLE IF EXISTS `citas_medicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citas_medicas` (
  `cita_id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `medico_id` int NOT NULL,
  `fecha_cita` date NOT NULL,
  `hora_cita` time NOT NULL,
  `estado` enum('programada','completada','cancelada') DEFAULT 'programada',
  `observaciones` text,
  PRIMARY KEY (`cita_id`),
  UNIQUE KEY `medico_id` (`medico_id`,`fecha_cita`,`hora_cita`),
  KEY `fk_cita_paciente` (`paciente_id`),
  KEY `idx_citas_fecha` (`fecha_cita`),
  KEY `idx_citas_medico` (`medico_id`),
  CONSTRAINT `fk_cita_medico` FOREIGN KEY (`medico_id`) REFERENCES `medico` (`medico_id`),
  CONSTRAINT `fk_cita_paciente` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citas_medicas`
--

LOCK TABLES `citas_medicas` WRITE;
/*!40000 ALTER TABLE `citas_medicas` DISABLE KEYS */;
INSERT INTO `citas_medicas` VALUES (1,1,1,'2026-01-28','09:00:00','programada',NULL),(2,2,1,'2026-02-12','10:00:00','programada',NULL),(3,3,2,'2026-02-01','11:00:00','completada',NULL),(4,4,3,'2026-01-30','08:30:00','programada',NULL),(5,5,4,'2026-02-07','09:30:00','cancelada',NULL),(6,1,2,'2026-02-10','10:30:00','cancelada',NULL);
/*!40000 ALTER TABLE `citas_medicas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_cita_del` BEFORE DELETE ON `citas_medicas` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('citas_medicas', 'delete', user(), 
            concat('cita eliminada id: ', old.cita_id, ' del paciente id: ', old.paciente_id));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `especialidades`
--

DROP TABLE IF EXISTS `especialidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidades` (
  `especialidad_id` int NOT NULL AUTO_INCREMENT,
  `nombre_especialidad` varchar(100) NOT NULL,
  PRIMARY KEY (`especialidad_id`),
  UNIQUE KEY `nombre_especialidad` (`nombre_especialidad`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidades`
--

LOCK TABLES `especialidades` WRITE;
/*!40000 ALTER TABLE `especialidades` DISABLE KEYS */;
INSERT INTO `especialidades` VALUES (1,'Cardiología'),(5,'Ginecología'),(4,'Medicina General'),(2,'Pediatría'),(3,'Traumatología');
/*!40000 ALTER TABLE `especialidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `factura_id` int NOT NULL AUTO_INCREMENT,
  `cita_id` int NOT NULL,
  `monto_total` decimal(10,2) NOT NULL,
  `fecha_emision` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado_pago` enum('pendiente','pagado','anulado') DEFAULT 'pendiente',
  PRIMARY KEY (`factura_id`),
  UNIQUE KEY `cita_id` (`cita_id`),
  KEY `idx_factura_estado` (`estado_pago`),
  CONSTRAINT `fk_factura_cita` FOREIGN KEY (`cita_id`) REFERENCES `citas_medicas` (`cita_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
INSERT INTO `facturas` VALUES (1,1,20.00,'2026-01-28 18:52:57','pagado'),(2,3,25.00,'2026-01-28 18:52:57','pagado'),(3,4,15.00,'2026-01-28 18:52:57','pendiente'),(4,6,45.50,'2026-01-28 21:48:26','pendiente');
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_validar_factura_bi` BEFORE INSERT ON `facturas` FOR EACH ROW begin
    if new.monto_total <= 0 then
        signal sqlstate '45000' 
        set message_text = 'Error: El monto debe ser un valor numérico positivo.';
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_factura_anulacion` AFTER UPDATE ON `facturas` FOR EACH ROW begin
    if old.estado_pago <> 'anulado' and new.estado_pago = 'anulado' then
        insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        values ('facturas', 'update', user(), 
                concat('ALERTA: Factura ID ', old.factura_id, ' ANULADA. Monto: $', old.monto_total));
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `historias_clinicas`
--

DROP TABLE IF EXISTS `historias_clinicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historias_clinicas` (
  `historia_id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `medico_id` int NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `diagnostico` text NOT NULL,
  `tratamiento` text NOT NULL,
  PRIMARY KEY (`historia_id`),
  KEY `fk_historia_medico` (`medico_id`),
  KEY `idx_historia_paciente` (`paciente_id`),
  CONSTRAINT `fk_historia_medico` FOREIGN KEY (`medico_id`) REFERENCES `medico` (`medico_id`),
  CONSTRAINT `fk_historia_paciente` FOREIGN KEY (`paciente_id`) REFERENCES `paciente` (`paciente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historias_clinicas`
--

LOCK TABLES `historias_clinicas` WRITE;
/*!40000 ALTER TABLE `historias_clinicas` DISABLE KEYS */;
INSERT INTO `historias_clinicas` VALUES (1,1,1,'2026-01-28 23:52:57','Diagnóstico actualizado para prueba de auditoría','Reposo, líquidos y paracetamol'),(2,2,2,'2026-01-28 23:52:57','Dolor abdominal','Exámenes y control médico'),(3,3,3,'2026-01-28 23:52:57','Esguince leve','Reposo y antiinflamatorios'),(4,4,4,'2026-01-28 23:52:57','Control general','Chequeo de rutina'),(5,1,1,'2026-01-29 01:09:32','Infección respiratoria leve','Reposo y medicación por 5 días'),(6,1,1,'2026-01-29 02:48:26','Gripe','Reposo e hidratación'),(7,1,1,'2026-01-30 04:49:26','Paciente presenta cuadro febril','Paracetamol 500mg cada 8 horas');
/*!40000 ALTER TABLE `historias_clinicas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_historia_upd` AFTER UPDATE ON `historias_clinicas` FOR EACH ROW begin
    if old.diagnostico <> new.diagnostico then
        insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        values ('historias_clinicas', 'update', user(), 
                concat('historia id: ', old.historia_id, ' | diagnostico anterior: ', old.diagnostico));
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medico`
--

DROP TABLE IF EXISTS `medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico` (
  `medico_id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `codigo_profesional` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `especialidad_id` int DEFAULT NULL,
  PRIMARY KEY (`medico_id`),
  UNIQUE KEY `codigo_profesional` (`codigo_profesional`),
  KEY `fk_medico_especialidad` (`especialidad_id`),
  CONSTRAINT `fk_medico_especialidad` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`especialidad_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medico`
--

LOCK TABLES `medico` WRITE;
/*!40000 ALTER TABLE `medico` DISABLE KEYS */;
INSERT INTO `medico` VALUES (1,'Pepe','Carrillo','MED001','pcarrillo@gmail.com',1),(2,'Anahi','Torres','MED002','atorres@gmail.com',2),(3,'Ronny','Gavilanes','MED003','rgavilanes@gmail.com',3),(4,'Amelia','Borja','MED004','aborja@gmail.com',4),(5,'Fausto','Flores','MED005','fflores@gmail.com',5);
/*!40000 ALTER TABLE `medico` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_medico_ins` AFTER INSERT ON `medico` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('medico', 'insert', user(), concat('nuevo médico registrado: ', new.apellido, ' | código: ', new.codigo_profesional));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_medico_del` BEFORE DELETE ON `medico` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('medico', 'delete', user(), concat('eliminado médico: ', old.apellido, ' código: ', old.codigo_profesional));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `paciente`
--

DROP TABLE IF EXISTS `paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente` (
  `paciente_id` int NOT NULL AUTO_INCREMENT,
  `cedula` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero` enum('m','f','otro') DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`paciente_id`),
  UNIQUE KEY `cedula` (`cedula`),
  KEY `idx_paciente_cedula` (`cedula`),
  CONSTRAINT `chk_cedula_min` CHECK ((length(`cedula`) >= 9))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente`
--

LOCK TABLES `paciente` WRITE;
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
INSERT INTO `paciente` VALUES (1,'1702030401','Randy','Paez','1998-05-10','m','0981310131'),(2,'1702030402','Karla','Guachamin','2000-07-20','f','0991928220'),(3,'0902030403','Pavel','Valencia','1995-02-15','m','0911393633'),(4,'1702030404','Camila','Noroña','2002-09-01','f','0994104794'),(5,'0902030405','Danny','Aguilar','1988-11-30','m','0935485005'),(6,'1702030406','Katherine','	Henao','1999-04-18','f','0992460626'),(7,'1702030407','Moises','Narvaez','1990-06-25','m','0976737857'),(8,'1702030408','Mabel','Choez','2001-01-12','f','0938088088'),(9,'0902030409','Esteban','Luzuriaga','1997-08-09','m','0949569989'),(11,'0934567891','Betty','Quinto','1974-01-10','f','0985837201'),(12,'1712345678','Prueba','Paciente','1990-05-15','m','0990000000');
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_paciente_ins` AFTER INSERT ON `paciente` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('paciente', 'insert', user(), concat('se registro paciente con cedula: ', new.cedula));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `recetas`
--

DROP TABLE IF EXISTS `recetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recetas` (
  `receta_id` int NOT NULL AUTO_INCREMENT,
  `historia_id` int NOT NULL,
  `medicamento` varchar(255) NOT NULL,
  `dosis_instrucciones` text NOT NULL,
  PRIMARY KEY (`receta_id`),
  KEY `fk_receta_historia` (`historia_id`),
  CONSTRAINT `fk_receta_historia` FOREIGN KEY (`historia_id`) REFERENCES `historias_clinicas` (`historia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recetas`
--

LOCK TABLES `recetas` WRITE;
/*!40000 ALTER TABLE `recetas` DISABLE KEYS */;
INSERT INTO `recetas` VALUES (1,1,'Paracetamol 500mg','Tomar una tableta cada 8 horas por 3 días'),(2,2,'Omeprazol 20mg','Una cápsula diaria por 7 días'),(3,3,'Ibuprofeno 400mg','Cada 8 horas por 5 días');
/*!40000 ALTER TABLE `recetas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_receta_ins` AFTER INSERT ON `recetas` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('recetas', 'insert', user(), concat('receta creada para historia id: ', new.historia_id));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `usuario_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('admin','medico','recepcion') NOT NULL,
  `medico_id` int DEFAULT NULL,
  PRIMARY KEY (`usuario_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `medico_id` (`medico_id`),
  KEY `idx_usuario_rol` (`rol`),
  CONSTRAINT `fk_usuario_medico` FOREIGN KEY (`medico_id`) REFERENCES `medico` (`medico_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'pcarrillo','222133773ac05183d6590338a0ef02df3643097b989bf0fa1e317f849807172b','medico',1),(2,'atorres','a4226b6ee427636ca38aa80f5dd46ac4686640039489b9b2f265ee60dd1f655a','medico',2),(3,'rgavilanes','2c6eb7ab09d348bf6ab8ee3e4908bfd9d1e4555b01774262601fa180158b6d94','medico',3),(4,'aborja','f9bce6226aaf109cf58cc18347224aa94003ddde35973d793192ab02ada81506','medico',4),(5,'fflores','691bee6c5eb0e98f1d1e2a08206d17ee974841ffb3c23e120f8e9f35f053b345','medico',5),(6,'lvalencia','d4b893d91a572f5fe75b1f6d19a5f54ef7c340ee80b5effd7caa3fcb8501b416','recepcion',NULL),(7,'jquispe','cda197d98fb2294c0222f11fc4a29dd04067305d3ddb56a3baefed11c4870b18','recepcion',NULL),(8,'mrodriguez','e54ea51717f2da134b93b9f58387f86450b8522dd589622738f62c330cf2cf8d','recepcion',NULL),(9,'mborja','617cc98ca80e7988041b7c1525333f1d5dec0a92a559b69abf6f7842952111f1','admin',NULL),(10,'alopez','eb61f80ffb00255d8882d707eccc9ecc8819be6e21c376405393f56facf3acf1','admin',NULL);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_password_update` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
    IF old.password_hash <> new.password_hash THEN
        INSERT INTO auditoria_hospital (tabla_afectada, accion, usuario, detalles)
        VALUES ('usuarios', 'update', USER(), 
                CONCAT('Se cambió la contraseña del usuario: ', new.username));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_auditar_usuario_del` BEFORE DELETE ON `usuarios` FOR EACH ROW begin
    insert into auditoria_hospital (tabla_afectada, accion, usuario, detalles)
    values ('usuarios', 'delete', user(), concat('eliminado acceso de usuario: ', old.username));
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vista_agenda_medica`
--

DROP TABLE IF EXISTS `vista_agenda_medica`;
/*!50001 DROP VIEW IF EXISTS `vista_agenda_medica`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_agenda_medica` AS SELECT 
 1 AS `medico`,
 1 AS `apellido`,
 1 AS `fecha_cita`,
 1 AS `hora_cita`,
 1 AS `estado`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_citas_manana`
--

DROP TABLE IF EXISTS `vista_citas_manana`;
/*!50001 DROP VIEW IF EXISTS `vista_citas_manana`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_citas_manana` AS SELECT 
 1 AS `paciente`,
 1 AS `apellido`,
 1 AS `medico`,
 1 AS `nombre_especialidad`,
 1 AS `fecha_cita`,
 1 AS `hora_cita`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_facturacion`
--

DROP TABLE IF EXISTS `vista_facturacion`;
/*!50001 DROP VIEW IF EXISTS `vista_facturacion`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_facturacion` AS SELECT 
 1 AS `factura_id`,
 1 AS `monto_total`,
 1 AS `estado_pago`,
 1 AS `fecha_emision`,
 1 AS `fecha_cita`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_historial_clinico`
--

DROP TABLE IF EXISTS `vista_historial_clinico`;
/*!50001 DROP VIEW IF EXISTS `vista_historial_clinico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_historial_clinico` AS SELECT 
 1 AS `cedula`,
 1 AS `nombre`,
 1 AS `apellido`,
 1 AS `diagnostico`,
 1 AS `tratamiento`,
 1 AS `fecha_registro`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'gestionhospital'
--

--
-- Dumping routines for database 'gestionhospital'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_cedula_privada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_cedula_privada`(p_paciente_id int) RETURNS varchar(15) CHARSET utf8mb4
    DETERMINISTIC
begin
    declare v_cedula varchar(10);
    declare v_formateada varchar(15);
    select cedula into v_cedula from paciente where paciente_id = p_paciente_id;
    set v_formateada = concat(left(v_cedula, 2), 'xxxxxx', right(v_cedula, 2));
    return v_formateada;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_conteo_citas_mes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_conteo_citas_mes`(m_id int) RETURNS int
    DETERMINISTIC
begin
    declare cantidad int;
    select count(*) into cantidad 
    from citas_medicas 
    where medico_id = m_id 
    and month(fecha_cita) = month(curdate()) 
    and year(fecha_cita) = year(curdate());
    
    return cantidad;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_ingresos_medicos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_ingresos_medicos`(p_medico_id int) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
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
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_porcentaje_cancelacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_porcentaje_cancelacion`(p_medico_id int) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
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
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_sanitizar_texto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sanitizar_texto`(p_cadena varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
begin
    -- Elimina guiones dobles y puntos y comas que se usan en ataques
    declare v_limpio varchar(255);
    set v_limpio = replace(p_cadena, '--', '');
    set v_limpio = replace(v_limpio, ';', '');
    return v_limpio;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agendar_cita_completa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agendar_cita_completa`(
    in p_paciente_id int,
    in p_medico_id int,
    in p_fecha date,
    in p_hora time,
    in p_monto decimal(10,2)
)
begin
    declare exit handler for sqlexception begin rollback; end;

    start transaction;
        insert into citas_medicas (paciente_id, medico_id, fecha_cita, hora_cita)
        values (p_paciente_id, p_medico_id, p_fecha, p_hora);
        
        insert into facturas (cita_id, monto_total)
        values (last_insert_id(), p_monto);
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_consultar_expediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consultar_expediente`(in p_paciente_id int)
begin
    select h.fecha_registro, m.apellido as medico, h.diagnostico, r.medicamento
    from historias_clinicas h
    left join recetas r on h.historia_id = r.historia_id
    join medico m on h.medico_id = m.medico_id
    where h.paciente_id = p_paciente_id
    order by h.fecha_registro desc;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_consultar_historia_paciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consultar_historia_paciente`(in p_paciente_id int)
begin
    -- El tipado INT del parámetro p_paciente_id bloquea inyecciones de texto
    select h.fecha_registro, m.apellido as medico, h.diagnostico, h.tratamiento
    from historias_clinicas h
    join medico m on h.medico_id = m.medico_id
    where h.paciente_id = p_paciente_id;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_crear_medico_acceso` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_crear_medico_acceso`(
    in p_nombre varchar(100), in p_apellido varchar(100), in p_codigo varchar(20),
    in p_email varchar(100), in p_especialidad_id int, in p_username varchar(50),
    in p_password varchar(255)
)
begin
    declare exit handler for sqlexception begin rollback; end;

    start transaction;
        insert into medico (nombre, apellido, codigo_profesional, email, especialidad_id)
        values (p_nombre, p_apellido, p_codigo, p_email, p_especialidad_id);
        
        insert into usuarios (username, password_hash, rol, medico_id)
        values (p_username, sha2(p_password, 256), 'medico', last_insert_id());
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_insertar_medico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertar_medico`(
    in p_nombre varchar(100),
    in p_apellido varchar(100),
    in p_codigo varchar(20),
    in p_email varchar(100),
    in p_especialidad int
)
begin
    insert into medico (nombre, apellido, codigo_profesional, email, especialidad_id)
    values (p_nombre, p_apellido, p_codigo, p_email, p_especialidad);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_login_seguro` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login_seguro`(
    in p_username varchar(50),
    in p_password varchar(255)
)
begin
    -- Los parámetros p_ son tratados como datos, nunca como código
    select usuario_id, rol, medico_id 
    from usuarios 
    where username = p_username 
    and password_hash = sha2(p_password, 256);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_atencion_completa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_atencion_completa`(
    in p_paciente_id int, in p_medico_id int, in p_diagnostico text,
	in p_tratamiento text, in p_medicamento varchar(255), in p_dosis text
)
begin
    declare exit handler for sqlexception begin rollback; end;
    start transaction;
        insert into historias_clinicas (paciente_id, medico_id, diagnostico, tratamiento)
        values (p_paciente_id, p_medico_id, p_diagnostico, p_tratamiento);

        insert into recetas (historia_id, medicamento, dosis_instrucciones)
        values (last_insert_id(), p_medicamento, p_dosis);
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vista_agenda_medica`
--

/*!50001 DROP VIEW IF EXISTS `vista_agenda_medica`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_agenda_medica` AS select `m`.`nombre` AS `medico`,`m`.`apellido` AS `apellido`,`c`.`fecha_cita` AS `fecha_cita`,`c`.`hora_cita` AS `hora_cita`,`c`.`estado` AS `estado` from (`medico` `m` left join `citas_medicas` `c` on((`m`.`medico_id` = `c`.`medico_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_citas_manana`
--

/*!50001 DROP VIEW IF EXISTS `vista_citas_manana`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_citas_manana` AS select `p`.`nombre` AS `paciente`,`p`.`apellido` AS `apellido`,`m`.`nombre` AS `medico`,`e`.`nombre_especialidad` AS `nombre_especialidad`,`c`.`fecha_cita` AS `fecha_cita`,`c`.`hora_cita` AS `hora_cita` from (((`citas_medicas` `c` join `paciente` `p` on((`c`.`paciente_id` = `p`.`paciente_id`))) join `medico` `m` on((`c`.`medico_id` = `m`.`medico_id`))) join `especialidades` `e` on((`m`.`especialidad_id` = `e`.`especialidad_id`))) where ((`c`.`fecha_cita` = (curdate() + interval 1 day)) and (`c`.`estado` = 'programada')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_facturacion`
--

/*!50001 DROP VIEW IF EXISTS `vista_facturacion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_facturacion` AS select `f`.`factura_id` AS `factura_id`,`f`.`monto_total` AS `monto_total`,`f`.`estado_pago` AS `estado_pago`,`f`.`fecha_emision` AS `fecha_emision`,`c`.`fecha_cita` AS `fecha_cita` from (`facturas` `f` join `citas_medicas` `c` on((`f`.`cita_id` = `c`.`cita_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_historial_clinico`
--

/*!50001 DROP VIEW IF EXISTS `vista_historial_clinico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_historial_clinico` AS select `p`.`cedula` AS `cedula`,`p`.`nombre` AS `nombre`,`p`.`apellido` AS `apellido`,`h`.`diagnostico` AS `diagnostico`,`h`.`tratamiento` AS `tratamiento`,`h`.`fecha_registro` AS `fecha_registro` from (`historias_clinicas` `h` join `paciente` `p` on((`h`.`paciente_id` = `p`.`paciente_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-30  0:11:35
