CREATE DATABASE  IF NOT EXISTS `sordela` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sordela`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: 127.0.0.1    Database: sordela
-- ------------------------------------------------------
-- Server version	5.7.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '0: CFC\n1: MPT\n2: FPA\n3: TechDev\n4: TechSys',
  `course` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
INSERT INTO `challenges` VALUES (1,'ICT-304'),(2,'ICT-114'),(3,'Camp'),(4,'MA-02'),(5,'MA-22'),(6,'Anglais'),(7,'?');
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursus`
--

DROP TABLE IF EXISTS `cursus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cursus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursus`
--

LOCK TABLES `cursus` WRITE;
/*!40000 ALTER TABLE `cursus` DISABLE KEYS */;
INSERT INTO `cursus` VALUES (1,'Informaticien CFC'),(2,'Informaticien CFC avec Maturité Professionnelle Technique'),(3,'Informaticien CFC (formation accélérée)'),(4,'Tech Dev'),(5,'Tech Sys');
/*!40000 ALTER TABLE `cursus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursus_challenges`
--

DROP TABLE IF EXISTS `cursus_challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cursus_challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cursus_id` int(11) NOT NULL,
  `challenge_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fc_cursus_idx` (`cursus_id`),
  KEY `fk_challenge_idx` (`challenge_id`),
  CONSTRAINT `fc_c_cursus` FOREIGN KEY (`cursus_id`) REFERENCES `cursus` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_c_challenge` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursus_challenges`
--

LOCK TABLES `cursus_challenges` WRITE;
/*!40000 ALTER TABLE `cursus_challenges` DISABLE KEYS */;
INSERT INTO `cursus_challenges` VALUES (1,1,1),(2,2,1),(3,1,2),(4,2,2),(5,1,3),(6,2,3),(7,1,4),(8,2,4),(9,1,5),(10,2,5),(11,1,6),(12,2,6);
/*!40000 ALTER TABLE `cursus_challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `gradeValue` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gun` (`challenge_id`,`person_id`),
  KEY `fk_grade_person_idx` (`person_id`),
  KEY `fk_grade_challenge_idx` (`challenge_id`),
  CONSTRAINT `fk_grade_challenge` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_grade_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
INSERT INTO `grades` VALUES (1,1,1,2.5),(2,2,1,1.5),(12,4,1,1),(51,3,1,1),(76,1,5,4.5),(80,3,5,6),(101,1,11,6),(102,2,11,4.5),(103,4,11,4),(104,5,11,2),(105,6,1,3),(110,3,11,3),(111,6,11,6),(112,5,1,6);
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(45) NOT NULL,
  `PIN` int(11) unsigned zerofill NOT NULL,
  `cursus` int(11) NOT NULL COMMENT '1: CFC\n2: MPT\n3: FPA\n4: TechDev\n5: TechSys',
  `contact` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uname` (`nickname`),
  UNIQUE KEY `upin` (`PIN`),
  KEY `fk_p_cursus_idx` (`cursus`),
  CONSTRAINT `fk_p_cursus` FOREIGN KEY (`cursus`) REFERENCES `cursus` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (1,'Pierre',00000001111,1,'pierrot@blux.ch'),(2,'Luc',00000002222,2,NULL),(3,'Lucie',00000003333,3,'078 876 5432'),(5,'Jeremy',00000004444,1,'toto@scom.ch'),(7,'Jean-Marie',00000005548,1,'079 123 45 67'),(11,'Michel Martin',00000006369,1,'079 987 65 56'),(12,'Titeuf',00000005567,4,'');
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(500) NOT NULL,
  `response` varchar(45) DEFAULT NULL,
  `rank` int(11) NOT NULL,
  `challenge_id` int(11) NOT NULL,
  `responseType` int(11) NOT NULL DEFAULT '0' COMMENT '0: text\n1: number\n2: direct grade value ',
  PRIMARY KEY (`id`),
  KEY `fk_challenge_idx` (`challenge_id`),
  CONSTRAINT `fk_challenge` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'Quel est le dispositif de sortie principal d´un ordinateur mono-poste ?','écran',1,1,0),(2,'Quel est le meilleur système d´exploitation ?','osx',2,1,0),(3,'Quelles licences logicielles ?','cluf',3,1,0),(4,'Comment Activer les réglages pour la réduction de consommation d´énergie ?','panneau de controle',4,1,0),(5,'Qu\'est-ce que ascii ?','table',3,2,0),(6,'Quel algorithme est utilisé dans les ZIP ?','Huffmann',2,2,0),(7,'Qu\'est-ce qui permet de vérifier l\'intégrité d\'un fichier ?','Hash',1,2,0),(8,'Koh ?','Lanta',1,3,0),(9,'Combien de grammes de pâtes faut-il préparer à un ado pour le remplir ?','65',2,3,0),(10,'Quelle était la marque de la mini-moto ?','Yamaha',3,3,0),(11,'La météo était ...','Bonne',4,3,0),(12,'Dans CPU , le P c\'est pour ?','Processing',1,4,0),(13,'Dans CPU , le C c\'est pour ?','Central',2,4,0),(14,'Dans CPU , le U c\'est pour ?','Unit',3,4,0),(15,'Quel est le nom des robots Lego ?','Mindstorm',1,5,0),(16,'Combien de points avez-vous obtenu au Kahoot ?',NULL,1,6,2),(17,'Question diplôme tech dev','Schmurtz',1,7,0);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-11-20 14:48:12
