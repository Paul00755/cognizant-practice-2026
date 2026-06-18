-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: college
-- ------------------------------------------------------
-- Server version	9.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '6b335f27-68ca-11f1-b232-005056c00001:1-68';

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `enrollment_year` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `email` (`email`),
  KEY `department_id` (`department_id`),
  KEY `idx_enrollment_year` (`enrollment_year`),
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'Rahul','Mehta','arjun.mehta@college.edu','2003-04-12',2,2022),(2,'Priya','Suresh','priya.suresh@college.edu','2003-07-25',1,2022),(3,'Rohan','Verma','rohan.verma@college.edu','2002-11-08',2,2021),(4,'Sneha','Patel','sneha.patel@college.edu','2004-01-30',3,2023),(5,'Vikram','Das','vikram.das@college.edu','2003-09-14',1,2022),(6,'Kavya','Menon','kavya.menon@college.edu','2002-05-17',2,2021),(7,'Aditya','Singh','aditya.singh@college.edu','2004-03-22',4,2023),(8,'Deepika','Rao','deepika.rao@college.edu','2003-08-09',1,2022),(9,'Rahul','Kumar','rahul.kumar@college.edu','2004-06-10',1,2023),(10,'Neha','Sharma','neha.sharma@college.edu','2003-11-20',2,2022);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-17 14:14:56
