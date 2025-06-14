-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: localhost    Database: gtanewbfhab
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Table structure for table `achievements`
--

DROP TABLE IF EXISTS `achievements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `achievements` (
  `uid` int DEFAULT NULL,
  `achievement` varchar(32) DEFAULT NULL,
  UNIQUE KEY `uid` (`uid`,`achievement`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievements`
--

LOCK TABLES `achievements` WRITE;
/*!40000 ALTER TABLE `achievements` DISABLE KEYS */;
INSERT INTO `achievements` VALUES (2,'Cookie jar'),(2,'First wheels'),(2,'High roller'),(2,'I\'m rich!'),(2,'Legal driver'),(2,'Obamacare'),(2,'Regular'),(3,'First wheels'),(3,'High roller'),(3,'I\'m rich!'),(4,'Addicted'),(4,'Cookie jar'),(4,'High roller'),(4,'I\'m rich!'),(4,'Regular'),(12,'High times'),(12,'Legal driver'),(14,'Addicted'),(14,'First wheels'),(14,'High roller'),(14,'I\'m rich!'),(14,'Legal driver'),(14,'Regular'),(15,'High roller'),(15,'I\'m rich!'),(15,'Legal driver');
/*!40000 ALTER TABLE `achievements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actordb`
--

DROP TABLE IF EXISTS `actordb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actordb` (
  `ID` int NOT NULL,
  `ActorName` text NOT NULL,
  `ActorVirtual` int NOT NULL,
  `ActorX` float NOT NULL,
  `ActorA` float NOT NULL,
  `ActorY` float NOT NULL,
  `ActorZ` float NOT NULL,
  `Skin` int NOT NULL,
  `AActive` int NOT NULL,
  `Text` text NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actordb`
--

LOCK TABLES `actordb` WRITE;
/*!40000 ALTER TABLE `actordb` DISABLE KEYS */;
/*!40000 ALTER TABLE `actordb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `uid` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `aName` varchar(255) NOT NULL,
  `aLevel` int NOT NULL,
  `totalReports` int NOT NULL,
  `monthlyReports` int NOT NULL,
  `weeklyReports` int NOT NULL,
  `monthlyReset` int NOT NULL,
  `weeklyReset` int NOT NULL,
  UNIQUE KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arrestpoints`
--

DROP TABLE IF EXISTS `arrestpoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `arrestpoints` (
  `id` int NOT NULL AUTO_INCREMENT,
  `PosX` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosY` float(10,5) NOT NULL DEFAULT '0.00000',
  `PosZ` float(10,5) NOT NULL DEFAULT '0.00000',
  `VW` int NOT NULL DEFAULT '0',
  `Int` int NOT NULL DEFAULT '0',
  `Type` int NOT NULL DEFAULT '0',
  `jailVW` int NOT NULL DEFAULT '0',
  `jailInt` int NOT NULL DEFAULT '0',
  `jailpos1x` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos1y` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos1z` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2x` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2y` float(10,5) NOT NULL DEFAULT '0.00000',
  `jailpos2z` float(10,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arrestpoints`
--

LOCK TABLES `arrestpoints` WRITE;
/*!40000 ALTER TABLE `arrestpoints` DISABLE KEYS */;
/*!40000 ALTER TABLE `arrestpoints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auctions`
--

DROP TABLE IF EXISTS `auctions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auctions` (
  `id` int NOT NULL,
  `BiddingFor` varchar(64) NOT NULL DEFAULT '(none)',
  `InProgress` int NOT NULL DEFAULT '0',
  `Bid` int NOT NULL DEFAULT '0',
  `Bidder` int NOT NULL DEFAULT '0',
  `Expires` int NOT NULL DEFAULT '0',
  `Wining` varchar(24) NOT NULL DEFAULT '(none)',
  `Increment` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auctions`
--

LOCK TABLES `auctions` WRITE;
/*!40000 ALTER TABLE `auctions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auctions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backpack`
--

DROP TABLE IF EXISTS `backpack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backpack` (
  `pid` int NOT NULL,
  `type` int NOT NULL,
  `store1` int DEFAULT NULL,
  `store2` int DEFAULT NULL,
  `food` int NOT NULL DEFAULT '0',
  `food2` int NOT NULL DEFAULT '0',
  `mats` int NOT NULL DEFAULT '0',
  `pot` int DEFAULT '0',
  `crack` int DEFAULT '0',
  `heroine` int DEFAULT '0',
  `weap1` varchar(50) DEFAULT NULL,
  `weap2` varchar(50) DEFAULT NULL,
  `weap3` varchar(50) DEFAULT NULL,
  `weap4` varchar(50) DEFAULT NULL,
  `weap5` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backpack`
--

LOCK TABLES `backpack` WRITE;
/*!40000 ALTER TABLE `backpack` DISABLE KEYS */;
/*!40000 ALTER TABLE `backpack` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bans`
--

DROP TABLE IF EXISTS `bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(24) DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `bannedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reason` varchar(128) DEFAULT NULL,
  `permanent` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bans`
--

LOCK TABLES `bans` WRITE;
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businesses`
--

DROP TABLE IF EXISTS `businesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `businesses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL,
  `message` varchar(128) DEFAULT '',
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT 'Nobody',
  `type` tinyint DEFAULT '0',
  `dealershiptype` int DEFAULT '0',
  `price` int DEFAULT '0',
  `entryfee` int DEFAULT '0',
  `locked` tinyint(1) DEFAULT '0',
  `timestamp` int DEFAULT '0',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `int_x` float DEFAULT '0',
  `int_y` float DEFAULT '0',
  `int_z` float DEFAULT '0',
  `int_a` float DEFAULT '0',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `displaymapicon` int NOT NULL DEFAULT '0',
  `outsideint` tinyint DEFAULT '0',
  `outsidevw` int DEFAULT '0',
  `cash` int DEFAULT '0',
  `products` int DEFAULT '500',
  `materials` int DEFAULT '0',
  `color` int DEFAULT '-256',
  `description` varchar(128) DEFAULT 'None',
  `cVehicleX` float DEFAULT '0',
  `cVehicleY` float DEFAULT '0',
  `cVehicleZ` float DEFAULT '0',
  `cVehicleA` float DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesses`
--

LOCK TABLES `businesses` WRITE;
/*!40000 ALTER TABLE `businesses` DISABLE KEYS */;
INSERT INTO `businesses` VALUES (11,'','',0,'Nobody',4,0,2500000,0,0,1565644757,1141.03,-1270.63,13.547,-125.648,363.328,-74.65,1001.51,315,10,3000011,0,0,0,0,500,0,-256,'None',0,0,0,0),(13,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1141.46,-1263.85,13.86,-121.888,316.287,-169.647,999.601,0,6,3000013,0,0,0,0,500,0,-256,'None',0,0,0,0),(15,'','',0,'Nobody',7,0,1575000,0,0,1565644757,1133.77,-1271.01,13.547,-169.202,-2240.7,128.301,1035.41,270,6,3000015,0,0,0,0,500,0,-256,'None',0,0,0,0),(16,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1128.7,-1270.99,13.547,-179.229,834.152,7.41,1004.19,90,3,3000016,0,0,0,0,500,0,-256,'None',0,0,0,0),(27,'','',0,'Nobody',2,0,2250000,0,0,1565644757,1367.32,-1384.14,13.68,92.914,204.386,-168.459,1000.52,0,14,3000027,0,0,0,0,500,0,-256,'None',0,0,0,0),(28,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1347.59,-1501,13.547,36.353,834.152,7.41,1004.19,90,3,3000028,0,0,0,0,500,0,-256,'None',0,0,0,0),(29,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1368.11,-1279.71,13.547,-107.882,315.74,-143.196,999.602,0,7,3000029,0,0,0,179900,489,0,-256,'None',0,0,0,0),(31,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1535.07,-1582.77,13.547,-164.089,316.287,-169.647,999.601,0,6,3000031,0,0,0,0,500,0,-256,'None',0,0,0,0),(32,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1492.05,-1582.88,13.547,176.811,316.287,-169.647,999.601,0,6,3000032,0,0,0,0,500,0,-256,'None',0,0,0,0),(33,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1443.51,-1582.81,13.547,179.366,316.287,-169.647,999.601,0,6,3000033,0,0,0,0,500,0,-256,'None',0,0,0,0),(35,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2258.49,-1135.32,26.901,-103.233,316.287,-169.647,999.601,0,6,3000035,0,0,0,0,500,0,-256,'None',0,0,0,0),(36,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2197.41,-1021.95,61.879,-21.629,316.287,-169.647,999.601,0,6,3000036,0,0,0,0,500,0,-256,'None',0,0,0,0),(37,'','',0,'Nobody',7,0,1575000,0,0,1565644757,2191.57,-1019.67,62.453,-27.583,-2240.7,128.301,1035.41,270,6,3000037,0,0,0,0,500,0,-256,'None',0,0,0,0),(38,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2380.75,-1196.12,27.412,93.619,316.287,-169.647,999.601,0,6,3000038,0,0,0,0,500,0,-256,'None',0,0,0,0),(39,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2352.01,-1411.92,23.992,80.481,316.287,-169.647,999.601,0,6,3000039,0,0,0,0,500,0,-256,'None',0,0,0,0),(40,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2353.54,-1533.99,24,-5.832,316.287,-169.647,999.601,0,6,3000040,0,0,0,0,500,0,-256,'None',0,0,0,0),(41,'','',0,'Nobody',4,0,2500000,0,0,1565644757,2420.14,-1509.05,24,65.777,364.854,-11.14,1001.85,0,9,3000041,0,0,0,0,500,0,-256,'None',0,0,0,0),(42,'','',0,'Nobody',3,0,1800000,0,0,1565644757,2229.54,-1721.84,13.567,143.09,772.408,-4.741,1000.73,0,5,3000042,0,0,0,48850,500,0,-256,'None',0,0,0,0),(43,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2400.49,-1981.52,13.547,-4.921,316.287,-169.647,999.601,0,6,3000043,0,0,0,0,500,0,-256,'None',0,0,0,0),(45,'','',0,'Nobody',4,0,2500000,0,0,1565644757,2397.94,-1898.64,13.547,-179.008,364.854,-11.14,1001.85,0,9,3000045,0,0,0,0,500,0,-256,'None',0,0,0,0),(46,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2423.32,-1887.18,13.547,102.719,316.287,-169.647,999.601,0,6,3000046,0,0,0,0,500,0,-256,'None',0,0,0,0),(47,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2434,-1942.27,13.547,-82.828,316.287,-169.647,999.601,0,6,3000047,0,0,0,0,500,0,-256,'None',0,0,0,0),(48,'','',0,'Nobody',1,0,2400000,0,0,1565644757,2174.84,-2164.43,13.547,-129.58,316.287,-169.647,999.601,0,6,3000048,0,0,0,0,500,0,-256,'None',0,0,0,0),(49,'','',0,'Nobody',5,0,2025000,0,0,1565644757,2172.11,-2167.13,13.547,-135.846,834.152,7.41,1004.19,90,3,3000049,0,0,0,0,500,0,-256,'None',0,0,0,0),(50,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1928.59,-1776.37,13.547,-92.958,-27.438,-57.611,1003.55,0,6,3000050,0,0,0,0,500,0,-256,'None',0,0,0,0),(51,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1296.33,-1424.56,14.953,3.884,834.152,7.41,1004.19,90,3,3000051,0,0,0,525,500,0,-256,'None',0,0,0,0),(52,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1072.03,-1604.94,13.602,-177.105,-27.438,-57.611,1003.55,0,6,3000052,0,0,0,2000,492,0,-256,'None',0,0,0,0),(53,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1076.13,-1633.38,13.588,-3.83,-27.438,-57.611,1003.55,0,6,3000053,0,0,0,0,500,0,-256,'None',0,0,0,0),(55,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1115.74,-1604.95,13.655,-176.455,-27.438,-57.611,1003.55,0,6,3000055,0,0,0,7800,498,0,-256,'None',0,0,0,0),(57,'','',0,'Nobody',2,0,2250000,0,0,1565644757,1099.29,-1633.39,13.608,-9.18,204.386,-168.459,1000.52,0,14,3000057,0,0,0,0,500,0,-256,'None',0,0,0,0),(58,'','',0,'Nobody',2,0,2250000,0,0,1565644757,1099.36,-1604.95,13.605,-179.948,204.386,-168.459,1000.52,0,14,3000058,0,0,0,1000,499,0,-256,'None',0,0,0,0),(59,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1122.29,-1633.38,13.671,1.804,-27.438,-57.611,1003.55,0,6,3000059,0,0,0,0,500,0,-256,'None',0,0,0,0),(60,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1315.57,-897.698,39.578,-178.806,-27.438,-57.611,1003.55,0,6,3000060,0,0,0,2770,495,0,-256,'None',0,0,0,0),(61,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1289.19,-1271.52,13.54,-175.396,316.287,-169.647,999.601,0,6,3000061,0,0,0,0,500,0,-256,'None',0,0,0,0),(62,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1328.14,-1271.29,13.547,178.024,834.152,7.41,1004.19,90,3,3000062,0,0,0,0,500,0,-256,'None',0,0,0,0),(63,'','',0,'Nobody',3,0,1800000,0,0,1565644757,1333.02,-1266.14,13.547,-89.855,772.408,-4.741,1000.73,0,5,3000063,0,0,0,0,500,0,-256,'None',0,0,0,0),(64,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1333.2,-1308.41,13.547,-89.228,316.287,-169.647,999.601,0,6,3000064,0,0,0,0,500,0,-256,'None',0,0,0,0),(65,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1333.22,-1329.18,13.539,-89.855,834.152,7.41,1004.19,90,3,3000065,0,0,0,0,500,0,-256,'None',0,0,0,0),(66,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1333.04,-1349.87,13.547,-89.855,316.287,-169.647,999.601,0,6,3000066,0,0,0,0,500,0,-256,'None',0,0,0,0),(70,'','',0,'Nobody',3,0,1800000,0,0,1565644757,1288.17,-1424.86,14.953,0.699,772.408,-4.741,1000.73,0,5,3000070,0,0,0,0,500,0,-256,'None',0,0,0,0),(73,'','',0,'Nobody',4,0,1800000,0,0,1565644757,1280.52,-1424.85,14.953,5.086,834.152,7.41,1004.19,90,3,3000073,0,0,0,0,500,0,-256,'None',0,0,0,0),(76,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1272.61,-1424.84,14.953,4.532,316.287,-169.647,999.601,0,6,3000076,0,0,0,0,500,0,-256,'None',0,0,0,0),(77,'','',0,'Nobody',0,0,1800000,0,0,1565644757,1264.73,-1424.84,14.953,4.146,-27.438,-57.611,1003.55,0,6,3000077,0,0,0,750,498,0,-256,'None',0,0,0,0),(79,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1311.68,-1424.65,14.953,-2.748,316.287,-169.647,999.601,0,6,3000079,0,0,0,850,499,0,-256,'None',0,0,0,0),(80,'','',0,'Nobody',4,0,2500000,0,0,1565644757,1303.77,-1424.87,14.953,2.579,363.328,-74.65,1001.51,315,10,3000080,0,0,0,90,497,0,-256,'None',0,0,0,0),(81,'','',0,'Nobody',1,0,2400000,0,0,1565644757,695.297,-1172.68,15.409,60.085,316.287,-169.647,999.601,0,6,3000081,0,0,0,0,500,0,-256,'None',0,0,0,0),(83,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1207.5,-1439.09,13.383,78.725,316.287,-169.647,999.601,0,6,3000083,0,0,0,0,500,0,-256,'None',0,0,0,0),(84,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1207.5,-1459.79,13.383,78.725,316.287,-169.647,999.601,0,6,3000084,0,0,0,0,500,0,-256,'None',0,0,0,0),(85,'','',0,'Nobody',0,0,1800000,0,0,1565644757,379.755,-2020.81,7.83,88.02,-27.438,-57.611,1003.55,0,6,3000085,0,0,0,3620,483,0,-256,'None',0,0,0,0),(86,'','',0,'Nobody',0,0,1800000,0,0,1565644757,816.375,-1386.09,13.597,-166.343,-27.438,-57.611,1003.55,0,6,3000086,0,0,0,0,500,0,-256,'None',0,0,0,0),(87,'','',0,'Nobody',1,0,2400000,0,0,1565644757,835.632,-1385.4,13.552,178.617,316.287,-169.647,999.601,0,6,3000087,0,0,0,0,500,0,-256,'None',0,0,0,0),(88,'','',0,'Nobody',1,0,2400000,0,0,1565644757,881.389,-1336.08,13.547,1.245,316.287,-169.647,999.601,0,6,3000088,0,0,0,0,500,0,-256,'None',0,0,0,0),(90,'','',0,'Nobody',4,0,2500000,0,0,1565644757,904.304,-1336.26,13.547,-4.708,363.328,-74.65,1001.51,315,10,3000090,0,0,0,0,500,0,-256,'None',0,0,0,0),(91,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1286.8,-1350,13.57,87.664,316.287,-169.647,999.601,0,6,3000091,0,0,0,0,500,0,-256,'None',0,0,0,0),(92,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1286.79,-1329.29,13.555,85.157,316.287,-169.647,999.601,0,6,3000092,0,0,0,0,500,0,-256,'None',0,0,0,0),(93,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1286.81,-1308.44,13.55,90.484,834.152,7.41,1004.19,90,3,3000093,0,0,0,0,500,0,-256,'None',0,0,0,0),(95,'','',0,'Nobody',7,0,1575000,0,0,1565644757,1319.68,-1424.89,14.971,4.943,-2240.7,128.301,1035.41,270,6,3000095,0,0,0,0,500,0,-256,'None',0,0,0,0),(97,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1370.89,-1415.61,13.553,6.126,316.287,-169.647,999.601,0,6,3000097,0,0,0,0,500,0,-256,'None',0,0,0,0),(98,'','',0,'Nobody',5,0,2025000,0,0,1565644757,1375.39,-1415.62,13.554,-4.527,834.152,7.41,1004.19,90,3,3000098,0,0,0,0,500,0,-256,'None',0,0,0,0),(99,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1367.09,-1419.63,13.547,90.414,316.287,-169.647,999.601,0,6,3000099,0,0,0,0,500,0,-256,'None',0,0,0,0),(100,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1366.81,-1423.97,13.547,88.534,316.287,-169.647,999.601,0,6,3000100,0,0,0,0,500,0,-256,'None',0,0,0,0),(101,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1366.52,-1428.32,13.547,88.534,316.287,-169.647,999.601,0,6,3000101,0,0,0,0,500,0,-256,'None',0,0,0,0),(102,'','',0,'Nobody',4,0,2500000,0,0,1565644757,1365.85,-1438.43,13.547,87.28,363.328,-74.65,1001.51,315,10,3000102,0,0,0,0,500,0,-256,'None',0,0,0,0),(103,'','',0,'Nobody',1,0,2400000,0,0,1565644757,1364.01,-1454.82,13.547,73.494,316.287,-169.647,999.601,0,6,3000103,0,0,0,0,500,0,-256,'None',0,0,0,0),(107,'','',0,'Nobody',8,0,1500000,0,0,0,1969.42,-2073.01,13.547,-81.543,1307.02,4.119,1001.03,90,18,3000107,0,0,0,0,500,0,-256,'None',1973.52,-2060.89,13.3874,89.9474),(108,'','',0,'Nobody',0,0,1800000,0,0,0,1154.69,-1439.87,15.802,93.136,-27.438,-57.611,1003.55,0,6,3000108,0,0,0,0,500,0,-256,'None',0,0,0,0),(110,'Dealership','Welcome, please use /buy to buy products.',0,'Nobody',8,2,15000000,0,0,0,1524.87,-2432.68,13.555,5.523,1494.43,1304.04,1093.29,0,3,3000110,1,0,0,0,500,0,-256,'None',1441.91,-2460.26,20.8078,8.2538),(112,'Dealership','Welcome, please use /buy to buy products.',0,'Nobody',8,1,15000000,0,0,0,231.861,-1889.04,1.264,177.897,1494.43,1304.04,1093.29,0,3,3000112,0,0,0,0,500,0,-256,'None',225.857,-1934.74,1.5621,273.412),(113,'Dealership','Welcome, please use /buy to buy products.',14,'Salvador_Tita',8,0,15000000,0,0,1617215853,2131.67,-1150.14,24.188,-177.948,1494.43,1304.04,1093.29,0,3,3000113,1,0,0,0,500,0,-256,'None',2123.56,-1131.5,25.4349,344.586),(114,'Clothes Store','Welcome, please use /buy to buy products.',0,'Nobody',2,0,2250000,0,0,0,461.714,-1500.85,31.046,109.942,204.386,-168.459,1000.52,0,14,3000114,0,0,0,3000,497,0,-256,'None',0,0,0,0),(115,'Clothes Store','Welcome, please use /buy to buy products.',0,'Nobody',2,0,2250000,0,0,0,2244.39,-1665.57,15.477,-22.408,204.386,-168.459,1000.52,0,14,3000115,0,0,0,10000,490,0,-256,'None',0,0,0,0),(116,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,2237.65,-1663.68,15.477,-18.742,-27.438,-57.611,1003.55,0,6,3000116,0,0,0,0,500,0,-256,'None',0,0,0,0),(117,'BarClub','Welcome, please use /buy to buy products.',0,'Nobody',6,0,1425000,0,0,0,2310.03,-1643.49,14.82,138.763,501.869,-68.005,998.758,179.612,11,3000117,0,0,0,0,500,0,-256,'None',0,0,0,0),(118,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,2424.35,-1742.67,13.554,72.827,-27.438,-57.611,1003.55,0,6,3000118,0,0,0,0,500,0,-256,'None',0,0,0,0),(120,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,2117.46,896.779,11.18,-19.622,-27.438,-57.611,1003.55,0,6,3000120,0,0,0,0,500,0,-256,'None',0,0,0,0),(121,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,2159.54,943.014,10.82,82.153,316.287,-169.647,999.601,0,6,3000121,0,0,0,0,500,0,-256,'None',0,0,0,0),(122,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2638.58,1671.79,11.023,91.491,363.328,-74.65,1001.51,315,10,3000122,0,0,0,0,500,0,-256,'None',0,0,0,0),(123,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2638.79,1849.92,11.023,86.365,363.328,-74.65,1001.51,315,10,3000123,0,0,0,0,500,0,-256,'None',0,0,0,0),(124,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2472.86,2034.26,11.063,83.705,363.328,-74.65,1001.51,315,10,3000124,0,0,0,0,500,0,-256,'None',0,0,0,0),(125,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,2539.54,2083.89,10.82,101.174,316.287,-169.647,999.601,0,6,3000125,0,0,0,0,500,0,-256,'None',0,0,0,0),(126,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2393.36,2041.56,10.82,-4.25,363.328,-74.65,1001.51,315,10,3000126,0,0,0,0,500,0,-256,'None',0,0,0,0),(127,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2367.05,2071.2,10.82,86.645,363.328,-74.65,1001.51,315,10,3000127,0,0,0,0,500,0,-256,'None',0,0,0,0),(128,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2101.9,2228.97,11.023,-101.563,363.328,-74.65,1001.51,315,10,3000128,0,0,0,0,500,0,-256,'None',0,0,0,0),(129,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2083.16,2224.7,11.023,160.443,363.328,-74.65,1001.51,315,10,3000129,0,0,0,0,500,0,-256,'None',0,0,0,0),(131,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,2097.48,2224.7,11.023,176.86,-27.438,-57.611,1003.55,0,6,3000131,0,0,0,0,500,0,-256,'None',0,0,0,0),(132,'Clothes Store','Welcome, please use /buy to buy products.',0,'Nobody',2,0,2250000,0,0,0,2090.49,2224.7,11.023,-172.919,204.386,-168.459,1000.52,0,14,3000132,0,0,0,0,500,0,-256,'None',0,0,0,0),(133,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,1872.25,2072.11,11.063,-93.1,363.328,-74.65,1001.51,315,10,3000133,0,0,0,0,500,0,-256,'None',0,0,0,0),(134,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,1157.92,2072.38,11.063,-100.493,363.328,-74.65,1001.51,315,10,3000134,0,0,0,0,500,0,-256,'None',0,0,0,0),(135,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,776.721,1871.3,4.901,-74.466,316.287,-169.647,999.601,0,6,3000135,0,0,0,0,500,0,-256,'None',0,0,0,0),(136,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-2336.86,-166.867,35.555,-97.815,363.328,-74.65,1001.51,315,10,3000136,0,0,0,0,500,0,-256,'None',0,0,0,0),(137,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,-2626.45,208.239,4.813,-13.737,316.287,-169.647,999.601,0,6,3000137,0,0,0,0,500,0,-256,'None',0,0,0,0),(138,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-2672.3,257.931,4.633,-15.727,363.328,-74.65,1001.51,315,10,3000138,0,0,0,0,500,0,-256,'None',0,0,0,0),(139,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,-2442.69,755.418,35.172,171.849,-27.438,-57.611,1003.55,0,6,3000139,0,0,0,0,500,0,-256,'None',0,0,0,0),(140,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-2355.82,1008.24,50.898,97.513,363.328,-74.65,1001.51,315,10,3000140,0,0,0,0,500,0,-256,'None',0,0,0,0),(141,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,-2420.16,970.041,45.297,-110.255,-27.438,-57.611,1003.55,0,6,3000141,0,0,0,0,500,0,-256,'None',0,0,0,0),(142,'Clothes Store','Welcome, please use /buy to buy products.',0,'Nobody',2,0,2250000,0,0,0,-2373.77,910.228,45.445,88.304,204.386,-168.459,1000.52,0,14,3000142,0,0,0,0,500,0,-256,'None',0,0,0,0),(144,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-1912.28,827.776,35.211,123.363,363.328,-74.65,1001.51,315,10,3000144,0,0,0,0,500,0,-256,'None',0,0,0,0),(145,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-1808.8,945.827,24.891,36.448,363.328,-74.65,1001.51,315,10,3000145,0,0,0,0,500,0,-256,'None',0,0,0,0),(146,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,-1816.87,618.685,35.172,4.298,363.328,-74.65,1001.51,315,10,3000146,0,0,0,0,500,0,-256,'None',0,0,0,0),(147,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,1833.77,-1842.29,13.578,-106.052,-27.438,-57.611,1003.55,0,6,3000147,0,0,0,0,500,0,-256,'None',0,0,0,0),(148,'Clothes Store','Welcome, please use /buy to buy products.',0,'Nobody',2,0,2250000,0,0,0,1456.46,-1137.61,23.949,-129.671,204.386,-168.459,1000.52,0,14,3000148,0,0,0,0,500,0,-256,'None',0,0,0,0),(150,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,1199.38,-918.132,43.131,17.668,363.328,-74.65,1001.51,315,10,3000150,0,0,0,160,497,0,-256,'None',0,0,0,0),(151,'Dealership','Welcome, please use /buy to buy products.',0,'Nobody',8,0,15000000,0,0,0,543.236,-1293.81,17.242,168.405,1494.43,1304.04,1093.29,0,3,3000151,0,0,0,0,500,0,-256,'None',0,0,0,0),(152,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,661.36,-573.842,16.336,-85.268,-27.438,-57.611,1003.55,0,6,3000152,0,0,0,0,500,0,-256,'None',0,0,0,0),(153,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,203.346,-201.94,1.578,1.254,363.328,-74.65,1001.51,315,10,3000153,0,0,0,0,500,0,-256,'None',0,0,0,0),(154,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,243.29,-178.516,1.582,-109.192,316.287,-169.647,999.601,0,6,3000154,0,0,0,0,500,0,-256,'None',0,0,0,0),(155,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,1367.53,248.403,19.567,-138.591,363.328,-74.65,1001.51,315,10,3000155,0,0,0,0,500,0,-256,'None',0,0,0,0),(156,'Gunstore','Welcome, please use /buy to buy products.',0,'Nobody',1,0,2400000,0,0,0,2333.09,61.317,26.706,94.264,316.287,-169.647,999.601,0,6,3000156,0,0,0,0,500,0,-256,'None',0,0,0,0),(157,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,2331.81,74.728,26.621,82.778,363.328,-74.65,1001.51,315,10,3000157,0,0,0,0,500,0,-256,'None',0,0,0,0),(158,'24/7','Welcome, please use /buy to buy products.',0,'Nobody',0,0,1800000,0,0,0,2812.48,-1626.07,11.048,82.837,-27.438,-57.611,1003.55,0,6,3000158,0,0,0,0,500,0,-256,'None',0,0,0,0),(159,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,810.488,-1616.01,13.547,96.904,363.328,-74.65,1001.51,315,10,3000159,0,0,0,380,494,0,-256,'None',0,0,0,0),(160,'Restaurant','Welcome, please use /buy to buy products.',0,'Nobody',4,0,2500000,0,0,0,928.709,-1353.01,13.344,-94.207,363.328,-74.65,1001.51,315,10,3000160,0,0,0,0,500,0,-256,'None',0,0,0,0);
/*!40000 ALTER TABLE `businesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changes`
--

DROP TABLE IF EXISTS `changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `changes` (
  `slot` tinyint DEFAULT NULL,
  `text` varchar(64) DEFAULT NULL,
  UNIQUE KEY `slot` (`slot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changes`
--

LOCK TABLES `changes` WRITE;
/*!40000 ALTER TABLE `changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charges`
--

DROP TABLE IF EXISTS `charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `chargedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reason` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charges`
--

LOCK TABLES `charges` WRITE;
/*!40000 ALTER TABLE `charges` DISABLE KEYS */;
INSERT INTO `charges` VALUES (1,10,'Derek_Smith','2019-08-12 14:39:32','noob'),(2,10,'Derek_Smith','2019-08-12 14:39:32','noob'),(3,10,'Derek_Smith','2019-08-12 14:39:33','noob'),(4,10,'Derek_Smith','2019-08-12 14:39:33','noob'),(5,10,'Derek_Smith','2019-08-12 14:39:33','noob'),(6,10,'Derek_Smith','2019-08-12 14:39:34','noob'),(7,12,'anas_morello','2021-03-30 00:51:32','fake call');
/*!40000 ALTER TABLE `charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clothing`
--

DROP TABLE IF EXISTS `clothing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clothing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `modelid` smallint DEFAULT NULL,
  `boneid` tinyint DEFAULT NULL,
  `attached` tinyint(1) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `scale_x` float DEFAULT NULL,
  `scale_y` float DEFAULT NULL,
  `scale_z` float DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clothing`
--

LOCK TABLES `clothing` WRITE;
/*!40000 ALTER TABLE `clothing` DISABLE KEYS */;
/*!40000 ALTER TABLE `clothing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crates`
--

DROP TABLE IF EXISTS `crates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crates` (
  `id` int NOT NULL,
  `Active` int NOT NULL DEFAULT '0',
  `CrateX` float NOT NULL DEFAULT '0',
  `CrateY` float NOT NULL DEFAULT '0',
  `CrateZ` float NOT NULL DEFAULT '0',
  `GunQuantity` int NOT NULL DEFAULT '50',
  `InVehicle` int NOT NULL DEFAULT '0',
  `Int` int NOT NULL DEFAULT '0',
  `VW` int NOT NULL DEFAULT '0',
  `PlacedBy` varchar(24) NOT NULL DEFAULT 'Unknown'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crates`
--

LOCK TABLES `crates` WRITE;
/*!40000 ALTER TABLE `crates` DISABLE KEYS */;
/*!40000 ALTER TABLE `crates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crews`
--

DROP TABLE IF EXISTS `crews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crews` (
  `id` tinyint DEFAULT NULL,
  `crewid` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`crewid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crews`
--

LOCK TABLES `crews` WRITE;
/*!40000 ALTER TABLE `crews` DISABLE KEYS */;
/*!40000 ALTER TABLE `crews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `criminals`
--

DROP TABLE IF EXISTS `criminals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `criminals` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `player` varchar(24) NOT NULL,
  `officer` varchar(24) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `crime` text NOT NULL,
  `served` int NOT NULL,
  `minutes` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `criminals`
--

LOCK TABLES `criminals` WRITE;
/*!40000 ALTER TABLE `criminals` DISABLE KEYS */;
INSERT INTO `criminals` VALUES (1,'Zou_louloulou','Derek_Smith','2019-08-12','14:39:34','noob',0,NULL),(2,'Mike_Zodiac','Guillem','2019-08-12','16:02:33','FK u',0,NULL),(3,'Mike_Zodiac','Guillem','2019-08-12','16:02:38','FK u',0,NULL),(4,'Mike_Zodiac','Guillem','2019-08-12','16:02:39','FK u',0,NULL),(5,'Mike_Zodiac','Guillem','2019-08-12','16:02:39','FK u',0,NULL),(6,'Mike_Zodiac','Guillem','2019-08-12','16:02:39','FK u',0,NULL),(7,'Mike_Zodiac','Guillem','2019-08-12','16:02:40','FK u',0,NULL),(8,'Booda_Khaled','anas_morello','2021-03-30','00:51:32','fake call',0,NULL);
/*!40000 ALTER TABLE `criminals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `divisions`
--

DROP TABLE IF EXISTS `divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `divisions` (
  `id` tinyint DEFAULT NULL,
  `divisionid` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`divisionid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `divisions`
--

LOCK TABLES `divisions` WRITE;
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` VALUES (1,0,'S.R.T'),(1,1,'T&R'),(1,2,'I&A'),(3,2,'I.A'),(3,3,'T&R'),(3,4,'T.T'),(3,1,'S.W.A.T'),(3,0,'H.C');
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrances`
--

DROP TABLE IF EXISTS `entrances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrances` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `iconid` smallint DEFAULT '1239',
  `locked` tinyint(1) DEFAULT '0',
  `radius` float DEFAULT '3',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `int_x` float DEFAULT '0',
  `int_y` float DEFAULT '0',
  `int_z` float DEFAULT '0',
  `int_a` float DEFAULT '0',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `outsideint` tinyint DEFAULT '0',
  `outsidevw` int DEFAULT '0',
  `adminlevel` tinyint DEFAULT '0',
  `factiontype` tinyint DEFAULT '0',
  `vip` tinyint DEFAULT '0',
  `vehicles` tinyint(1) DEFAULT '0',
  `freeze` tinyint(1) DEFAULT '0',
  `password` varchar(64) DEFAULT 'None',
  `label` tinyint(1) DEFAULT '1',
  `mapicon` tinyint NOT NULL DEFAULT '0',
  `gang` tinyint DEFAULT '-1',
  `type` tinyint DEFAULT '0',
  `color` int DEFAULT '-256',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrances`
--

LOCK TABLES `entrances` WRITE;
/*!40000 ALTER TABLE `entrances` DISABLE KEYS */;
INSERT INTO `entrances` VALUES (1,0,NULL,'Mike\'s Hideout',1239,0,3,1142.12,-1100.52,25.815,-85.817,2324.39,-1148.88,1050.71,0,12,4000001,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(2,0,NULL,'El Diablo\'',1239,0,3,2481.77,-1332.12,28.292,91.253,2324.39,-1148.88,1050.71,0,12,4000002,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(6,0,NULL,'San News',1239,0,3,649.305,-1357.33,13.567,83.345,246.666,62.462,1003.64,357.061,6,4000006,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(9,0,NULL,'FBI Interior',1239,0,3,300.683,-1549.5,76.539,91.687,-515.251,329.76,2005.66,269.478,1,4000009,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(11,0,NULL,'FBI Locker',1239,0,3,282.706,-1512.8,24.922,57.05,-512.999,315.582,2005.68,229.736,1,4000011,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(13,0,NULL,'FMD Roof',1239,0,3,1163.5,-1343.07,26.616,1.572,-2276.02,112.11,-3.937,89.555,1,4000013,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(17,0,NULL,'Jefferson',1239,0,3,2233.28,-1159.78,25.891,91.312,0,0,0,0,0,4000017,0,0,0,0,0,0,0,'None',1,12,-1,0,-256),(18,0,NULL,'Maria Beach Hotel',1239,0,3,819.913,-2078.77,12.851,152.984,814.42,-2082.67,24.59,183.572,0,4000018,0,0,0,0,0,0,0,'None',1,0,-1,0,-256),(19,0,NULL,'Church',1239,0,3,1720.21,-1740.96,13.547,176.623,2249.27,-1382.28,1500.91,20.659,2,4000019,0,0,0,0,0,0,1,'None',1,0,-1,0,-256);
/*!40000 ALTER TABLE `entrances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factionlockers`
--

DROP TABLE IF EXISTS `factionlockers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factionlockers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `factionid` tinyint DEFAULT NULL,
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `iconid` smallint DEFAULT '1239',
  `label` tinyint(1) DEFAULT '1',
  `weapon_kevlar` tinyint(1) DEFAULT '1',
  `weapon_medkit` tinyint(1) DEFAULT '1',
  `weapon_nitestick` varchar(1) DEFAULT '0',
  `weapon_mace` tinyint(1) DEFAULT '0',
  `weapon_deagle` tinyint(1) DEFAULT '1',
  `weapon_shotgun` tinyint(1) DEFAULT '1',
  `weapon_mp5` tinyint(1) DEFAULT '1',
  `weapon_m4` tinyint(1) DEFAULT '1',
  `weapon_spas12` tinyint(1) DEFAULT '1',
  `weapon_sniper` tinyint(1) DEFAULT '1',
  `weapon_camera` tinyint(1) DEFAULT '0',
  `weapon_fire_extinguisher` tinyint(1) DEFAULT '0',
  `weapon_painkillers` tinyint(1) DEFAULT '0',
  `price_kevlar` smallint DEFAULT '100',
  `price_medkit` smallint DEFAULT '50',
  `price_nitestick` smallint DEFAULT '0',
  `price_mace` smallint DEFAULT '0',
  `price_deagle` smallint DEFAULT '850',
  `price_shotgun` smallint DEFAULT '1000',
  `price_mp5` smallint DEFAULT '1500',
  `price_m4` smallint DEFAULT '2500',
  `price_spas12` smallint DEFAULT '3500',
  `price_sniper` smallint DEFAULT '5000',
  `price_camera` smallint DEFAULT '0',
  `price_fire_extinguisher` smallint DEFAULT '0',
  `price_painkillers` smallint DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factionlockers`
--

LOCK TABLES `factionlockers` WRITE;
/*!40000 ALTER TABLE `factionlockers` DISABLE KEYS */;
INSERT INTO `factionlockers` VALUES (2,1,-2292.81,89.336,-5.304,1,2,1239,1,1,1,'0',0,1,1,1,1,1,1,0,0,0,100,50,0,0,850,1000,1500,2500,3500,5000,0,0,0),(4,5,-514.908,315.784,2004.58,1,11,1239,1,1,1,'0',0,1,1,1,1,1,1,0,0,0,100,50,0,0,850,1000,1500,2500,3500,5000,0,0,0),(5,3,1575.3,-1671.51,2110.54,2,5,1239,1,1,1,'0',0,1,1,1,1,1,1,0,0,0,100,50,0,0,850,1000,1500,2500,3500,5000,0,0,0),(7,4,255.386,76.971,1003.64,6,4000006,1239,1,1,1,'0',0,1,1,1,1,1,1,0,0,0,100,50,0,0,850,1000,1500,2500,3500,5000,0,0,0),(8,2,375.803,180.771,1014.19,3,4,1239,1,1,1,'0',0,1,1,1,1,1,1,0,0,0,100,50,0,0,850,1000,1500,2500,3500,5000,0,0,0);
/*!40000 ALTER TABLE `factionlockers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factionpay`
--

DROP TABLE IF EXISTS `factionpay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factionpay` (
  `id` tinyint DEFAULT NULL,
  `rank` tinyint DEFAULT NULL,
  `amount` int DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factionpay`
--

LOCK TABLES `factionpay` WRITE;
/*!40000 ALTER TABLE `factionpay` DISABLE KEYS */;
INSERT INTO `factionpay` VALUES (1,1,2000),(1,0,1000),(1,3,4000),(1,4,10000),(1,5,5000),(1,2,3000),(1,8,6000);
/*!40000 ALTER TABLE `factionpay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factionranks`
--

DROP TABLE IF EXISTS `factionranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factionranks` (
  `id` tinyint DEFAULT NULL,
  `rank` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factionranks`
--

LOCK TABLES `factionranks` WRITE;
/*!40000 ALTER TABLE `factionranks` DISABLE KEYS */;
INSERT INTO `factionranks` VALUES (1,0,'Trainee Medic'),(1,1,'Medic'),(1,2,'Senior Medic'),(1,3,'Lead Paramedic\r\n'),(1,4,'Captain'),(1,5,'Deputy Commissioner\r\n'),(1,6,'Commissioner'),(3,0,'Cadet'),(3,1,'Police Officer'),(3,2,'Senior Officer'),(3,3,'Sergeant'),(3,4,'Captain'),(3,5,'Deputy Chief'),(3,6,'Chief of Police'),(2,6,'Mayor'),(2,5,'Asst Mayor'),(2,4,'Head Of Staff'),(2,3,'Supervisor'),(2,2,'Senior Staff'),(2,1,'Staff'),(5,6,'Director'),(5,5,'Asst Director'),(5,4,'Supervisor'),(5,3,'Asst supervisor'),(5,2,'Senior agent'),(5,1,'Agent'),(5,0,'Trainee agent'),(4,6,'Director OF News'),(4,5,'Asst Reporter'),(4,4,'Supervior'),(4,3,'Asst Supervior'),(4,2,'Senior Reporter'),(4,1,'Reporter');
/*!40000 ALTER TABLE `factionranks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factions`
--

DROP TABLE IF EXISTS `factions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factions` (
  `id` tinyint DEFAULT NULL,
  `name` varchar(48) DEFAULT NULL,
  `leader` varchar(24) DEFAULT 'No-one',
  `type` tinyint DEFAULT '0',
  `color` int DEFAULT '-1',
  `rankcount` tinyint DEFAULT '6',
  `lockerx` float DEFAULT '0',
  `lockery` float DEFAULT '0',
  `lockerz` float DEFAULT '0',
  `lockerinterior` tinyint DEFAULT '0',
  `lockerworld` int DEFAULT '0',
  `turftokens` int DEFAULT '0',
  `shortname` varchar(64) DEFAULT NULL,
  `motd` varchar(128) DEFAULT NULL,
  `budget` int DEFAULT '0',
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factions`
--

LOCK TABLES `factions` WRITE;
/*!40000 ALTER TABLE `factions` DISABLE KEYS */;
INSERT INTO `factions` VALUES (0,'Hitman agency','No-one',5,-256,7,0,0,0,0,0,0,'HMA','Keep active and join our discord discord.gg/YkES8y.',100000),(3,'Los Santos Police Department','No-one',1,8453888,7,0,0,0,0,0,2,'LSPD','Arabica Roleplay',100000),(4,'San Andreas News','No-one',3,11753728,7,0,0,0,0,0,0,'SAN','Arabica Roleplay',100000),(2,'Los Santos Government','No-one',4,-2004318208,7,0,0,0,0,0,0,'GOV','Arabica Roleplay',100000),(1,'Los Santos Fire & Medical Department','No-one',2,-8224256,7,0,0,0,0,0,0,'LSFMD','Arabica Roleplay',100000),(5,'Federal Bureau of Investigation','No-one',6,-1717960960,7,0,0,0,0,0,3,'FBI','Arabica Roleplay',100000);
/*!40000 ALTER TABLE `factions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factionskins`
--

DROP TABLE IF EXISTS `factionskins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factionskins` (
  `id` tinyint DEFAULT NULL,
  `slot` tinyint DEFAULT NULL,
  `skinid` smallint DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`slot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factionskins`
--

LOCK TABLES `factionskins` WRITE;
/*!40000 ALTER TABLE `factionskins` DISABLE KEYS */;
INSERT INTO `factionskins` VALUES (1,0,274),(1,1,275),(1,2,276),(1,3,277),(1,4,278),(1,5,279),(1,6,295),(3,0,71),(3,1,280),(3,2,281),(3,3,283),(3,4,284),(3,5,285),(3,6,288);
/*!40000 ALTER TABLE `factionskins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `flaggedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
INSERT INTO `flags` VALUES (1,12,'Server','2021-03-31 21:38:49','Allhunt winner');
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `furniture`
--

DROP TABLE IF EXISTS `furniture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `furniture` (
  `id` int NOT NULL AUTO_INCREMENT,
  `houseid` int DEFAULT NULL,
  `modelid` smallint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `interior` tinyint DEFAULT NULL,
  `world` int DEFAULT NULL,
  `door_opened` tinyint(1) DEFAULT '0',
  `door_locked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `furniture`
--

LOCK TABLES `furniture` WRITE;
/*!40000 ALTER TABLE `furniture` DISABLE KEYS */;
/*!40000 ALTER TABLE `furniture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gangranks`
--

DROP TABLE IF EXISTS `gangranks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gangranks` (
  `id` tinyint DEFAULT NULL,
  `rank` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`rank`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gangranks`
--

LOCK TABLES `gangranks` WRITE;
/*!40000 ALTER TABLE `gangranks` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangranks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gangs`
--

DROP TABLE IF EXISTS `gangs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gangs` (
  `id` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT 'None',
  `motd` varchar(128) DEFAULT 'None',
  `leader` varchar(24) DEFAULT 'No-one',
  `color` int DEFAULT '-256',
  `strikes` tinyint(1) DEFAULT '0',
  `level` tinyint DEFAULT '1',
  `points` int DEFAULT '0',
  `turftokens` int DEFAULT '0',
  `stash_x` float DEFAULT '0',
  `stash_y` float DEFAULT '0',
  `stash_z` float DEFAULT '0',
  `stashinterior` tinyint DEFAULT '0',
  `stashworld` int DEFAULT '0',
  `cash` int DEFAULT '0',
  `materials` int DEFAULT '0',
  `weed` int DEFAULT '0',
  `cocaine` int DEFAULT '0',
  `meth` int DEFAULT '0',
  `painkillers` int DEFAULT '0',
  `pistolammo` int DEFAULT '0',
  `shotgunammo` int DEFAULT '0',
  `smgammo` int DEFAULT '0',
  `arammo` int DEFAULT '0',
  `rifleammo` int DEFAULT '0',
  `hpammo` int DEFAULT '0',
  `poisonammo` int DEFAULT '0',
  `fmjammo` int DEFAULT '0',
  `weapon_9mm` int DEFAULT '0',
  `weapon_sdpistol` int DEFAULT '0',
  `weapon_deagle` int DEFAULT '0',
  `weapon_shotgun` int DEFAULT '0',
  `weapon_spas12` int DEFAULT '0',
  `weapon_sawnoff` int DEFAULT '0',
  `weapon_tec9` int DEFAULT '0',
  `weapon_uzi` int DEFAULT '0',
  `weapon_mp5` int DEFAULT '0',
  `weapon_ak47` int DEFAULT '0',
  `weapon_m4` int DEFAULT '0',
  `weapon_rifle` int DEFAULT '0',
  `weapon_sniper` int DEFAULT '0',
  `weapon_molotov` int DEFAULT '0',
  `armsdealer` tinyint(1) DEFAULT '0',
  `drugdealer` tinyint(1) DEFAULT '0',
  `arms_x` float DEFAULT '0',
  `arms_y` float DEFAULT '0',
  `arms_z` float DEFAULT '0',
  `arms_a` float DEFAULT '0',
  `drug_x` float DEFAULT '0',
  `drug_y` float DEFAULT '0',
  `drug_z` float DEFAULT '0',
  `drug_a` float DEFAULT '0',
  `armsworld` int DEFAULT '0',
  `drugworld` int DEFAULT '0',
  `drugweed` int DEFAULT '0',
  `drugcocaine` int DEFAULT '0',
  `drugmeth` int DEFAULT '0',
  `armsmaterials` int DEFAULT '0',
  `armsprice_1` int DEFAULT '0',
  `armsprice_2` int DEFAULT '0',
  `armsprice_3` int DEFAULT '0',
  `armsprice_4` int DEFAULT '0',
  `armsprice_5` int DEFAULT '0',
  `armsprice_6` int DEFAULT '0',
  `armsprice_7` int DEFAULT '0',
  `armsprice_8` int DEFAULT '0',
  `armsprice_9` int NOT NULL DEFAULT '0',
  `armsprice_10` int NOT NULL DEFAULT '0',
  `armsprice_11` int NOT NULL DEFAULT '0',
  `armsprice_12` tinyint NOT NULL DEFAULT '0',
  `weed_price` int DEFAULT '0',
  `cocaine_price` int DEFAULT '0',
  `meth_price` int DEFAULT '0',
  `matlevel` tinyint NOT NULL DEFAULT '0',
  `gunlevel` tinyint NOT NULL DEFAULT '0',
  `alliance` tinyint NOT NULL DEFAULT '-1',
  `rivals` tinyint DEFAULT '-1',
  `war1` tinyint NOT NULL DEFAULT '0',
  `war2` tinyint NOT NULL DEFAULT '0',
  `war3` tinyint NOT NULL DEFAULT '0',
  `rank_9mm` tinyint NOT NULL DEFAULT '1',
  `rank_sdpistol` tinyint NOT NULL DEFAULT '1',
  `rank_deagle` tinyint NOT NULL DEFAULT '2',
  `rank_shotgun` tinyint NOT NULL DEFAULT '1',
  `rank_spas12` tinyint NOT NULL DEFAULT '4',
  `rank_sawnoff` tinyint NOT NULL DEFAULT '4',
  `rank_tec9` tinyint NOT NULL DEFAULT '1',
  `rank_uzi` tinyint NOT NULL DEFAULT '1',
  `rank_mp5` tinyint NOT NULL DEFAULT '2',
  `rank_ak47` tinyint NOT NULL DEFAULT '3',
  `rank_m4` tinyint NOT NULL DEFAULT '4',
  `rank_rifle` tinyint NOT NULL DEFAULT '2',
  `rank_sniper` tinyint NOT NULL DEFAULT '5',
  `rank_molotov` tinyint NOT NULL DEFAULT '5',
  `rank_vest` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gangs`
--

LOCK TABLES `gangs` WRITE;
/*!40000 ALTER TABLE `gangs` DISABLE KEYS */;
INSERT INTO `gangs` VALUES (0,'Grove Street','GROVE STREET FTW','No-one',16728832,0,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,0,1,1,2,1,4,4,1,1,2,3,4,2,5,5,0);
/*!40000 ALTER TABLE `gangs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gangskins`
--

DROP TABLE IF EXISTS `gangskins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gangskins` (
  `id` tinyint DEFAULT NULL,
  `slot` tinyint DEFAULT NULL,
  `skinid` smallint DEFAULT NULL,
  UNIQUE KEY `id` (`id`,`slot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gangskins`
--

LOCK TABLES `gangskins` WRITE;
/*!40000 ALTER TABLE `gangskins` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangskins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gangsold`
--

DROP TABLE IF EXISTS `gangsold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gangsold` (
  `id` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT 'None',
  `motd` varchar(128) DEFAULT 'None',
  `leader` varchar(24) DEFAULT 'No-one',
  `color` int DEFAULT '-256',
  `strikes` tinyint(1) DEFAULT '0',
  `level` tinyint DEFAULT '1',
  `points` int DEFAULT '0',
  `turftokens` int DEFAULT '0',
  `stash_x` float DEFAULT '0',
  `stash_y` float DEFAULT '0',
  `stash_z` float DEFAULT '0',
  `stashinterior` tinyint DEFAULT '0',
  `stashworld` int DEFAULT '0',
  `cash` int DEFAULT '0',
  `materials` int DEFAULT '0',
  `weed` int DEFAULT '0',
  `cocaine` int DEFAULT '0',
  `meth` int DEFAULT '0',
  `painkillers` int DEFAULT '0',
  `pistolammo` int DEFAULT '0',
  `shotgunammo` int DEFAULT '0',
  `smgammo` int DEFAULT '0',
  `arammo` int DEFAULT '0',
  `rifleammo` int DEFAULT '0',
  `hpammo` int DEFAULT '0',
  `poisonammo` int DEFAULT '0',
  `fmjammo` int DEFAULT '0',
  `weapon_9mm` int DEFAULT '0',
  `weapon_sdpistol` int DEFAULT '0',
  `weapon_deagle` int DEFAULT '0',
  `weapon_shotgun` int DEFAULT '0',
  `weapon_spas12` int DEFAULT '0',
  `weapon_sawnoff` int DEFAULT '0',
  `weapon_tec9` int DEFAULT '0',
  `weapon_uzi` int DEFAULT '0',
  `weapon_mp5` int DEFAULT '0',
  `weapon_ak47` int DEFAULT '0',
  `weapon_m4` int DEFAULT '0',
  `weapon_rifle` int DEFAULT '0',
  `weapon_sniper` int DEFAULT '0',
  `weapon_molotov` int DEFAULT '0',
  `armsdealer` tinyint(1) DEFAULT '0',
  `drugdealer` tinyint(1) DEFAULT '0',
  `arms_x` float DEFAULT '0',
  `arms_y` float DEFAULT '0',
  `arms_z` float DEFAULT '0',
  `arms_a` float DEFAULT '0',
  `drug_x` float DEFAULT '0',
  `drug_y` float DEFAULT '0',
  `drug_z` float DEFAULT '0',
  `drug_a` float DEFAULT '0',
  `armsworld` int DEFAULT '0',
  `drugworld` int DEFAULT '0',
  `drugweed` int DEFAULT '0',
  `drugcocaine` int DEFAULT '0',
  `drugmeth` int DEFAULT '0',
  `armsmaterials` int DEFAULT '0',
  `armsprice_1` int DEFAULT '0',
  `armsprice_2` int DEFAULT '0',
  `armsprice_3` int DEFAULT '0',
  `armsprice_4` int DEFAULT '0',
  `armsprice_5` int DEFAULT '0',
  `armsprice_6` int DEFAULT '0',
  `armsprice_7` int DEFAULT '0',
  `armsprice_8` int DEFAULT '0',
  `armsprice_9` int NOT NULL DEFAULT '0',
  `armsprice_10` int NOT NULL DEFAULT '0',
  `armsprice_11` int NOT NULL DEFAULT '0',
  `armsprice_12` tinyint NOT NULL DEFAULT '0',
  `weed_price` int DEFAULT '0',
  `cocaine_price` int DEFAULT '0',
  `meth_price` int DEFAULT '0',
  `matlevel` tinyint NOT NULL DEFAULT '0',
  `gunlevel` tinyint NOT NULL DEFAULT '0',
  `alliance` tinyint NOT NULL DEFAULT '-1',
  `war1` tinyint NOT NULL DEFAULT '0',
  `war2` tinyint NOT NULL DEFAULT '0',
  `war3` tinyint NOT NULL DEFAULT '0',
  `rank_9mm` tinyint NOT NULL DEFAULT '1',
  `rank_sdpistol` tinyint NOT NULL DEFAULT '1',
  `rank_deagle` tinyint NOT NULL DEFAULT '2',
  `rank_shotgun` tinyint NOT NULL DEFAULT '1',
  `rank_spas12` tinyint NOT NULL DEFAULT '4',
  `rank_sawnoff` tinyint NOT NULL DEFAULT '4',
  `rank_tec9` tinyint NOT NULL DEFAULT '1',
  `rank_uzi` tinyint NOT NULL DEFAULT '1',
  `rank_mp5` tinyint NOT NULL DEFAULT '2',
  `rank_ak47` tinyint NOT NULL DEFAULT '3',
  `rank_m4` tinyint NOT NULL DEFAULT '4',
  `rank_rifle` tinyint NOT NULL DEFAULT '2',
  `rank_sniper` tinyint NOT NULL DEFAULT '5',
  `rank_molotov` tinyint NOT NULL DEFAULT '5',
  `rank_vest` tinyint NOT NULL DEFAULT '0',
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gangsold`
--

LOCK TABLES `gangsold` WRITE;
/*!40000 ALTER TABLE `gangsold` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangsold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gangtags`
--

DROP TABLE IF EXISTS `gangtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gangtags` (
  `gangid` int NOT NULL,
  `text` text NOT NULL,
  `fontid` int NOT NULL,
  `pname` text NOT NULL,
  `color` int NOT NULL,
  `x` float(11,4) NOT NULL DEFAULT '0.0000',
  `y` float(11,4) NOT NULL DEFAULT '0.0000',
  `z` float(11,4) NOT NULL DEFAULT '0.0000',
  `rx` float(11,4) NOT NULL DEFAULT '0.0000',
  `ry` float(11,4) NOT NULL DEFAULT '0.0000',
  `rz` float(11,4) NOT NULL DEFAULT '0.0000',
  `ID` int NOT NULL,
  `pdbid` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gangtags`
--

LOCK TABLES `gangtags` WRITE;
/*!40000 ALTER TABLE `gangtags` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `garages`
--

DROP TABLE IF EXISTS `garages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `garages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT NULL,
  `type` tinyint(1) DEFAULT '0',
  `price` int DEFAULT '0',
  `locked` tinyint(1) DEFAULT '0',
  `freeze` tinyint(1) NOT NULL DEFAULT '0',
  `timestamp` int DEFAULT '0',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `exit_x` float DEFAULT '0',
  `exit_y` float DEFAULT '0',
  `exit_z` float DEFAULT '0',
  `exit_a` float DEFAULT '0',
  `world` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `garages`
--

LOCK TABLES `garages` WRITE;
/*!40000 ALTER TABLE `garages` DISABLE KEYS */;
INSERT INTO `garages` VALUES (2,0,'Nobody',1,175000,0,0,1565644757,1007.84,-665.01,121.143,210.731,1006.3,-662.432,121.143,30.731,2000002),(3,0,'Nobody',0,125000,0,0,1565644757,1012.78,-661.615,121.139,214.805,1011.06,-659.152,121.139,34.805,2000003),(4,3,'Guillem_El_Chapo',1,175000,0,0,1565693494,894.155,-1516.74,12.811,2.028,894.261,-1519.74,12.811,-177.972,2000004);
/*!40000 ALTER TABLE `garages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gates`
--

DROP TABLE IF EXISTS `gates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gates` (
  `ID` int NOT NULL,
  `HID` int NOT NULL DEFAULT '-1',
  `Speed` float NOT NULL DEFAULT '10',
  `Range` float NOT NULL DEFAULT '10',
  `Model` int NOT NULL DEFAULT '18631',
  `VW` int NOT NULL DEFAULT '0',
  `Int` int NOT NULL DEFAULT '0',
  `Pass` varchar(24) NOT NULL DEFAULT '',
  `PosX` float NOT NULL DEFAULT '0',
  `PosY` float NOT NULL DEFAULT '0',
  `PosZ` float NOT NULL DEFAULT '0',
  `RotX` float NOT NULL DEFAULT '0',
  `RotY` float NOT NULL DEFAULT '0',
  `RotZ` float NOT NULL DEFAULT '0',
  `PosXM` float NOT NULL DEFAULT '0',
  `PosYM` float NOT NULL DEFAULT '0',
  `PosZM` float NOT NULL DEFAULT '0',
  `RotXM` float NOT NULL DEFAULT '0',
  `RotYM` float NOT NULL DEFAULT '0',
  `RotZM` float NOT NULL DEFAULT '0',
  `Allegiance` int NOT NULL DEFAULT '0',
  `GroupType` int NOT NULL DEFAULT '0',
  `GroupID` int NOT NULL DEFAULT '-1',
  `GangID` int NOT NULL DEFAULT '-1',
  `RenderHQ` int NOT NULL DEFAULT '1',
  `Timer` int NOT NULL DEFAULT '0',
  `Automate` int NOT NULL,
  `Locked` int NOT NULL,
  `TIndex` int NOT NULL,
  `TModel` int NOT NULL,
  `TColor` int NOT NULL,
  `Facility` int NOT NULL,
  `TTXD` varchar(32) NOT NULL,
  `TTexture` varchar(42) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gates`
--

LOCK TABLES `gates` WRITE;
/*!40000 ALTER TABLE `gates` DISABLE KEYS */;
/*!40000 ALTER TABLE `gates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graffiti`
--

DROP TABLE IF EXISTS `graffiti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graffiti` (
  `graffitiID` int NOT NULL AUTO_INCREMENT,
  `graffitiX` float DEFAULT '0',
  `graffitiY` float DEFAULT '0',
  `graffitiZ` float DEFAULT '0',
  `graffitiAngle` float DEFAULT '0',
  `graffitiColor` int DEFAULT '0',
  `graffitiText` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`graffitiID`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graffiti`
--

LOCK TABLES `graffiti` WRITE;
/*!40000 ALTER TABLE `graffiti` DISABLE KEYS */;
/*!40000 ALTER TABLE `graffiti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gunracks`
--

DROP TABLE IF EXISTS `gunracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gunracks` (
  `rackID` int NOT NULL AUTO_INCREMENT,
  `rackHouse` int DEFAULT '0',
  `rackX` float DEFAULT '0',
  `rackY` float DEFAULT '0',
  `rackZ` float DEFAULT '0',
  `rackA` float DEFAULT '0',
  `rackInterior` int DEFAULT '0',
  `rackWorld` int DEFAULT '0',
  `rackWeapon1` int DEFAULT '0',
  `rackAmmo1` int DEFAULT '0',
  `rackWeapon2` int DEFAULT '0',
  `rackAmmo2` int DEFAULT '0',
  `rackWeapon3` int DEFAULT '0',
  `rackAmmo3` int DEFAULT '0',
  `rackWeapon4` int DEFAULT '0',
  `rackAmmo4` int DEFAULT '0',
  PRIMARY KEY (`rackID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gunracks`
--

LOCK TABLES `gunracks` WRITE;
/*!40000 ALTER TABLE `gunracks` DISABLE KEYS */;
/*!40000 ALTER TABLE `gunracks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT 'Nobody',
  `type` tinyint DEFAULT '0',
  `price` int DEFAULT '0',
  `rentprice` int DEFAULT '0',
  `level` tinyint DEFAULT '1',
  `locked` tinyint(1) DEFAULT '0',
  `timestamp` int DEFAULT '0',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `int_x` float DEFAULT '0',
  `int_y` float DEFAULT '0',
  `int_z` float DEFAULT '0',
  `int_a` float DEFAULT '0',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `outsideint` int DEFAULT '0',
  `outsidevw` int DEFAULT '0',
  `cash` int DEFAULT '0',
  `materials` int DEFAULT '0',
  `weed` int DEFAULT '0',
  `cocaine` int DEFAULT '0',
  `meth` int DEFAULT '0',
  `painkillers` int DEFAULT '0',
  `weapon_1` tinyint DEFAULT '0',
  `weapon_2` tinyint DEFAULT '0',
  `weapon_3` tinyint DEFAULT '0',
  `weapon_4` tinyint DEFAULT '0',
  `weapon_5` tinyint DEFAULT '0',
  `weapon_6` tinyint DEFAULT '0',
  `weapon_7` tinyint DEFAULT '0',
  `weapon_8` tinyint DEFAULT '0',
  `weapon_9` tinyint DEFAULT '0',
  `weapon_10` tinyint DEFAULT '0',
  `ammo_1` smallint DEFAULT '0',
  `ammo_2` smallint DEFAULT '0',
  `ammo_3` smallint DEFAULT '0',
  `ammo_4` smallint DEFAULT '0',
  `ammo_5` smallint DEFAULT '0',
  `ammo_6` tinyint DEFAULT '0',
  `ammo_7` tinyint DEFAULT '0',
  `ammo_8` tinyint DEFAULT '0',
  `ammo_9` tinyint DEFAULT '0',
  `ammo_10` tinyint DEFAULT '0',
  `pistolammo` smallint DEFAULT '0',
  `shotgunammo` smallint DEFAULT '0',
  `smgammo` smallint DEFAULT '0',
  `arammo` smallint DEFAULT '0',
  `rifleammo` smallint DEFAULT '0',
  `hpammo` smallint DEFAULT '0',
  `poisonammo` smallint DEFAULT '0',
  `fmjammo` smallint DEFAULT '0',
  `delivery` tinyint DEFAULT '1',
  `lights` tinyint(1) DEFAULT '1',
  `alarm` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `houses`
--

LOCK TABLES `houses` WRITE;
/*!40000 ALTER TABLE `houses` DISABLE KEYS */;
INSERT INTO `houses` VALUES (5,0,'Nobody',14,300000,0,1,0,1565644757,1368.44,-1432.23,14.055,88.779,2324.39,-1148.88,1050.71,0,12,1000005,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(6,0,'Nobody',17,500000,0,1,0,1565644757,1142.12,-1092.81,28.188,-93.287,925.01,-496.81,843.895,90,7,1000006,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(8,0,'Nobody',17,750000,0,1,0,1565644757,946.384,-710.655,122.62,24.505,925.01,-496.81,843.895,90,7,1000008,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(9,0,'Nobody',16,750000,0,1,0,1565644757,980.485,-677.265,121.976,31.335,1834.24,-1278.77,832.16,180,1,1000009,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(10,0,'Nobody',15,300000,0,1,0,1565644757,691.579,-1275.92,13.561,87.659,1282.06,-1140.21,980.052,0,4,1000010,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(11,0,'Nobody',0,100000,0,1,0,1565644757,1408.13,-1385.61,13.572,353.811,244.2,305.068,999.148,270.219,1,1000011,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0),(13,3,'Guillem_El_Chapo',17,500000,0,1,0,1565693473,901.706,-1514.67,14.364,-178.912,925.01,-496.81,843.895,90,7,1000013,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0);
/*!40000 ALTER TABLE `houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `impoundlots`
--

DROP TABLE IF EXISTS `impoundlots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `impoundlots` (
  `impoundID` int NOT NULL AUTO_INCREMENT,
  `impoundLotX` float NOT NULL,
  `impoundLotY` float NOT NULL,
  `impoundLotZ` float NOT NULL,
  `impoundReleaseX` float NOT NULL,
  `impoundReleaseY` float NOT NULL,
  `impoundReleaseZ` float NOT NULL,
  `impoundReleaseA` float NOT NULL,
  PRIMARY KEY (`impoundID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `impoundlots`
--

LOCK TABLES `impoundlots` WRITE;
/*!40000 ALTER TABLE `impoundlots` DISABLE KEYS */;
/*!40000 ALTER TABLE `impoundlots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kills`
--

DROP TABLE IF EXISTS `kills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `killer_uid` int DEFAULT NULL,
  `target_uid` int DEFAULT NULL,
  `killer` varchar(24) DEFAULT NULL,
  `target` varchar(24) DEFAULT NULL,
  `reason` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kills`
--

LOCK TABLES `kills` WRITE;
/*!40000 ALTER TABLE `kills` DISABLE KEYS */;
INSERT INTO `kills` VALUES (1,4,3,'Derek_Smith','Guillem_Moskow','Fists','2019-08-11 21:13:03'),(2,4,2,'Derek_Smith','Mike_Zodiac','Desert Eagle','2019-08-11 22:18:29'),(3,4,2,'Derek_Smith','Mike_Zodiac','Sniper Rifle','2019-08-11 22:19:47'),(4,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-11 22:37:54'),(5,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-11 22:45:31'),(6,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-11 22:48:24'),(7,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-11 22:50:18'),(8,4,3,'Derek_Smith','John_Maxwell','Combat Shotgun','2019-08-11 23:21:45'),(9,4,2,'Derek_Smith','Mike_Zodiac','UZI','2019-08-11 23:30:26'),(10,4,2,'Derek_Smith','Mike_Zodiac','Knife','2019-08-11 23:32:15'),(11,4,2,'Derek_Smith','Mike_Zodiac','Knife','2019-08-11 23:32:49'),(12,4,3,'Derek_Smith','John_Maxwell','Combat Shotgun','2019-08-11 23:33:30'),(13,4,2,'Derek_Smith','Mike_Zodiac','Combat Shotgun','2019-08-11 23:35:11'),(14,4,3,'Derek_Smith','John_Maxwell','Knife','2019-08-11 23:35:41'),(15,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-11 23:39:09'),(16,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 13:50:20'),(17,4,3,'Derek_Smith','Guillem_El_Chapo','Sniper Rifle','2019-08-12 13:51:56'),(18,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 13:53:31'),(19,4,3,'Derek_Smith','Guillem_El_Chapo','Sniper Rifle','2019-08-12 13:53:51'),(20,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 13:54:56'),(21,3,4,'Guillem_El_Chapo','Derek_Smith','Desert Eagle','2019-08-12 13:57:29'),(22,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:02:20'),(23,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:03:25'),(24,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:09:38'),(25,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:09:54'),(26,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:12:27'),(27,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:12:42'),(28,4,3,'Derek_Smith','Guillem_El_Chapo','Sniper Rifle','2019-08-12 14:12:52'),(29,4,3,'Derek_Smith','Guillem_El_Chapo','Desert Eagle','2019-08-12 14:14:20'),(30,4,3,'Derek_Smith','Guillem_El_Chapo','Explosion','2019-08-12 14:41:39'),(31,10,4,'Zou_louloulou','Derek_Smith','Shotgun','2019-08-12 14:42:08'),(32,12,3,'booda_Khaled','Guillem_El_Chapo','Desert Eagle','2019-08-12 18:56:11'),(33,12,3,'booda_Khaled','Guillem_El_Chapo','Desert Eagle','2019-08-12 18:59:50'),(34,2,3,'Mike_Zodiac','Guillem_El_Chapo','Desert Eagle','2019-08-12 19:12:08'),(35,2,3,'Mike_Zodiac','Guillem_El_Chapo','Desert Eagle','2019-08-12 19:12:54'),(36,2,12,'Mike_Zodiac','booda_Khaled','Desert Eagle','2019-08-12 19:33:55'),(37,2,3,'Mike_Zodiac','Guillem_El_Chapo','Sniper Rifle','2019-08-12 19:34:17'),(38,2,3,'Mike_Zodiac','Guillem_El_Chapo','Sniper Rifle','2019-08-12 19:35:02'),(39,12,4,'booda_Khaled','Derek_Smith','Explosion','2019-08-12 20:00:10'),(40,2,12,'Mike_Zodiac','booda_Khaled','Fists','2019-08-12 20:00:10'),(41,12,2,'booda_Khaled','Mike_Zodiac','Explosion','2019-08-12 20:00:29'),(42,2,4,'Mike_Zodiac','Derek_Smith','Desert Eagle','2019-08-12 20:01:59'),(43,4,12,'Derek_Smith','booda_Khaled','Desert Eagle','2019-08-12 20:02:51'),(44,4,12,'Derek_Smith','booda_Khaled','Desert Eagle','2019-08-12 20:03:13'),(45,4,2,'Derek_Smith','Mike_Zodiac','Sniper Rifle','2019-08-12 20:03:34'),(46,4,12,'Derek_Smith','booda_Khaled','Desert Eagle','2019-08-12 20:04:07'),(47,4,2,'Derek_Smith','Mike_Zodiac','Desert Eagle','2019-08-12 20:04:38'),(48,3,4,'Guillem_El_Chapo','booda_noob','Explosion','2019-08-12 20:09:34'),(49,3,12,'Guillem_El_Chapo','Booda_khaled','Explosion','2019-08-12 20:09:34'),(50,2,4,'Mike_Zodiac','booda_noob','Explosion','2019-08-12 20:10:08'),(51,2,3,'Mike_Zodiac','Guillem_El_Chapo','Explosion','2019-08-12 20:10:12'),(52,2,12,'Mike_Zodiac','Booda_Khaled','Explosion','2019-08-12 20:12:57'),(53,2,3,'Mike_Zodiac','Guillem_El_Chapo','Explosion','2019-08-12 20:13:01'),(54,2,13,'Mike_Zodiac','Derek_Smith','Explosion','2019-08-12 20:13:33'),(55,2,3,'Mike_Zodiac','Guillem_El_Chapo','Explosion','2019-08-12 20:13:43'),(56,12,3,'Booda_Khaled','Guillem_El_Chapo','Helicopter Blades','2019-08-12 20:57:09'),(57,12,3,'Booda_Khaled','Guillem_El_Chapo','Helicopter Blades','2019-08-12 20:57:33'),(58,12,3,'Booda_Khaled','Guillem_El_Chapo','Explosion','2019-08-12 22:01:11'),(59,4,12,'Derek_Smith','booda_Khaled','Desert Eagle','2019-08-12 23:25:54'),(60,2,12,'Zoldic','booda_Khaled','Explosion','2019-08-12 23:27:27'),(61,2,4,'Zoldic','Derek_Smith','Explosion','2019-08-12 23:27:31'),(62,4,2,'Derek_Smith','Mike_Zodiac','Fists','2019-08-13 00:02:32'),(63,12,4,'booda_Khaled','Derek_Smith','Fists','2019-08-13 00:04:49'),(64,2,12,'Mike_Zodiac','booda_Khaled','Fists','2019-08-13 00:04:51'),(65,4,2,'Derek_Smith','Mike_Zodiac','Fists','2019-08-13 00:04:55'),(66,2,12,'Mike_Zodiac','booda_Khaled','Explosion','2019-08-13 00:05:11'),(67,2,4,'Mike_Zodiac','Derek_Smith','Explosion','2019-08-13 00:05:28'),(68,4,2,'Derek_Smith','Mike_Zodiac','Fists','2019-08-13 00:07:36'),(69,2,12,'Mike_Zodiac','booda_Khaled','Explosion','2019-08-13 00:28:26'),(70,2,12,'Mike_Zodiac','booda_Khaled','Explosion','2019-08-13 00:29:31'),(71,2,12,'Mike_Zodiac','booda_Khaled','Explosion','2019-08-13 00:30:03'),(72,2,4,'Mike_Zodiac','Derek_Smith','Explosion','2019-08-13 00:30:16'),(73,12,2,'booda_Khaled','Mike_Zodiac','Explosion','2019-08-13 00:30:19'),(74,4,2,'Derek_Smith','Mike_Zodiac','Helicopter Blades','2019-08-13 00:32:47'),(75,4,2,'Derek_Smith','Mike_Zodiac','Helicopter Blades','2019-08-13 00:32:54'),(76,4,2,'Derek_Smith','Mike_Zodiac','Helicopter Blades','2019-08-13 00:33:10'),(77,4,2,'Derek_Smith','Mike_Zodiac','Helicopter Blades','2019-08-13 00:34:39'),(78,4,2,'Derek_Smith','Mike_Zodiac','Helicopter Blades','2019-08-13 00:34:43'),(79,4,2,'Derek_Smith','Mike_Zodiac','Explosion','2019-08-13 00:36:55'),(80,12,4,'booda_Khaled','Derek_Smith','Sniper Rifle','2019-08-13 00:37:02'),(81,2,14,'Mike_Zodiac','Salvador_Tita','Shotgun','2021-03-31 15:05:18'),(82,2,14,'Mike_Zodiac','Salvador_Tita','Rifle','2021-03-31 15:09:11'),(83,12,14,'Booda_Khaled','Salvador_Tita','Desert Eagle','2021-03-31 18:09:30'),(84,12,14,'Booda_Khaled','Salvador_Tita','Desert Eagle','2021-03-31 18:15:33'),(85,2,14,'Mike_Zodiac','Salvador_Tita','Desert Eagle','2021-03-31 22:23:33'),(86,2,14,'Mike_Zodiac','Salvador_Tita','Desert Eagle','2021-03-31 22:23:47');
/*!40000 ALTER TABLE `kills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `landobjects`
--

DROP TABLE IF EXISTS `landobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `landobjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `landid` int DEFAULT NULL,
  `modelid` smallint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `rot_x` float DEFAULT NULL,
  `rot_y` float DEFAULT NULL,
  `rot_z` float DEFAULT NULL,
  `door_opened` tinyint(1) DEFAULT '0',
  `door_locked` tinyint(1) DEFAULT '0',
  `move_x` float DEFAULT '0',
  `move_y` float DEFAULT '0',
  `move_z` float DEFAULT '0',
  `move_rx` float DEFAULT '0',
  `move_ry` float DEFAULT '0',
  `move_rz` float DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `landobjects`
--

LOCK TABLES `landobjects` WRITE;
/*!40000 ALTER TABLE `landobjects` DISABLE KEYS */;
INSERT INTO `landobjects` VALUES (31,13,1333,'Red dumpster',50,1207.83,-1415.13,13.304,-13.6,0,-179.278,0,0,0,0,0,-1000,-1000,-1000),(32,13,1334,'Blue dumpster',50,1205.39,-1417.24,13.469,0,0,87.411,0,0,0,0,0,-1000,-1000,-1000),(34,13,11245,'United states flag',50,1206.76,-1414.59,18.023,-2.3,-37.1,89.333,0,0,0,0,0,-1000,-1000,-1000),(35,13,11245,'United states flag',50,1232.62,-1414.89,19.062,-2.3,-37.1,89.333,0,0,0,0,0,-1000,-1000,-1000),(36,13,1360,'Wide bush plant',250,1227.67,-1416.49,13.087,0,0,-88.532,0,0,0,0,0,-1000,-1000,-1000),(37,13,638,'Wide plant',250,1224.36,-1416.43,13.054,0,0,92.544,0,0,0,0,0,-1000,-1000,-1000),(38,13,1360,'Wide bush plant',250,1211.86,-1416.52,13.193,0,0,90.17,0,0,0,0,0,-1000,-1000,-1000),(39,13,638,'Wide plant',250,1214.79,-1416.37,13.093,0,0,90.851,0,0,0,0,0,-1000,-1000,-1000),(40,13,646,'Palm plant #9',100,1217.05,-1416.2,13.787,0,0,280.926,0,0,0,0,0,-1000,-1000,-1000),(41,13,646,'Palm plant #9',100,1222.1,-1416.2,13.787,0,0,280.926,0,0,0,0,0,-1000,-1000,-1000),(42,13,1566,'Office door #1',100,1218.11,-1416.96,13.677,-0.5,0,-89.43,1,0,0,0,0,-1000,-1000,-1000),(43,13,19450,'wall090',100,1213.32,-1417.16,13.977,0,0,92.271,0,0,0,0,0,-1000,-1000,-1000),(44,13,1566,'Office door #1',100,1221.26,-1416.96,13.679,0.2,0,179.17,0,0,0,0,0,-1000,-1000,-1000),(45,13,19404,'wall052',100,1222.85,-1416.94,14.035,0,0,89.753,0,0,0,0,0,-1000,-1000,-1000),(46,13,19466,'Small window',50,1222.82,-1417.01,14.315,0,0,89.783,0,0,0,0,0,-1000,-1000,-1000),(47,13,19358,'wall006',100,1226.07,-1416.96,14.038,0,0,89.314,0,0,0,0,0,-1000,-1000,-1000),(48,13,19358,'wall006',100,1229.23,-1417,14.038,0,0,89.314,0,0,0,0,0,-1000,-1000,-1000),(49,13,19358,'wall006',100,1230.1,-1417.01,14.038,0,0,89.314,0,0,0,0,0,-1000,-1000,-1000),(52,13,19377,'wall025',100,1221.3,-1424.05,15.361,0,90,-179.896,0,0,0,0,0,-1000,-1000,-1000),(53,13,19377,'wall025',100,1219.96,-1421.69,15.361,0,90,-179.896,0,0,0,0,0,-1000,-1000,-1000),(54,13,19377,'wall025',100,1227.06,-1424.04,15.361,0,90,-179.896,0,0,0,0,0,-1000,-1000,-1000),(55,13,19377,'wall025',100,1227.06,-1421.73,15.361,0,90,179.704,0,0,0,0,0,-1000,-1000,-1000),(56,13,19377,'wall025',100,1213.28,-1421.7,15.361,0,90,-179.896,0,0,0,0,0,-1000,-1000,-1000),(58,13,19362,'wall010',100,1209.79,-1427.26,15.37,0.1,89.9,-179.916,0,0,0,0,0,-1000,-1000,-1000),(61,13,19362,'wall010',100,1215.61,-1427.92,13.306,0.0000000596,-45.5,-0.647,0,0,0,0,0,-1000,-1000,-1000),(62,13,19362,'wall010',100,1214.75,-1427.99,14.174,0,-45.8,-0.447,0,0,0,0,0,-1000,-1000,-1000),(64,13,19450,'wall090',100,1208.08,-1424.1,13.729,0,0,-0.141,0,0,0,0,0,-1000,-1000,-1000),(65,13,19450,'wall090',100,1208.08,-1422.7,13.729,0,0,-0.141,0,0,0,0,0,-1000,-1000,-1000),(66,13,19450,'wall090',100,1208.08,-1422.7,17.149,0,0,-0.141,0,0,0,0,0,-1000,-1000,-1000),(67,13,19450,'wall090',100,1208.1,-1424.41,17.149,0,0,-0.141,0,0,0,0,0,-1000,-1000,-1000),(68,13,19362,'wall010',100,1211.82,-1427.26,15.366,0.1,89.9,-179.916,0,0,0,0,0,-1000,-1000,-1000),(69,13,19404,'wall052',100,1216.47,-1417.02,17.447,0,0,91.332,0,0,0,0,0,-1000,-1000,-1000),(70,13,19404,'wall052',100,1222.85,-1416.94,17.447,0,0,89.832,0,0,0,0,0,-1000,-1000,-1000),(71,13,19358,'wall006',100,1226.03,-1416.94,17.447,0,0,-91.04,0,0,0,0,0,-1000,-1000,-1000),(72,13,19358,'wall006',100,1229.2,-1417,17.447,0,0,-91.04,0,0,0,0,0,-1000,-1000,-1000),(73,13,19358,'wall006',100,1229.85,-1417.01,17.447,0,0,-91.04,0,0,0,0,0,-1000,-1000,-1000),(74,13,19358,'wall006',100,1213.3,-1417.13,17.447,0,0,-87.24,0,0,0,0,0,-1000,-1000,-1000),(75,13,19358,'wall006',100,1210.19,-1417.28,17.447,0,0,-87.24,0,0,0,0,0,-1000,-1000,-1000),(76,13,19128,'Dance floor',1000,1219.71,-1414.97,15.387,0,0,-0.312,0,0,0,0,0,-1000,-1000,-1000),(77,13,19466,'Small window',50,1216.46,-1417.04,17.457,0,0,92.651,0,0,0,0,0,-1000,-1000,-1000),(78,13,19176,'Dual office door',100,1219.66,-1416.95,16.937,0,0,-179.931,0,0,0,0,0,-1000,-1000,-1000),(79,13,1704,'Black lounge chair',500,1220.2,-1415.38,15.397,0,0,-178.215,0,0,0,0,0,-1000,-1000,-1000),(80,13,1428,'Ladder',50,1219.81,-1414.06,15.73,1.3,-90.3,-164.798,0,0,0,0,0,-1000,-1000,-1000),(81,13,1428,'Ladder',50,1221.49,-1415.24,15.714,6,-91.9,108.002,0,0,0,0,0,-1000,-1000,-1000),(82,13,1428,'Ladder',50,1218.19,-1415.37,15.845,4.6,-95.6,100.802,0,0,0,0,0,-1000,-1000,-1000),(84,13,19450,'wall090',100,1232.41,-1423.13,13.734,-0.000001132,-1.1,-0.19,0,0,0,0,0,-1000,-1000,-1000),(87,13,19450,'wall090',100,1232.41,-1424.17,13.734,-0.000001132,-1.1,-0.19,0,0,0,0,0,-1000,-1000,-1000),(88,13,19450,'wall090',100,1232.34,-1423.13,17.143,-0.000001132,-1.1,-0.19,0,0,0,0,0,-1000,-1000,-1000),(89,13,19450,'wall090',100,1232.34,-1423.85,17.143,-0.000001132,-1.1,-0.19,0,0,0,0,0,-1000,-1000,-1000),(90,13,19914,'Wooden bat',50,1208.59,-1427.98,15.596,23.8,-90.2,-85.203,0,0,0,0,0,-1000,-1000,-1000),(91,13,19922,'Wooden workshop table',500,1225.6,-1419.4,15.427,0,0,179.857,0,0,0,0,0,-1000,-1000,-1000),(92,13,2124,'Tall wooden dining chair',250,1228.13,-1419.43,16.287,0,0,-0.39,0,0,0,0,0,-1000,-1000,-1000),(93,13,1739,'Tall brown dining chair',250,1226.31,-1417.64,16.327,0,0,87.653,0,0,0,0,0,-1000,-1000,-1000),(94,13,1739,'Tall brown dining chair',250,1225.08,-1417.62,16.327,0,0,87.653,0,0,0,0,0,-1000,-1000,-1000),(95,13,1739,'Tall brown dining chair',250,1226.16,-1421.25,16.327,0,0,-91.247,0,0,0,0,0,-1000,-1000,-1000),(96,13,1739,'Tall brown dining chair',250,1225.06,-1421.23,16.327,0,0,-91.247,0,0,0,0,0,-1000,-1000,-1000),(97,13,2124,'Tall wooden dining chair',250,1223.1,-1419.4,16.287,0,0,-179.49,0,0,0,0,0,-1000,-1000,-1000),(98,13,19320,'Pumpkin',50,1225.33,-1419.59,16.577,0,0,163.187,0,0,0,0,0,-1000,-1000,-1000),(99,13,1736,'Moose head',300,1225.14,-1417.32,17.857,0,0,2.045,0,0,0,0,0,-1000,-1000,-1000),(100,13,19831,'Grill',500,1230.42,-1420.76,15.227,0,0,-95.967,0,0,0,0,0,-1000,-1000,-1000),(101,13,2453,'Pizza rack',50,1231.94,-1425.62,16.617,0,0,-176.425,0,0,0,0,0,-1000,-1000,-1000),(102,13,19613,'Guitar amp 2',500,1231.89,-1425.69,15.567,0,0,-86.11,0,0,0,0,0,-1000,-1000,-1000),(103,13,19608,'Stage',250,1226.55,-1426.64,15.456,-0.5,0,-179.856,0,0,0,0,0,-1000,-1000,-1000),(104,13,19388,'wall036',100,1211.31,-1418.9,17.137,0,0,-176.788,0,0,0,0,0,-1000,-1000,-1000),(105,13,19358,'wall006',100,1209.72,-1420.43,17.127,0,0,90.699,0,0,0,0,0,-1000,-1000,-1000),(106,13,2528,'Toilet with rug',500,1208.7,-1419.94,15.447,0,0,89.402,0,0,0,0,0,-1000,-1000,-1000),(107,13,19873,'Toilet paper',50,1208.31,-1420,16.467,0,0,32.302,0,0,0,0,0,-1000,-1000,-1000),(108,13,19873,'Toilet paper',50,1208.3,-1419.84,16.467,0,0,32.302,0,0,0,0,0,-1000,-1000,-1000),(109,13,2524,'Sink with extra soap',250,1208.62,-1419.07,15.437,0,0,80.082,0,0,0,0,0,-1000,-1000,-1000),(110,13,2517,'Glass shower cabin',500,1210.07,-1418.84,15.575,0.1,0,2.641,0,0,0,0,0,-1000,-1000,-1000),(111,13,1507,'Yellow door',100,1211.38,-1419.67,15.427,0,0,92.235,0,0,0,0,0,-1000,-1000,-1000),(112,15,19358,'wall006',100,907.38,-1518.45,14.148,0,0,0.281,0,0,0,0,0,-1000,-1000,-1000),(113,15,19358,'wall006',100,907.384,-1521.63,14.138,0,0,-0.019,0,0,0,0,0,-1000,-1000,-1000),(114,15,19358,'wall006',100,907.386,-1524.76,14.138,0,0,0.081,0,0,0,0,0,-1000,-1000,-1000),(115,15,19388,'wall036',100,907.408,-1527.49,14.125,0,0,-178.938,0,0,0,0,0,-1000,-1000,-1000),(116,15,19358,'wall006',100,907.457,-1530.67,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(117,15,19358,'wall006',100,907.479,-1532.29,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(118,15,19358,'wall006',100,907.514,-1534.86,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(119,15,19358,'wall006',100,907.365,-1515.25,14.148,0,0,0.281,0,0,0,0,0,-1000,-1000,-1000),(120,15,19358,'wall006',100,907.352,-1512.58,14.148,0,0,0.281,0,0,0,0,0,-1000,-1000,-1000),(121,15,19358,'wall006',100,905.664,-1511.06,14.148,0,0,90.181,0,0,0,0,0,-1000,-1000,-1000),(122,15,19358,'wall006',100,902.474,-1511.06,14.148,0,0,90.181,0,0,0,0,0,-1000,-1000,-1000),(123,15,19358,'wall006',100,905.954,-1536.41,14.148,0,0,90.181,0,0,0,0,0,-1000,-1000,-1000),(124,15,19358,'wall006',100,902.744,-1536.42,14.148,0,0,90.181,0,0,0,0,0,-1000,-1000,-1000),(125,15,19358,'wall006',100,899.624,-1536.43,14.148,0,0,90.181,0,0,0,0,0,-1000,-1000,-1000),(126,15,19358,'wall006',100,896.425,-1536.42,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(127,15,19358,'wall006',100,893.235,-1536.4,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(128,15,19358,'wall006',100,890.095,-1536.38,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(129,15,19358,'wall006',100,886.895,-1536.36,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(130,15,19358,'wall006',100,883.715,-1536.34,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(131,15,19358,'wall006',100,880.555,-1536.32,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(132,15,19358,'wall006',100,877.425,-1536.3,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(133,15,19358,'wall006',100,874.244,-1536.28,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(134,15,19358,'wall006',100,872.666,-1534.55,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(135,15,19358,'wall006',100,872.624,-1531.5,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(136,15,19358,'wall006',100,872.58,-1528.31,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(137,15,19358,'wall006',100,872.537,-1525.15,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(138,15,19358,'wall006',100,872.494,-1521.99,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(139,15,19358,'wall006',100,872.452,-1518.89,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(140,15,19358,'wall006',100,872.409,-1515.69,14.138,0,0,0.781,0,0,0,0,0,-1000,-1000,-1000),(141,15,19358,'wall006',100,873.896,-1514.18,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(142,15,19358,'wall006',100,877.036,-1514.2,14.148,0,0,89.581,0,0,0,0,0,-1000,-1000,-1000),(143,15,1498,'White wooden door',100,907.365,-1526.77,12.405,0,0,-89.183,0,0,0,0,0,-1000,-1000,-1000),(145,15,19458,'wall098',100,902.275,-1531.77,15.915,-1.2,-90,-178.466,0,0,0,0,0,-1000,-1000,-1000);
/*!40000 ALTER TABLE `landobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lands`
--

DROP TABLE IF EXISTS `lands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lands` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT 'Nobody',
  `price` int DEFAULT '0',
  `min_x` float DEFAULT '0',
  `min_y` float DEFAULT '0',
  `max_x` float DEFAULT '0',
  `max_y` float DEFAULT '0',
  `heightx` float DEFAULT '0',
  `heightz` float NOT NULL DEFAULT '0',
  `heighty` float NOT NULL DEFAULT '0',
  `level` tinyint DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lands`
--

LOCK TABLES `lands` WRITE;
/*!40000 ALTER TABLE `lands` DISABLE KEYS */;
INSERT INTO `lands` VALUES (13,2,'Mike_Zodiac',1,1205.06,-1432.76,1235.69,-1413.85,1215.82,13.352,-1413.36,1),(15,14,'Salvador_Tita',1,859.011,-1536.68,911.698,-1509.5,908.727,13.546,-1516.87,1);
/*!40000 ALTER TABLE `lands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_admin`
--

DROP TABLE IF EXISTS `log_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_admin`
--

LOCK TABLES `log_admin` WRITE;
/*!40000 ALTER TABLE `log_admin` DISABLE KEYS */;
INSERT INTO `log_admin` VALUES (1,'2019-08-11 21:51:09','Mike_Zodiac (uid: 2) has given Mike_Zodiac (uid: 2) their own NRG-500.'),(2,'2019-08-11 21:51:33','Derek_Smith (uid: 4) changed Guillem_Moskow\'s (uid: 3) name to miboun.'),(3,'2019-08-11 22:02:27','Derek_Smith (uid: 4) changed miboun\'s (uid: 3) name to Guillem_Moskow.'),(4,'2019-08-11 22:11:04','Guillem_Moskow (uid: 3) changed Guillem_Moskow\'s (uid: 3) name to John_Maxwell.'),(5,'2019-08-12 01:13:22','Derek_Smith (uid: 4) has made Derek_Smith (uid: 4) a dynamic admin.'),(6,'2019-08-12 12:52:29','John_Maxwell (uid: 3) changed John_Maxwell\'s (uid: 3) name to Barney_Phife.'),(7,'2019-08-12 12:53:20','Barney_Phife (uid: 3) changed Barney_Phife\'s (uid: 3) name to Guillem_El_Chapo.'),(8,'2019-08-12 14:10:31','Derek_Smith (uid: 4) fined Guillem_El_Chapo (uid: 3) for $999999999, reason: noob'),(9,'2019-08-12 14:10:52','Derek_Smith (uid: 4) fined Derek_Smith (uid: 4) for $888888888, reason: pro'),(10,'2019-08-12 19:01:16','Guillem_El_Chapo (uid: 3) changed Guillem_El_Chapo\'s (uid: 3) name to Barney_Phife.'),(11,'2019-08-12 19:02:29','Barney_Phife (uid: 3) changed Barney_Phife\'s (uid: 3) name to Guillem_El_Chapo.'),(12,'2019-08-12 19:35:52','booda_Khaled (uid: 12) has given booda_Khaled (uid: 12) their own NRG-500.'),(13,'2019-08-12 19:37:10','Mike_Zodiac (uid: 2) has given Mike_Zodiac (uid: 2) their own NRG-500.'),(14,'2019-08-12 19:38:29','booda_Khaled (uid: 12) fined Mike_Zodiac (uid: 2) for $1, reason: hacker'),(15,'2019-08-12 19:58:26','booda_Khaled (uid: 12) has made Mike_Zodiac (uid: 2) a developer.'),(16,'2019-08-12 19:59:10','booda_Khaled (uid: 12) has made booda_Khaled (uid: 12) a faction moderator.'),(17,'2019-08-12 20:05:35','Derek_Smith (uid: 4) changed booda_Khaled\'s (uid: 12) name to noob_big_noob.'),(18,'2019-08-12 20:05:55','noob_big_noob (uid: 12) changed Derek_Smith\'s (uid: 4) name to Naked_Ass.'),(19,'2019-08-12 20:06:50','Naked_Ass (uid: 4) accepted Naked_Ass\'s (uid: 4) free namechange to booda_noob.'),(20,'2019-08-12 20:07:08','noob_big_noob (uid: 12) changed noob_big_noob\'s (uid: 12) name to Booda_khaled.'),(21,'2019-08-12 20:08:17','Booda_khaled (uid: 12) has made Guillem_El_Chapo (uid: 3) a gang moderator.'),(22,'2019-08-12 20:11:56','Guillem_El_Chapo (uid: 3) changed Booda_khaled\'s (uid: 12) name to Barney_Phife.'),(23,'2019-08-12 20:12:45','Guillem_El_Chapo (uid: 3) changed Barney_Phife\'s (uid: 12) name to Booda_Khaled.'),(24,'2019-08-12 20:34:15','Booda_Khaled (uid: 12) changed booda_noob\'s (uid: 4) name to Derek_Smithh.'),(25,'2019-08-12 20:34:32','Booda_Khaled (uid: 12) changed Derek_Smithh\'s (uid: 4) name to Derek_Smith.'),(26,'2019-08-12 21:06:47','Booda_Khaled (uid: 12) has made Booda_Khaled (uid: 12) a developer.'),(27,'2019-08-12 21:07:12','Booda_Khaled (uid: 12) has made Booda_Khaled (uid: 12) a faction moderator.'),(28,'2019-08-13 00:21:40','booda_Khaled (uid: 12) has removed Derek_Smith\'s (uid: 4) dynamic admin status.'),(29,'2019-08-13 00:22:04','booda_Khaled (uid: 12) has made Derek_Smith (uid: 4) a dynamic admin.'),(30,'2019-08-13 01:02:37','booda_Khaled (uid: 12) has made booda_Khaled (uid: 12) a faction moderator.'),(31,'2021-03-29 20:44:46','Mike_Zodiac (uid: 2) has made Moez_Tofe7a (uid: 15) a gang moderator.'),(32,'2021-03-30 18:33:28','Salvador_Tita (uid: 14) has given Salvador_Tita (uid: 14) their own Bullet.'),(33,'2021-03-30 21:31:12','MOEZ (uid: 15) fined MOEZ (uid: 15) for $1000000000, reason: zbi'),(34,'2021-03-30 21:35:41','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(35,'2021-03-30 21:35:43','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(36,'2021-03-30 21:35:44','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(37,'2021-03-30 21:35:44','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(38,'2021-03-30 21:35:45','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(39,'2021-03-30 21:35:45','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(40,'2021-03-30 21:35:46','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(41,'2021-03-30 21:35:46','MOEZ (uid: 15) fined MOEZ (uid: 15) for $30000000, reason: zbi'),(42,'2021-03-30 21:38:24','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $381681664, reason: zbi'),(43,'2021-03-30 23:22:17','Salvador_Tita (uid: 14) fined Salvador_Tita (uid: 14) for $1591111, reason: h'),(44,'2021-03-30 23:27:32','Salvador_Tita (uid: 14) has made Salvador_Tita (uid: 14) a faction moderator.'),(45,'2021-03-31 11:32:52','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $200000000, reason: wolverni y3tyh 3sba'),(46,'2021-03-31 11:33:19','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $200000000, reason: wolverni y3tyh 3sba'),(47,'2021-03-31 11:33:30','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $200000000, reason: wolverni y3tyh 3sba'),(48,'2021-03-31 11:33:41','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $200000000, reason: wolverni y3tyh 3sba'),(49,'2021-03-31 11:33:41','Moez_Tofe7a (uid: 15) fined Moez_Tofe7a (uid: 15) for $200000000, reason: wolverni y3tyh 3sba');
/*!40000 ALTER TABLE `log_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_bans`
--

DROP TABLE IF EXISTS `log_bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_bans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_bans`
--

LOCK TABLES `log_bans` WRITE;
/*!40000 ALTER TABLE `log_bans` DISABLE KEYS */;
INSERT INTO `log_bans` VALUES (1,2,'2019-08-11 18:01:29','Mike_Zodiac (IP: 127.0.0.1) was banned by The server, reason: Weapon hacks (TEC9)'),(2,3,'2019-08-11 23:17:34','John_Maxwell (IP: 25.70.18.118) was banned by Mike_Zodiac, reason: DM'),(3,2,'2019-08-11 23:19:56','Mike_Zodiac (IP: 127.0.0.1) was banned by Derek_Smith, reason: noob'),(4,4,'2019-08-11 23:39:56','Derek_Smith (IP: 25.104.144.149) was banned by Mike_Zodiac, reason: DM (3/3 warnings)'),(5,3,'2019-08-12 19:24:02','Guillem_El_Chapo (IP: 25.70.18.118) was banned by Mike_Zodiac, reason: RIP'),(6,4,'2019-08-12 19:55:16','Derek_Smith (IP: 25.104.144.149) was banned by Mike_Zodiac, reason: DM (3/3 warnings)');
/*!40000 ALTER TABLE `log_bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_cheat`
--

DROP TABLE IF EXISTS `log_cheat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_cheat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cheat`
--

LOCK TABLES `log_cheat` WRITE;
/*!40000 ALTER TABLE `log_cheat` DISABLE KEYS */;
INSERT INTO `log_cheat` VALUES (1,'2019-08-11 18:00:07','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 453.5)'),(2,'2019-08-11 18:00:45','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 1920.3)'),(3,'2019-08-11 18:01:21','Mike_Zodiac (uid: 2) had a desynced TEC9 with 60 ammunition.'),(4,'2019-08-11 18:01:28','Mike_Zodiac (uid: 2) had a desynced TEC9 with 60 ammunition.'),(5,'2019-08-11 18:05:23','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 1918.7)'),(6,'2019-08-11 18:11:23','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 574.7)'),(7,'2019-08-11 18:12:14','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 1858.0)'),(8,'2019-08-11 18:12:18','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 128.2)'),(9,'2019-08-11 18:12:26','Mike_Zodiac (uid: 2) possibly teleport hacked (distance: 317.9)'),(10,'2019-08-11 18:33:47','Guillem_Moskow (uid: 3) possibly teleport hacked (distance: 1652.2)'),(11,'2019-08-11 18:33:53','Guillem_Moskow (uid: 3) possibly teleport hacked (distance: 1651.0)'),(12,'2019-08-11 19:10:45','Guillem_Moskow (uid: 3) possibly teleport hacked (distance: 1309.4)'),(13,'2019-08-11 19:11:00','Guillem_Moskow (uid: 3) possibly teleport hacked (distance: 1306.4)'),(14,'2021-03-29 21:43:42','Zven_Zengri (uid: 17) possibly teleport hacked (distance: 974.2)'),(15,'2021-03-31 11:28:24','Wolverine_X (uid: 21) possibly teleport hacked (distance: 121.8)'),(16,'2021-03-31 18:28:17','anas_morello (uid: 18) possibly hacked armor. (old: 0.00, new: 100.00)'),(17,'2021-03-31 18:30:49','anas_morello (uid: 18) possibly teleport hacked (distance: 3534.8)');
/*!40000 ALTER TABLE `log_cheat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_command`
--

DROP TABLE IF EXISTS `log_command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_command` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13802 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_command`
--

LOCK TABLES `log_command` WRITE;
/*!40000 ALTER TABLE `log_command` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_command` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_contracts`
--

DROP TABLE IF EXISTS `log_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_contracts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_contracts`
--

LOCK TABLES `log_contracts` WRITE;
/*!40000 ALTER TABLE `log_contracts` DISABLE KEYS */;
INSERT INTO `log_contracts` VALUES (1,'2019-08-11 23:15:25','Mike_Zodiac (uid: 2) placed a contract on Derek_Smith (uid: 4) for $500000, reason: RIP'),(2,'2019-08-11 23:16:54','Mike_Zodiac (uid: 2) placed a contract on John_Maxwell (uid: 3) for $80000, reason: 3..'),(3,'2019-08-11 23:33:02','Mike_Zodiac (uid: 2) placed a contract on John_Maxwell (uid: 3) for $50000, reason: peace'),(4,'2019-08-11 23:33:30','Derek Smith (uid: 4) successfully completed their hit on John Maxwell (uid: 3) for $65000.'),(5,'2019-08-11 23:34:29','John_Maxwell (uid: 3) placed a contract on Mike_Zodiac (uid: 2) for $500000, reason: gay'),(6,'2019-08-11 23:35:11','Derek Smith (uid: 4) successfully completed their hit on Mike Zodiac (uid: 2) for $250000.'),(7,'2019-08-12 14:04:04','Derek_Smith (uid: 4) placed a contract on Mike_Zodiac (uid: 2) for $200000, reason: noob'),(8,'2019-08-12 19:59:05','Derek_Smith (uid: 4) placed a contract on booda_Khaled (uid: 12) for $100000, reason: noob'),(9,'2019-08-12 20:00:10','Derek Smith (uid: 4) successfully completed their hit on booda Khaled (uid: 12) for $50000.'),(10,'2019-08-12 20:00:29','Derek Smith (uid: 4) successfully completed their hit on Mike Zodiac (uid: 2) for $100000.'),(11,'2019-08-12 20:07:30','Mike_Zodiac (uid: 2) placed a contract on booda_noob (uid: 4) for $200000, reason: derek'),(12,'2019-08-13 00:19:28','Derek_Smith (uid: 4) placed a contract on booda_Khaled (uid: 12) for $500000, reason: NOB ');
/*!40000 ALTER TABLE `log_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_cp`
--

DROP TABLE IF EXISTS `log_cp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_cp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `executer` text,
  `description` text,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_cp`
--

LOCK TABLES `log_cp` WRITE;
/*!40000 ALTER TABLE `log_cp` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_cp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_dicebet`
--

DROP TABLE IF EXISTS `log_dicebet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_dicebet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_dicebet`
--

LOCK TABLES `log_dicebet` WRITE;
/*!40000 ALTER TABLE `log_dicebet` DISABLE KEYS */;
INSERT INTO `log_dicebet` VALUES (1,'2019-08-12 14:07:41','Mike Zodiac (uid: 2) won a dice bet against Guillem El Chapo (uid: 3) for $50000.'),(2,'2019-08-12 14:09:15','Mike Zodiac (uid: 2) won a dice bet against Guillem El Chapo (uid: 3) for $100000.'),(3,'2019-08-12 14:09:27','Mike Zodiac (uid: 2) won a dice bet against Derek Smith (uid: 4) for $100000.'),(4,'2019-08-12 14:09:30','Derek Smith (uid: 4) won a dice bet against Mike Zodiac (uid: 2) for $100000.'),(5,'2019-08-12 14:10:22','Derek Smith (uid: 4) won a dice bet against Mike Zodiac (uid: 2) for $9999999.');
/*!40000 ALTER TABLE `log_dicebet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_faction`
--

DROP TABLE IF EXISTS `log_faction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_faction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_faction`
--

LOCK TABLES `log_faction` WRITE;
/*!40000 ALTER TABLE `log_faction` DISABLE KEYS */;
INSERT INTO `log_faction` VALUES (1,'2019-08-11 23:13:17','Derek Smith (uid: 4) has deleted faction  (id: 2).'),(2,'2019-08-11 23:13:57','John Maxwell (uid: 3) has deleted faction  (id: 1).'),(3,'2019-08-12 00:57:34','Derek_Smith (uid: 4) has invited Mike_Zodiac (uid: 2) to Los Santos Fire & Medical Department (id: 1).'),(4,'2019-08-12 00:57:35','Derek_Smith (uid: 4) has set Mike_Zodiac\'s (uid: 2) rank in Los Santos Fire & Medical Department (id: 1) to Medic (1).'),(5,'2019-08-12 00:57:37','Derek_Smith (uid: 4) has set Mike_Zodiac\'s (uid: 2) rank in Los Santos Fire & Medical Department (id: 1) to Trainee Medic (0).'),(6,'2019-08-12 00:57:39','Derek_Smith (uid: 4) has set Mike_Zodiac\'s (uid: 2) rank in Los Santos Fire & Medical Department (id: 1) to Senior Medic (2).'),(7,'2019-08-12 13:03:08','Derek_Smith (uid: 4) has quit Los Santos Fire & Medical Department (id: 1) has rank Deputy Commissioner\r\n (5).'),(8,'2019-08-12 13:09:47','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 2 to $2000.'),(9,'2019-08-12 13:09:52','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 0 to $1000.'),(10,'2019-08-12 13:09:54','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 1 to $2000.'),(11,'2019-08-12 13:09:58','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 2 to $3000.'),(12,'2019-08-12 13:10:02','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 3 to $4000.'),(13,'2019-08-12 13:10:06','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 5 to $5000.'),(14,'2019-08-12 13:10:10','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 8 to $6000.'),(15,'2019-08-12 13:10:15','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 8 to $6000.'),(16,'2019-08-12 13:10:48','Derek_Smith (uid: 4) set Los Santos Fire & Medical Department\'s (id: 1) paycheck for rank 5 to $5000.'),(17,'2019-08-12 14:39:32','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(18,'2019-08-12 14:39:32','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(19,'2019-08-12 14:39:33','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(20,'2019-08-12 14:39:33','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(21,'2019-08-12 14:39:33','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(22,'2019-08-12 14:39:34','Derek_Smith (uid: 4) has charged Zou_louloulou (uid: 10) with noob'),(23,'2019-08-12 16:02:33','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(24,'2019-08-12 16:02:38','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(25,'2019-08-12 16:02:39','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(26,'2019-08-12 16:02:39','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(27,'2019-08-12 16:02:39','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(28,'2019-08-12 16:02:40','Guillem (uid: 3) has charged Mike_Zodiac (uid: 2) with FK u'),(29,'2019-08-12 19:48:09','Mike Zodiac (uid: 2) has deleted faction  (id: 6).'),(30,'2019-08-13 14:27:18','Derek_Smith (uid: 4) has quit Hitman agency (id: 0) has rank Unspecified (6).'),(31,'2021-03-30 00:49:13','anas_morello (uid: 18) has set Booda_Khaled\'s (uid: 12) rank in Los Santos Police Department (id: 3) to Senior Officer (2).'),(32,'2021-03-30 00:51:32','anas_morello (uid: 18) has charged Booda_Khaled (uid: 12) with fake call'),(33,'2021-03-30 18:43:12','Booda_Khaled (uid: 12) has quit Los Santos Police Department (id: 3) has rank Chief of Police (6).');
/*!40000 ALTER TABLE `log_faction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_gang`
--

DROP TABLE IF EXISTS `log_gang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_gang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_gang`
--

LOCK TABLES `log_gang` WRITE;
/*!40000 ALTER TABLE `log_gang` DISABLE KEYS */;
INSERT INTO `log_gang` VALUES (1,'2019-08-11 23:30:43','John_Maxwell (uid: 3) has invited Mike_Zodiac (uid: 2) to El Diablo\' (id: 0).'),(2,'2019-08-11 23:30:58','John_Maxwell (uid: 3) has set Mike_Zodiac\'s (uid: 2) rank in El Diablo\' (id: 0) to Unspecified (6).'),(3,'2019-08-12 00:57:19','Mike_Zodiac (uid: 2) has quit El Diablo\' (id: 0) has rank Unspecified (6).'),(4,'2021-03-30 18:55:18','Booda_Khaled (uid: 12) has quit Grove Street (id: 2) has rank Unspecified (6).'),(5,'2021-03-31 13:13:37','Moez Tofe7a (uid: 15) has removed gang  (id: 0).'),(6,'2021-03-31 13:13:40','Moez Tofe7a (uid: 15) has removed gang  (id: 1).'),(7,'2021-03-31 13:13:47','Moez Tofe7a (uid: 15) has removed gang  (id: 2).');
/*!40000 ALTER TABLE `log_gang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_give`
--

DROP TABLE IF EXISTS `log_give`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_give` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_give`
--

LOCK TABLES `log_give` WRITE;
/*!40000 ALTER TABLE `log_give` DISABLE KEYS */;
INSERT INTO `log_give` VALUES (1,'2019-08-12 14:41:00','Derek_Smith (uid: 4) (IP: 25.104.144.149) gives $60000 to Zou_louloulou (uid: 10) (IP: 127.0.0.1)');
/*!40000 ALTER TABLE `log_give` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_givecookie`
--

DROP TABLE IF EXISTS `log_givecookie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_givecookie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_givecookie`
--

LOCK TABLES `log_givecookie` WRITE;
/*!40000 ALTER TABLE `log_givecookie` DISABLE KEYS */;
INSERT INTO `log_givecookie` VALUES (1,'2019-08-11 20:51:55','Guillem_Moskow (uid: 3) has given a cookie to every player online'),(2,'2019-08-11 20:51:55','Guillem_Moskow (uid: 3) has given a cookie to every player online'),(3,'2019-08-11 21:50:16','Derek_Smith (uid: 4) has given a cookie to every player online'),(4,'2019-08-11 23:46:10','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(5,'2019-08-11 23:46:11','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(6,'2019-08-11 23:46:11','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(7,'2019-08-11 23:46:12','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(8,'2019-08-11 23:46:13','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(9,'2019-08-11 23:46:13','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(10,'2019-08-11 23:46:13','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(11,'2019-08-11 23:46:14','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(12,'2019-08-11 23:46:14','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(13,'2019-08-11 23:46:14','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(14,'2019-08-11 23:46:15','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(15,'2019-08-11 23:46:15','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(16,'2019-08-11 23:46:15','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good player'),(17,'2019-08-11 23:46:16','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playert'),(18,'2019-08-11 23:46:17','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playert'),(19,'2019-08-11 23:46:17','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playert'),(20,'2019-08-11 23:46:18','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playert'),(21,'2019-08-11 23:46:18','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playert'),(22,'2019-08-11 23:46:19','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(23,'2019-08-11 23:46:19','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(24,'2019-08-11 23:46:19','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(25,'2019-08-11 23:46:20','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(26,'2019-08-11 23:46:20','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(27,'2019-08-11 23:46:20','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(28,'2019-08-11 23:46:21','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(29,'2019-08-11 23:46:21','Derek_Smith (uid: 4) has given a cookie to Derek_Smith (uid: 4) for reason good playertt'),(30,'2019-08-12 21:30:42','Guillem_El_Chapo (uid: 3) has given a cookie to every player online'),(31,'2019-08-12 21:30:43','Guillem_El_Chapo (uid: 3) has given a cookie to every player online'),(32,'2019-08-12 21:30:43','Guillem_El_Chapo (uid: 3) has given a cookie to every player online');
/*!40000 ALTER TABLE `log_givecookie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_givegun`
--

DROP TABLE IF EXISTS `log_givegun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_givegun` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_givegun`
--

LOCK TABLES `log_givegun` WRITE;
/*!40000 ALTER TABLE `log_givegun` DISABLE KEYS */;
INSERT INTO `log_givegun` VALUES (1,'2019-08-11 22:36:56','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(2,'2019-08-11 22:46:45','Derek_Smith (uid: 4) gives a Sniper Rifle to Mike_Zodiac (uid: 2)'),(3,'2019-08-11 22:51:37','Derek_Smith (uid: 4) gives a UZI to Derek_Smith (uid: 4)'),(4,'2019-08-11 22:51:59','Derek_Smith (uid: 4) gives a UZI to Derek_Smith (uid: 4)'),(5,'2019-08-11 23:21:39','Derek_Smith (uid: 4) gives a Combat Shotgun to Derek_Smith (uid: 4)'),(6,'2019-08-11 23:30:50','Derek_Smith (uid: 4) gives a Baseball Bat to Derek_Smith (uid: 4)'),(7,'2019-08-11 23:30:55','Derek_Smith (uid: 4) gives a Knife to Derek_Smith (uid: 4)'),(8,'2019-08-11 23:36:32','John_Maxwell (uid: 3) gives a Minigun to John_Maxwell (uid: 3)'),(9,'2019-08-11 23:36:38','John_Maxwell (uid: 3) gives a Minigun to John_Maxwell (uid: 3)'),(10,'2019-08-11 23:36:55','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(11,'2019-08-11 23:37:15','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(12,'2019-08-12 11:48:58','John_Maxwell (uid: 3) gives a Desert Eagle to John_Maxwell (uid: 3)'),(13,'2019-08-12 13:58:14','Derek_Smith (uid: 4) gives a Desert Eagle to Derek_Smith (uid: 4)'),(14,'2019-08-12 13:58:19','Derek_Smith (uid: 4) gives a Desert Eagle to Derek_Smith (uid: 4)'),(15,'2019-08-12 13:58:26','Derek_Smith (uid: 4) gives a Shotgun to Derek_Smith (uid: 4)'),(16,'2019-08-12 13:59:33','Derek_Smith (uid: 4) gives a Desert Eagle to Derek_Smith (uid: 4)'),(17,'2019-08-12 14:04:36','Derek_Smith (uid: 4) gives a Knife to Derek_Smith (uid: 4)'),(18,'2019-08-12 14:04:58','Derek_Smith (uid: 4) gives a Knife to Derek_Smith (uid: 4)'),(19,'2019-08-12 14:07:41','Derek_Smith (uid: 4) gives a Knife to Derek_Smith (uid: 4)'),(20,'2019-08-12 14:07:46','Derek_Smith (uid: 4) gives a Desert Eagle to Derek_Smith (uid: 4)'),(21,'2019-08-12 14:08:04','Derek_Smith (uid: 4) gives a Desert Eagle to Derek_Smith (uid: 4)'),(22,'2019-08-12 14:14:40','Guillem_El_Chapo (uid: 3) gives a Desert Eagle to Guillem_El_Chapo (uid: 3)'),(23,'2019-08-12 14:14:53','Guillem_El_Chapo (uid: 3) gives a Desert Eagle to Derek_Smith (uid: 4)'),(24,'2019-08-12 14:18:11','Derek_Smith (uid: 4) gives a Heat Seaker to Derek_Smith (uid: 4)'),(25,'2019-08-12 14:18:17','Derek_Smith (uid: 4) gives a Heat Seaker to Derek_Smith (uid: 4)'),(26,'2019-08-12 14:18:18','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(27,'2019-08-12 14:18:26','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(28,'2019-08-12 14:18:33','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(29,'2019-08-12 14:40:00','Derek_Smith (uid: 4) gives a Sniper Rifle to Derek_Smith (uid: 4)'),(30,'2019-08-12 14:41:39','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(31,'2019-08-12 14:41:45','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(32,'2019-08-12 14:41:47','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(33,'2019-08-12 14:41:57','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(34,'2019-08-12 19:30:01','Mike_Zodiac (uid: 2) gives a Rocket Launcher to Guillem_El_Chapo (uid: 3)'),(35,'2019-08-12 20:09:32','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Guillem_El_Chapo (uid: 3)'),(36,'2019-08-12 20:09:46','Mike_Zodiac (uid: 2) gives a Rocket Launcher to Mike_Zodiac (uid: 2)'),(37,'2019-08-12 20:11:42','Guillem_El_Chapo (uid: 3) gives a Heat Seaker to Booda_khaled (uid: 12)'),(38,'2019-08-12 20:11:50','Mike_Zodiac (uid: 2) gives a Sniper Rifle to Booda_khaled (uid: 12)'),(39,'2019-08-12 22:01:29','Zoldic (uid: 2) gives a Sniper Rifle to Zoldic (uid: 2)'),(40,'2019-08-12 23:19:35','Booda (uid: 12) gives a Chainsaw to Booda (uid: 12)'),(41,'2019-08-12 23:19:45','Booda (uid: 12) gives a Brass Knuckles to Booda (uid: 12)'),(42,'2019-08-12 23:27:09','Derek_Smith (uid: 4) gives a Vibrator to Derek_Smith (uid: 4)'),(43,'2019-08-13 00:02:04','booda_Khaled (uid: 12) gives a Flowers to booda_Khaled (uid: 12)'),(44,'2019-08-13 00:02:06','booda_Khaled (uid: 12) gives a Desert Eagle to booda_Khaled (uid: 12)'),(45,'2019-08-13 00:36:09','booda_Khaled (uid: 12) gives a M4 to booda_Khaled (uid: 12)'),(46,'2019-08-13 00:36:51','Derek_Smith (uid: 4) gives a Rocket Launcher to Derek_Smith (uid: 4)'),(47,'2021-02-13 12:52:16','Mike_Zodiac (uid: 2) gives a AK47 to Mike_Zodiac (uid: 2)'),(48,'2021-03-29 20:51:07','Salvador_Tita (uid: 14) gives a Minigun to Salvador_Tita (uid: 14)'),(49,'2021-03-30 22:49:27','Salvador_Tita (uid: 14) gives a Desert Eagle to Salvador_Tita (uid: 14)'),(50,'2021-03-31 17:43:40','Booda_Khaled (uid: 12) gives a Desert Eagle to anas_morello (uid: 18)'),(51,'2021-03-31 17:44:25','Booda_Khaled (uid: 12) gives a Desert Eagle to Booda_Khaled (uid: 12)'),(52,'2021-03-31 18:08:59','Salvador_Tita (uid: 14) gives a Desert Eagle to Booda_Khaled (uid: 12)'),(53,'2021-03-31 18:10:14','TiTa (uid: 14) gives a Desert Eagle to Booda (uid: 12)'),(54,'2021-03-31 18:10:20','TiTa (uid: 14) gives a Golf Club to Booda (uid: 12)'),(55,'2021-03-31 18:10:31','TiTa (uid: 14) gives a Desert Eagle to Booda (uid: 12)'),(56,'2021-03-31 18:15:17','Booda_Khaled (uid: 12) gives a Desert Eagle to Salvador_Tita (uid: 14)'),(57,'2021-03-31 18:15:19','Salvador_Tita (uid: 14) gives a Desert Eagle to Salvador_Tita (uid: 14)'),(58,'2021-03-31 22:21:59','Mike_Zodiac (uid: 2) gives a Desert Eagle to Mike_Zodiac (uid: 2)');
/*!40000 ALTER TABLE `log_givegun` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_givemoney`
--

DROP TABLE IF EXISTS `log_givemoney`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_givemoney` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_givemoney`
--

LOCK TABLES `log_givemoney` WRITE;
/*!40000 ALTER TABLE `log_givemoney` DISABLE KEYS */;
INSERT INTO `log_givemoney` VALUES (1,'2019-08-11 19:18:08','Mike_Zodiac (uid: 2) has used /givemoney to give $2000000 to Guillem_Moskow (uid: 3).'),(2,'2019-08-11 21:36:04','Derek_Smith (uid: 4) has used /givemoney to give $10000 to Derek_Smith (uid: 4).'),(3,'2019-08-11 21:37:14','Derek_Smith (uid: 4) has used /givemoney to give $1 to Guillem_Moskow (uid: 3).'),(4,'2019-08-11 21:37:14','Derek_Smith (uid: 4) has used /givemoney to give $1 to Guillem_Moskow (uid: 3).'),(5,'2019-08-11 21:37:14','Derek_Smith (uid: 4) has used /givemoney to give $1 to Guillem_Moskow (uid: 3).'),(6,'2019-08-11 21:37:27','Derek_Smith (uid: 4) has used /givemoney to give $1 to Mike_Zodiac (uid: 2).'),(7,'2019-08-11 21:37:28','Derek_Smith (uid: 4) has used /givemoney to give $1 to Mike_Zodiac (uid: 2).'),(8,'2019-08-11 21:37:29','Derek_Smith (uid: 4) has used /givemoney to give $1 to Mike_Zodiac (uid: 2).'),(9,'2019-08-11 23:17:06','Derek_Smith (uid: 4) has used /givemoney to give $9999999 to Mike_Zodiac (uid: 2).'),(10,'2019-08-11 23:33:51','Derek_Smith (uid: 4) has used /givemoney to give $1000000 to John_Maxwell (uid: 3).'),(11,'2019-08-12 14:09:22','Derek_Smith (uid: 4) has used /givemoney to give $99999 to Derek_Smith (uid: 4).'),(12,'2019-08-12 14:09:23','Derek_Smith (uid: 4) has used /givemoney to give $99999 to Derek_Smith (uid: 4).'),(13,'2019-08-12 14:09:24','Derek_Smith (uid: 4) has used /givemoney to give $99999999 to Derek_Smith (uid: 4).'),(14,'2019-08-12 14:10:08','Derek_Smith (uid: 4) has used /givemoney to give $999999999 to Mike_Zodiac (uid: 2).'),(15,'2019-08-12 14:10:53','Guillem_El_Chapo (uid: 3) has used /givemoney to give $259648182 to Guillem_El_Chapo (uid: 3).'),(16,'2019-08-12 14:10:59','Guillem_El_Chapo (uid: 3) has used /givemoney to give $259648182 to Guillem_El_Chapo (uid: 3).'),(17,'2019-08-12 14:11:02','Guillem_El_Chapo (uid: 3) has used /givemoney to give $1740945164 to Guillem_El_Chapo (uid: 3).'),(18,'2019-08-12 14:13:37','Derek_Smith (uid: 4) has used /givemoney to give $50000000 to Derek_Smith (uid: 4).'),(19,'2019-08-12 14:13:41','Derek_Smith (uid: 4) has used /givemoney to give $50000000 to Derek_Smith (uid: 4).'),(20,'2019-08-12 14:13:42','Derek_Smith (uid: 4) has used /givemoney to give $50000000 to Derek_Smith (uid: 4).'),(21,'2019-08-12 14:13:43','Derek_Smith (uid: 4) has used /givemoney to give $50000000 to Derek_Smith (uid: 4).'),(22,'2019-08-12 14:14:25','Guillem_El_Chapo (uid: 3) has used /givemoney to give $578000000 to Derek_Smith (uid: 4).'),(23,'2019-08-12 14:16:09','Guillem_El_Chapo (uid: 3) has used /givemoney to give $200000 to Derek_Smith (uid: 4).'),(24,'2019-08-12 14:16:11','Guillem_El_Chapo (uid: 3) has used /givemoney to give $2000000 to Derek_Smith (uid: 4).'),(25,'2019-08-12 14:32:49','Guillem_El_Chapo (uid: 3) has used /givemoney to give $450000 to Guillem_El_Chapo (uid: 3).'),(26,'2019-08-12 19:01:57','Booda (uid: 12) has used /givemoney to give $100000 to Booda (uid: 12).'),(27,'2019-08-13 00:14:43','Derek_Smith (uid: 4) has used /givemoney to give $99999 to Derek_Smith (uid: 4).'),(28,'2019-08-13 13:40:28','Guillem_El_Chapo (uid: 3) has used /givemoney to give $1000000 to Guillem_El_Chapo (uid: 3).'),(29,'2021-03-29 21:28:21','Salvador_Tita (uid: 14) has used /givemoney to give $100000 to Salvador_Tita (uid: 14).'),(30,'2021-03-30 17:52:47','Moez_Tofe7a (uid: 15) has used /givemoney to give $888888888 to Moez_Tofe7a (uid: 15).'),(31,'2021-03-30 17:52:54','Moez_Tofe7a (uid: 15) has used /givemoney to give $888888888 to Moez_Tofe7a (uid: 15).'),(32,'2021-03-30 23:14:46','Salvador_Tita (uid: 14) has used /givemoney to give $1500000 to Salvador_Tita (uid: 14).'),(33,'2021-03-30 23:14:49','Salvador_Tita (uid: 14) has used /givemoney to give $15000000 to Salvador_Tita (uid: 14).'),(34,'2021-03-30 23:45:22','Salvador_Tita (uid: 14) has used /givemoney to give $500000 to Salvador_Tita (uid: 14).'),(35,'2021-03-31 11:34:12','Moez_Tofe7a (uid: 15) has used /givemoney to give $100000 to Moez_Tofe7a (uid: 15).'),(36,'2021-03-31 11:34:15','Moez_Tofe7a (uid: 15) has used /givemoney to give $100000 to Moez_Tofe7a (uid: 15).'),(37,'2021-03-31 11:34:17','Moez_Tofe7a (uid: 15) has used /givemoney to give $1000000 to Moez_Tofe7a (uid: 15).'),(38,'2021-03-31 13:12:44','Moez_Tofe7a (uid: 15) has used /givemoney to give $30000000 to Moez_Tofe7a (uid: 15).'),(39,'2021-03-31 13:12:52','Moez_Tofe7a (uid: 15) has used /givemoney to give $30000000 to Moez_Tofe7a (uid: 15).'),(40,'2021-03-31 18:17:51','Booda_Khaled (uid: 12) has used /givemoney to give $50000 to anas_morello (uid: 18).'),(41,'2021-03-31 18:17:53','Booda_Khaled (uid: 12) has used /givemoney to give $50000 to Salvador_Tita (uid: 14).');
/*!40000 ALTER TABLE `log_givemoney` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_land`
--

DROP TABLE IF EXISTS `log_land`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_land` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_land`
--

LOCK TABLES `log_land` WRITE;
/*!40000 ALTER TABLE `log_land` DISABLE KEYS */;
INSERT INTO `log_land` VALUES (1,'2019-08-12','Mike Zodiac (uid: 2) has removed land (id: 0) land owner (0).'),(2,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 0) land owner (0).'),(3,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 1) land owner (0).'),(4,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 2) land owner (0).'),(5,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 3) land owner (0).'),(6,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 4) land owner (0).'),(7,'2019-08-12','Guillem El Chapo (uid: 3) has removed land (id: 2) land owner (0).'),(8,'2021-02-13','Mike Zodiac (uid: 2) has removed land (id: 0) land owner (0).');
/*!40000 ALTER TABLE `log_land` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_makeadmin`
--

DROP TABLE IF EXISTS `log_makeadmin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_makeadmin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_makeadmin`
--

LOCK TABLES `log_makeadmin` WRITE;
/*!40000 ALTER TABLE `log_makeadmin` DISABLE KEYS */;
INSERT INTO `log_makeadmin` VALUES (1,'2019-08-11 19:15:53','Mike_Zodiac (uid: 2) set Guillem_Moskow\'s (uid: 3) admin level to 9'),(2,'2019-08-11 21:20:17','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) admin level to 9'),(3,'2019-08-11 23:19:40','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 1'),(4,'2019-08-12 01:12:22','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) admin level to 10'),(5,'2019-08-12 01:14:45','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) admin level to 9'),(6,'2019-08-12 16:03:48','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 0'),(7,'2019-08-12 18:53:16','Mike_Zodiac (uid: 2) set booda_Khaled\'s (uid: 12) admin level to 9'),(8,'2019-08-12 19:14:07','Mike_Zodiac (uid: 2) set booda_Khaled\'s (uid: 12) admin level to 10'),(9,'2021-03-29 14:14:35','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 0'),(10,'2021-03-29 14:14:46','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 10'),(11,'2021-03-29 14:14:51','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 10'),(12,'2021-03-29 19:21:33','Mike_Zodiac (uid: 2) set Salvador_Tita\'s (uid: 14) admin level to 10'),(13,'2021-03-29 19:51:55','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 0'),(14,'2021-03-29 19:52:20','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 10'),(15,'2021-03-29 20:41:12','Mike_Zodiac (uid: 2) set Moez_Tofe7a\'s (uid: 15) admin level to 8'),(16,'2021-03-30 22:30:39','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 0'),(17,'2021-03-30 22:30:42','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(18,'2021-03-31 11:29:08','Salvador_Tita (uid: 14) set Wolverine_X\'s (uid: 21) admin level to 5'),(19,'2021-03-31 11:29:12','Salvador_Tita (uid: 14) set Wolverine_X\'s (uid: 21) admin level to 7'),(20,'2021-03-31 11:29:16','Salvador_Tita (uid: 14) set Wolverine_X\'s (uid: 21) admin level to 8'),(21,'2021-03-31 11:29:18','Salvador_Tita (uid: 14) set Wolverine_X\'s (uid: 21) admin level to 9'),(22,'2021-03-31 13:09:15','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 0'),(23,'2021-03-31 13:09:37','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(24,'2021-03-31 13:09:53','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 6'),(25,'2021-03-31 13:09:56','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 1'),(26,'2021-03-31 13:10:00','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 2'),(27,'2021-03-31 13:10:02','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 3'),(28,'2021-03-31 13:10:04','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 4'),(29,'2021-03-31 13:10:08','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 5'),(30,'2021-03-31 13:10:10','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 6'),(31,'2021-03-31 13:10:15','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 7'),(32,'2021-03-31 13:10:19','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 8'),(33,'2021-03-31 13:10:22','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 9'),(34,'2021-03-31 13:10:25','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(35,'2021-03-31 13:10:37','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 2'),(36,'2021-03-31 13:11:38','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(37,'2021-03-31 13:12:19','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 3'),(38,'2021-03-31 13:12:27','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 4'),(39,'2021-03-31 13:12:30','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 5'),(40,'2021-03-31 13:12:31','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 6'),(41,'2021-03-31 13:12:34','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 7'),(42,'2021-03-31 13:12:36','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 8'),(43,'2021-03-31 13:12:39','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 8'),(44,'2021-03-31 13:12:42','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 9'),(45,'2021-03-31 13:12:44','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(46,'2021-03-31 13:12:54','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 2'),(47,'2021-03-31 13:12:58','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(48,'2021-03-31 17:40:14','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 1'),(49,'2021-03-31 17:40:27','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(50,'2021-03-31 17:40:37','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 2'),(51,'2021-03-31 17:44:30','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(52,'2021-03-31 17:44:43','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 6'),(53,'2021-03-31 17:44:49','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 7'),(54,'2021-03-31 17:44:58','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 8'),(55,'2021-03-31 17:51:51','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) admin level to 10'),(56,'2021-03-31 21:36:26','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 0'),(57,'2021-03-31 21:45:02','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) admin level to 10');
/*!40000 ALTER TABLE `log_makeadmin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_makehelper`
--

DROP TABLE IF EXISTS `log_makehelper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_makehelper` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_makehelper`
--

LOCK TABLES `log_makehelper` WRITE;
/*!40000 ALTER TABLE `log_makehelper` DISABLE KEYS */;
INSERT INTO `log_makehelper` VALUES (1,'2019-08-11 21:50:41','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 1'),(2,'2019-08-11 23:19:15','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 1'),(3,'2019-08-11 23:19:35','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 1'),(4,'2019-08-11 23:19:38','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 3'),(5,'2019-08-11 23:19:39','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 5'),(6,'2019-08-11 23:19:40','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 6'),(7,'2019-08-11 23:19:42','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 7'),(8,'2019-08-11 23:19:45','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) helper level to 7'),(9,'2019-08-12 22:46:43','booda_Khaled (uid: 12) set booda_Khaled\'s (uid: 12) helper level to 5'),(10,'2019-08-12 23:54:52','Derek_Smith (uid: 4) set booda_Khaled\'s (uid: 12) helper level to 0'),(11,'2019-08-12 23:54:55','Derek_Smith (uid: 4) set booda_Khaled\'s (uid: 12) helper level to 1'),(12,'2019-08-13 00:19:03','booda_Khaled (uid: 12) set booda_Khaled\'s (uid: 12) helper level to 7');
/*!40000 ALTER TABLE `log_makehelper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_namechanges`
--

DROP TABLE IF EXISTS `log_namechanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_namechanges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_namechanges`
--

LOCK TABLES `log_namechanges` WRITE;
/*!40000 ALTER TABLE `log_namechanges` DISABLE KEYS */;
INSERT INTO `log_namechanges` VALUES (1,'2019-08-11 21:51:33','Derek_Smith (uid: 4) changed Guillem_Moskow\'s (uid: 3) name to miboun.'),(2,'2019-08-11 22:02:27','Derek_Smith (uid: 4) changed miboun\'s (uid: 3) name to Guillem_Moskow.'),(3,'2019-08-11 22:11:04','Guillem_Moskow (uid: 3) changed Guillem_Moskow\'s (uid: 3) name to John_Maxwell.'),(4,'2019-08-12 12:52:29','John_Maxwell (uid: 3) changed John_Maxwell\'s (uid: 3) name to Barney_Phife.'),(5,'2019-08-12 12:53:20','Barney_Phife (uid: 3) changed Barney_Phife\'s (uid: 3) name to Guillem_El_Chapo.'),(6,'2019-08-12 19:01:16','Guillem_El_Chapo (uid: 3) changed Guillem_El_Chapo\'s (uid: 3) name to Barney_Phife.'),(7,'2019-08-12 19:02:29','Barney_Phife (uid: 3) changed Barney_Phife\'s (uid: 3) name to Guillem_El_Chapo.'),(8,'2019-08-12 20:05:35','Derek_Smith (uid: 4) changed booda_Khaled\'s (uid: 12) name to noob_big_noob.'),(9,'2019-08-12 20:05:55','noob_big_noob (uid: 12) changed Derek_Smith\'s (uid: 4) name to Naked_Ass.'),(10,'2019-08-12 20:06:50','Naked_Ass (uid: 4) accepted Naked_Ass\'s (uid: 4) free namechange to booda_noob.'),(11,'2019-08-12 20:07:08','noob_big_noob (uid: 12) changed noob_big_noob\'s (uid: 12) name to Booda_khaled.'),(12,'2019-08-12 20:11:56','Guillem_El_Chapo (uid: 3) changed Booda_khaled\'s (uid: 12) name to Barney_Phife.'),(13,'2019-08-12 20:12:45','Guillem_El_Chapo (uid: 3) changed Barney_Phife\'s (uid: 12) name to Booda_Khaled.'),(14,'2019-08-12 20:34:15','Booda_Khaled (uid: 12) changed booda_noob\'s (uid: 4) name to Derek_Smithh.'),(15,'2019-08-12 20:34:32','Booda_Khaled (uid: 12) changed Derek_Smithh\'s (uid: 4) name to Derek_Smith.');
/*!40000 ALTER TABLE `log_namechanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_namehistory`
--

DROP TABLE IF EXISTS `log_namehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_namehistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `oldname` varchar(24) DEFAULT NULL,
  `newname` varchar(24) DEFAULT NULL,
  `changedby` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_namehistory`
--

LOCK TABLES `log_namehistory` WRITE;
/*!40000 ALTER TABLE `log_namehistory` DISABLE KEYS */;
INSERT INTO `log_namehistory` VALUES (1,3,'Guillem_Moskow','miboun','Derek_Smith','2019-08-11 21:51:33'),(2,3,'miboun','Guillem_Moskow','Derek_Smith','2019-08-11 22:02:27'),(3,3,'Guillem_Moskow','John_Maxwell','Guillem_Moskow','2019-08-11 22:11:04'),(4,3,'John_Maxwell','Barney_Phife','John_Maxwell','2019-08-12 12:52:29'),(5,3,'Barney_Phife','Guillem_El_Chapo','Barney_Phife','2019-08-12 12:53:20'),(6,3,'Guillem_El_Chapo','Barney_Phife','Guillem_El_Chapo','2019-08-12 19:01:16'),(7,3,'Barney_Phife','Guillem_El_Chapo','Barney_Phife','2019-08-12 19:02:29'),(8,12,'booda_Khaled','noob_big_noob','Derek_Smith','2019-08-12 20:05:36'),(9,4,'Derek_Smith','Naked_Ass','noob_big_noob','2019-08-12 20:05:55'),(10,4,'Naked_Ass','booda_noob','Naked_Ass','2019-08-12 20:06:50'),(11,12,'noob_big_noob','Booda_khaled','noob_big_noob','2019-08-12 20:07:08'),(12,12,'Booda_khaled','Barney_Phife','Guillem_El_Chapo','2019-08-12 20:11:56'),(13,12,'Barney_Phife','Booda_Khaled','Guillem_El_Chapo','2019-08-12 20:12:45'),(14,4,'booda_noob','Derek_Smithh','Booda_Khaled','2019-08-12 20:34:15'),(15,4,'Derek_Smithh','Derek_Smith','Booda_Khaled','2019-08-12 20:34:32');
/*!40000 ALTER TABLE `log_namehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_property`
--

DROP TABLE IF EXISTS `log_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_property` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_property`
--

LOCK TABLES `log_property` WRITE;
/*!40000 ALTER TABLE `log_property` DISABLE KEYS */;
INSERT INTO `log_property` VALUES (1,'2019-08-11 18:57:41','Guillem_Moskow (uid: 3) purchased a land (id: 1) in Temple for $1.'),(2,'2019-08-11 21:23:52','Guillem_Moskow (uid: 3) has edited business id owner to (id: Guillem_Moskow).'),(3,'2019-08-11 21:27:17','Mike_Zodiac (uid: 2) has edited business id owner to (id: Mike_Zodiac).'),(4,'2019-08-12 00:32:36','Mike_Zodiac (uid: 2) has edited business id owner to (id: Mike_Zodiac).'),(5,'2019-08-12 01:12:11','Derek_Smith (uid: 4) purchased a land (id: 2) in Downtown Los Santos for $1.'),(6,'2019-08-12 01:15:23','Derek_Smith (uid: 4) purchased a land (id: 3) in Market for $1.'),(7,'2019-08-12 02:36:07','Mike_Zodiac (uid: 2) has edited business id owner to (id: Mike_Zodiac).'),(8,'2019-08-12 13:23:58','Guillem (uid: 3) purchased a land (id: 4) in Market for $1.'),(9,'2019-08-12 13:43:03','Derek_Smith (uid: 4) purchased a land (id: 5) in Market for $1.'),(10,'2019-08-12 13:48:34','Guillem_El_Chapo (uid: 3) has edited business id owner to (id: Guillem_El_Chapo).'),(11,'2019-08-12 16:14:25','Guillem_El_Chapo (uid: 3) purchased a land (id: 7) in Market for $1.'),(12,'2019-08-12 19:14:49','Guillem_El_Chapo (uid: 3) purchased a land (id: 10) in Market for $1.'),(13,'2019-08-12 19:15:27','Guillem_El_Chapo (uid: 3) purchased a land (id: 11) in Market for $1.'),(14,'2019-08-12 20:25:28','booda_noob (uid: 4) purchased a land (id: 12) in Market for $1.'),(15,'2019-08-12 20:39:49','Derek_Smith (uid: 4) purchased a land (id: 13) in Market for $1.'),(16,'2019-08-12 21:15:09','Guillem_El_Chapo (uid: 3) purchased a land (id: 14) in Market for $1.'),(17,'2019-08-13 03:06:43','Mike_Zodiac (uid: 2) purchased a BMX for $1000.'),(18,'2019-08-13 11:44:49','Guillem_El_Chapo (uid: 3) purchased a land (id: 15) in Marina for $1.'),(19,'2019-08-13 11:51:34','Guillem_El_Chapo (uid: 3) purchased Medium garage (id: 4) for $175000.'),(20,'2019-08-13 13:40:37','Guillem_El_Chapo (uid: 3) purchased a NRG-500 for $400000.'),(21,'2021-02-12 23:22:54','Mike_Zodiac (uid: 2) purchased House (id: 14) for $10000.'),(22,'2021-03-30 23:04:05','Salvador_Tita (uid: 14) purchased a Cadrona for $10000.'),(23,'2021-03-30 23:14:56','Salvador_Tita (uid: 14) purchased Dealership (id: 113) for $15000000.'),(24,'2021-03-31 11:25:58','Mike_Zodiac (uid: 2) purchased a Cadrona for $10000.');
/*!40000 ALTER TABLE `log_property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_punishments`
--

DROP TABLE IF EXISTS `log_punishments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_punishments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_punishments`
--

LOCK TABLES `log_punishments` WRITE;
/*!40000 ALTER TABLE `log_punishments` DISABLE KEYS */;
INSERT INTO `log_punishments` VALUES (1,'2019-08-11 18:47:33','Mike_Zodiac (uid: 2) jailed Guillem_Moskow (uid: 3) for 1 minutes, reason: lol'),(2,'2019-08-11 22:50:38','Mike_Zodiac (uid: 2) jailed Derek_Smith (uid: 4) for 1 minutes, reason: RIP'),(3,'2019-08-11 23:17:34','Mike_Zodiac (uid: 2) banned John_Maxwell (uid: 3), reason: DM'),(4,'2019-08-11 23:17:59','Mike_Zodiac (uid: 2) has unbanned John_Maxwell.'),(5,'2019-08-11 23:19:56','Derek_Smith (uid: 4) banned Mike_Zodiac (uid: 2), reason: noob'),(6,'2019-08-11 23:20:07','Derek_Smith (uid: 4) has unbanned mike_zodiac.'),(7,'2019-08-11 23:35:43','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 30 minutes, reason: DM [/dm]'),(8,'2019-08-11 23:35:59','John_Maxwell (uid: 3) prisoned John_Maxwell (uid: 3) for 50 minutes, reason: k'),(9,'2019-08-11 23:39:16','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 60 minutes, reason: DM [/dm]'),(10,'2019-08-11 23:39:55','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 30 minutes, reason: DM [/dm]'),(11,'2019-08-11 23:39:55','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 60 minutes, reason: DM [/dm]'),(12,'2019-08-11 23:39:56','Mike_Zodiac (uid: 2) banned Derek_Smith (uid: 4), reason: DM (3/3 warnings)'),(13,'2019-08-11 23:40:21','Mike_Zodiac (uid: 2) has unbanned derek_smith.'),(14,'2019-08-12 13:03:59','Mike_Zodiac (uid: 2) kicked Guillem_El_Chapo (uid: 3), reason: server restart'),(15,'2019-08-12 13:04:02','Mike_Zodiac (uid: 2) kicked Derek_Smith (uid: 4), reason: server restart'),(16,'2019-08-12 14:18:40','Derek_Smith (uid: 4) jailed Guillem_El_Chapo (uid: 3) for 100 minutes, reason: noob'),(17,'2019-08-12 14:31:10','Mike_Zodiac (uid: 2) kicked Derek_Smith (uid: 4), reason: ServerRestart'),(18,'2019-08-12 14:31:13','Mike_Zodiac (uid: 2) kicked Mike_Zodiac (uid: 2), reason: ServerRestart'),(19,'2019-08-12 16:03:52','Guillem (uid: 3) jailed Mike_Zodiac (uid: 2) for 1 minutes, reason: test'),(20,'2019-08-12 18:58:51','Mike_Zodiac (uid: 2) jailed Booda (uid: 12) for 1 minutes, reason: Try this shit'),(21,'2019-08-12 19:24:02','Mike_Zodiac (uid: 2) banned Guillem_El_Chapo (uid: 3), reason: RIP'),(22,'2019-08-12 19:24:21','Mike_Zodiac (uid: 2) has unbanned guillem_el_chapo.'),(23,'2019-08-12 19:55:02','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 30 minutes, reason: DM [/dm]'),(24,'2019-08-12 19:55:03','Mike_Zodiac (uid: 2) prisoned Derek_Smith (uid: 4) for 60 minutes, reason: DM [/dm]'),(25,'2019-08-12 19:55:16','Mike_Zodiac (uid: 2) banned Derek_Smith (uid: 4), reason: DM (3/3 warnings)'),(26,'2019-08-12 19:55:27','Mike_Zodiac (uid: 2) has unbanned derek_smith.'),(27,'2019-08-13 00:08:12','booda_Khaled (uid: 12) silently kicked Derek_Smith (uid: 4), reason: DMER'),(28,'2021-03-31 13:10:56','Salvador_Tita (uid: 14) prisoned Salvador_Tita (uid: 14) for 30 minutes, reason: DM [/dm]'),(29,'2021-03-31 13:11:51','Salvador_Tita (uid: 14) prisoned Moez_Tofe7a (uid: 15) for 30 minutes, reason: DM [/dm]');
/*!40000 ALTER TABLE `log_punishments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_referrals`
--

DROP TABLE IF EXISTS `log_referrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_referrals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_referrals`
--

LOCK TABLES `log_referrals` WRITE;
/*!40000 ALTER TABLE `log_referrals` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_referrals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_setstat`
--

DROP TABLE IF EXISTS `log_setstat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_setstat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_setstat`
--

LOCK TABLES `log_setstat` WRITE;
/*!40000 ALTER TABLE `log_setstat` DISABLE KEYS */;
INSERT INTO `log_setstat` VALUES (1,'2019-08-11 20:09:51','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) level to 18'),(2,'2019-08-11 20:10:11','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) level to 18'),(3,'2019-08-11 20:10:29','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) age to 18'),(4,'2019-08-11 20:10:39','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) gender to female'),(5,'2019-08-11 20:10:57','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) mechanicskill to 5'),(6,'2019-08-11 20:11:16','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) mechanicskill to 5'),(7,'2019-08-11 20:11:31','Mike_Zodiac (uid: 2) set Guillem_Moskow\'s (uid: 3) level to 33'),(8,'2019-08-11 21:29:36','Guillem_Moskow (uid: 3) set Guillem_Moskow\'s (uid: 3) hours to 2'),(9,'2019-08-11 21:44:33','Guillem_Moskow (uid: 3) set Derek_Smith\'s (uid: 4) hours to 2'),(10,'2019-08-11 22:11:19','John_Maxwell (uid: 3) set John_Maxwell\'s (uid: 3) level to 2'),(11,'2019-08-11 22:11:22','John_Maxwell (uid: 3) set John_Maxwell\'s (uid: 3) level to 1'),(12,'2019-08-11 23:14:19','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) level to 11'),(13,'2019-08-11 23:16:19','Derek_Smith (uid: 4) set John_Maxwell\'s (uid: 3) level to 5'),(14,'2019-08-11 23:16:20','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) level to 33'),(15,'2019-08-11 23:16:25','Mike_Zodiac (uid: 2) set Derek_Smith\'s (uid: 4) level to 11'),(16,'2019-08-11 23:16:30','Mike_Zodiac (uid: 2) set John_Maxwell\'s (uid: 3) level to 11'),(17,'2019-08-11 23:16:33','Mike_Zodiac (uid: 2) set John_Maxwell\'s (uid: 3) level to 33'),(18,'2019-08-11 23:16:43','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) level to 9999'),(19,'2019-08-11 23:16:50','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) level to 11'),(20,'2019-08-11 23:36:14','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) level to 100'),(21,'2019-08-11 23:36:20','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) hours to 10000'),(22,'2019-08-11 23:36:49','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) weaponrestricted to 0'),(23,'2019-08-11 23:39:43','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) dmwarnings to 0'),(24,'2019-08-11 23:42:18','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) weaponrestricted to 0'),(25,'2019-08-11 23:42:21','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) weaponrestricted to -888'),(26,'2019-08-11 23:42:34','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) dmwarnings to 0'),(27,'2019-08-12 01:03:46','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) cookies to 600'),(28,'2019-08-12 13:03:27','Guillem_El_Chapo (uid: 3) set Derek_Smith\'s (uid: 4) level to 11'),(29,'2019-08-12 13:19:19','Guillem (uid: 3) set Guillem\'s (uid: 3) materials to 50000'),(30,'2019-08-12 14:25:59','Derek_Smith (uid: 4) set Guillem_El_Chapo\'s (uid: 3) cash to 0'),(31,'2019-08-12 14:30:31','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 0'),(32,'2019-08-12 14:48:36','Guillem (uid: 3) set Zou_louloulou\'s (uid: 10) cash to 100000'),(33,'2019-08-12 16:15:34','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 100000'),(34,'2019-08-12 18:52:59','Mike_Zodiac (uid: 2) set booda_Khaled\'s (uid: 12) level to 39'),(35,'2019-08-12 19:57:31','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) dmwarnings to 0'),(36,'2019-08-12 19:58:31','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) bombs to 10'),(37,'2019-08-12 20:06:29','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 200000'),(38,'2019-08-12 20:11:26','Guillem_El_Chapo (uid: 3) set Guillem_El_Chapo\'s (uid: 3) hours to 2'),(39,'2019-08-12 20:11:37','Guillem_El_Chapo (uid: 3) set Booda_khaled\'s (uid: 12) hours to 2'),(40,'2019-08-12 20:11:43','Mike_Zodiac (uid: 2) set Booda_khaled\'s (uid: 12) hours to 5'),(41,'2019-08-12 23:03:19','Zoldic (uid: 2) set Zoldic\'s (uid: 2) cash to 5000'),(42,'2019-08-12 23:26:59','Derek_Smith (uid: 4) set booda_Khaled\'s (uid: 12) weaponrestricted to 0'),(43,'2019-08-12 23:27:05','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) weaponrestricted to 0'),(44,'2019-08-13 00:21:17','Derek_Smith (uid: 4) set Mike_Zodiac\'s (uid: 2) paycheck to 99999'),(45,'2019-08-13 00:39:19','Derek_Smith (uid: 4) set Derek_Smith\'s (uid: 4) mechanicskill to 5'),(46,'2021-02-12 23:22:50','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 20000'),(47,'2021-02-13 14:59:24','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 55'),(48,'2021-02-13 14:59:26','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) cash to 55000'),(49,'2021-03-29 19:46:03','Mike_Zodiac (uid: 2) set Salvador_Tita\'s (uid: 14) level to 3'),(50,'2021-03-29 20:50:49','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 10000'),(51,'2021-03-29 21:10:45','Salvador_Tita (uid: 14) set MOEZ\'s (uid: 15) level to 3'),(52,'2021-03-29 21:36:33','Mike_Zodiac (uid: 2) set Moez_Tofe7a\'s (uid: 15) gps to 1'),(53,'2021-03-31 11:40:15','Salvador_Tita (uid: 14) set Wolverine_X\'s (uid: 21) level to 3'),(54,'2021-03-31 13:39:34','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 1000'),(55,'2021-03-31 14:33:55','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 1'),(56,'2021-03-31 14:34:11','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 3'),(57,'2021-03-31 14:43:18','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) gender to male'),(58,'2021-03-31 15:10:22','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) age to 21'),(59,'2021-03-31 17:35:02','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) level to 10'),(60,'2021-03-31 17:35:18','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 25'),(61,'2021-03-31 17:35:30','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 0'),(62,'2021-03-31 17:43:17','Booda_Khaled (uid: 12) set anas_morello\'s (uid: 18) level to 2'),(63,'2021-03-31 17:43:25','Booda_Khaled (uid: 12) set anas_morello\'s (uid: 18) respect to 22'),(64,'2021-03-31 17:43:36','Booda_Khaled (uid: 12) set anas_morello\'s (uid: 18) hours to 22'),(65,'2021-03-31 18:11:02','TiTa (uid: 14) set TiTa\'s (uid: 14) hours to 2000'),(66,'2021-03-31 18:11:44','Booda (uid: 12) set Salvador_Tita\'s (uid: 14) hours to 200'),(67,'2021-03-31 18:11:50','Booda (uid: 12) set Salvador_Tita\'s (uid: 14) respect to 200'),(68,'2021-03-31 18:12:09','Booda (uid: 12) set Salvador_Tita\'s (uid: 14) level to 2'),(69,'2021-03-31 18:12:21','Salvador_Tita (uid: 14) set Salvador_Tita\'s (uid: 14) hours to 8'),(70,'2021-03-31 18:13:43','Booda (uid: 12) set Salvador_Tita\'s (uid: 14) warnings to 0'),(71,'2021-03-31 18:15:13','Booda_Khaled (uid: 12) set Salvador_Tita\'s (uid: 14) weaponrestricted to 0'),(72,'2021-03-31 18:37:59','Salvador_Tita (uid: 14) set anas_morello\'s (uid: 18) level to 3'),(73,'2021-03-31 21:18:32','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) gender to male'),(74,'2021-03-31 21:19:24','Mike_Zodiac (uid: 2) set Mike_Zodiac\'s (uid: 2) age to 22'),(75,'2021-03-31 21:48:52','Booda_Khaled (uid: 12) set Booda_Khaled\'s (uid: 12) weed to 10'),(76,'2021-03-31 21:48:57','Booda_Khaled (uid: 12) set Booda_Khaled\'s (uid: 12) crack to 10'),(77,'2021-03-31 21:49:03','Booda_Khaled (uid: 12) set Booda_Khaled\'s (uid: 12) heroin to 10');
/*!40000 ALTER TABLE `log_setstat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_vip`
--

DROP TABLE IF EXISTS `log_vip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_vip` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_vip`
--

LOCK TABLES `log_vip` WRITE;
/*!40000 ALTER TABLE `log_vip` DISABLE KEYS */;
INSERT INTO `log_vip` VALUES (1,'2019-08-12 19:15:02','Mike_Zodiac (uid: 2) has given booda_Khaled (uid: 12) a Legendary VIP package for 4 days.'),(2,'2019-08-12 19:15:28','Mike_Zodiac (uid: 2) has given Mike_Zodiac (uid: 2) a Legendary VIP package for 4 days.'),(3,'2019-08-12 19:15:34','Mike_Zodiac (uid: 2) has given Guillem_El_Chapo (uid: 3) a Legendary VIP package for 4 days.'),(4,'2021-02-12 23:30:26','Mike_Zodiac (uid: 2) has given Mike_Zodiac (uid: 2) a Legendary VIP package for 1 days.'),(5,'2021-03-31 12:57:08','Salvador_Tita (uid: 14) has given Salvador_Tita (uid: 14) a Legendary VIP package for 365 days.'),(6,'2021-03-31 13:01:50','Salvador_Tita (uid: 14) has given Moez_Tofe7a (uid: 15) a Legendary VIP package for 365 days.'),(7,'2021-03-31 17:37:37','Salvador_Tita (uid: 14) has removed Salvador_Tita\'s (uid: 14) Legendary VIP package.'),(8,'2021-03-31 18:20:00','Salvador_Tita (uid: 14) has given Salvador_Tita (uid: 14) a Legendary VIP package for 3 days.');
/*!40000 ALTER TABLE `log_vip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `postedby` varchar(200) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `news` text CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `subject` varchar(200) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL,
  `date` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phonebook`
--

DROP TABLE IF EXISTS `phonebook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phonebook` (
  `name` varchar(24) DEFAULT NULL,
  `number` int DEFAULT NULL,
  UNIQUE KEY `number` (`number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phonebook`
--

LOCK TABLES `phonebook` WRITE;
/*!40000 ALTER TABLE `phonebook` DISABLE KEYS */;
/*!40000 ALTER TABLE `phonebook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playerbackpack`
--

DROP TABLE IF EXISTS `playerbackpack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playerbackpack` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BackpackCreated` int NOT NULL DEFAULT '0',
  `BackpackOwner` int NOT NULL DEFAULT '-1',
  `BackpackOwnerName` varchar(24) NOT NULL DEFAULT 'Vacant',
  `BackpackSize` int NOT NULL DEFAULT '0',
  `Attached` int NOT NULL DEFAULT '0',
  `PosX` float NOT NULL DEFAULT '0',
  `PosY` float NOT NULL DEFAULT '0',
  `PosZ` float NOT NULL DEFAULT '0',
  `VirtualWorld` int NOT NULL DEFAULT '-1',
  `InteriorWorld` int NOT NULL DEFAULT '-1',
  `Cash` int NOT NULL DEFAULT '0',
  `Crack` int NOT NULL DEFAULT '0',
  `Pot` int NOT NULL DEFAULT '0',
  `Mats` int NOT NULL DEFAULT '0',
  `Gun0` int NOT NULL DEFAULT '0',
  `Gun1` int NOT NULL DEFAULT '0',
  `Gun2` int NOT NULL DEFAULT '0',
  `Gun3` int NOT NULL DEFAULT '0',
  `Gun4` int NOT NULL DEFAULT '0',
  `Gun5` int NOT NULL DEFAULT '0',
  `Gun6` int NOT NULL DEFAULT '0',
  `Gun7` int NOT NULL DEFAULT '0',
  `Gun8` int NOT NULL DEFAULT '0',
  `Gun9` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playerbackpack`
--

LOCK TABLES `playerbackpack` WRITE;
/*!40000 ALTER TABLE `playerbackpack` DISABLE KEYS */;
/*!40000 ALTER TABLE `playerbackpack` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `points`
--

DROP TABLE IF EXISTS `points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `points` (
  `id` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `capturedby` varchar(24) DEFAULT 'No-one',
  `capturedgang` tinyint DEFAULT '-1',
  `type` tinyint DEFAULT '0',
  `profits` int DEFAULT '0',
  `time` tinyint DEFAULT '24',
  `point_x` float DEFAULT '0',
  `point_y` float DEFAULT '0',
  `point_z` float DEFAULT '0',
  `pointinterior` tinyint DEFAULT '0',
  `pointworld` int DEFAULT '0',
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `points`
--

LOCK TABLES `points` WRITE;
/*!40000 ALTER TABLE `points` DISABLE KEYS */;
/*!40000 ALTER TABLE `points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_acp`
--

DROP TABLE IF EXISTS `posts_acp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_acp` (
  `title` varchar(64) NOT NULL,
  `date` date NOT NULL,
  `description` text NOT NULL,
  `postedby` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_acp`
--

LOCK TABLES `posts_acp` WRITE;
/*!40000 ALTER TABLE `posts_acp` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts_acp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `radiostations`
--

DROP TABLE IF EXISTS `radiostations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `radiostations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(90) NOT NULL,
  `url` varchar(128) NOT NULL,
  `genre` varchar(90) NOT NULL,
  `subgenre` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `radiostations`
--

LOCK TABLES `radiostations` WRITE;
/*!40000 ALTER TABLE `radiostations` DISABLE KEYS */;
/*!40000 ALTER TABLE `radiostations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_atms`
--

DROP TABLE IF EXISTS `rp_atms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_atms` (
  `atmID` int NOT NULL AUTO_INCREMENT,
  `atmX` float DEFAULT '0',
  `atmY` float DEFAULT '0',
  `atmZ` float DEFAULT '0',
  `atmA` float DEFAULT '0',
  `atmInterior` int DEFAULT '0',
  `atmWorld` int DEFAULT '0',
  PRIMARY KEY (`atmID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_atms`
--

LOCK TABLES `rp_atms` WRITE;
/*!40000 ALTER TABLE `rp_atms` DISABLE KEYS */;
INSERT INTO `rp_atms` VALUES (1,1137.12,-1631.45,13.6384,180.237,0,0),(2,1473.98,-1814.2,13.1152,178.674,0,0),(3,1484.49,-1814.23,13.1652,179.227,0,0),(5,1600.4,-1172.65,23.9857,-0.7247,0,0),(6,1606.8,-1172.68,24.0157,-0.5515,0,0);
/*!40000 ALTER TABLE `rp_atms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_contacts`
--

DROP TABLE IF EXISTS `rp_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_contacts` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Phone` int DEFAULT '0',
  `Contact` varchar(24) DEFAULT NULL,
  `Number` int DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_contacts`
--

LOCK TABLES `rp_contacts` WRITE;
/*!40000 ALTER TABLE `rp_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `rp_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_dealercars`
--

DROP TABLE IF EXISTS `rp_dealercars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_dealercars` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Company` int DEFAULT '0',
  `Model` int DEFAULT '0',
  `Price` int DEFAULT '0',
  `type` varchar(12) NOT NULL DEFAULT '',
  `doors` varchar(12) NOT NULL DEFAULT '',
  `maxspeed` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `Company` (`Company`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_dealercars`
--

LOCK TABLES `rp_dealercars` WRITE;
/*!40000 ALTER TABLE `rp_dealercars` DISABLE KEYS */;
INSERT INTO `rp_dealercars` VALUES (1,107,521,14000,'','',''),(2,107,522,400000,'','',''),(3,107,510,400000,'','',''),(4,107,481,1000,'','',''),(11,112,473,50000,'','',''),(12,112,493,150000,'','',''),(13,112,446,300000,'','',''),(14,110,519,1200000,'','',''),(15,113,527,10000,'','',''),(16,113,491,20000,'','',''),(17,113,529,15000,'','',''),(18,113,445,8000,'','','');
/*!40000 ALTER TABLE `rp_dealercars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_furniture`
--

DROP TABLE IF EXISTS `rp_furniture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_furniture` (
  `fID` int NOT NULL AUTO_INCREMENT,
  `fHouseID` int DEFAULT '0',
  `fModel` int DEFAULT '0',
  `fX` float DEFAULT '0',
  `fY` float DEFAULT '0',
  `fZ` float DEFAULT '0',
  `fRX` float DEFAULT '0',
  `fRY` float DEFAULT '0',
  `fRZ` float DEFAULT '0',
  `fInterior` int DEFAULT '0',
  `fWorld` int DEFAULT '0',
  `fCode` int DEFAULT '0',
  `fMoney` int DEFAULT '0',
  `Mat1` int DEFAULT '0',
  `Mat2` int DEFAULT '0',
  `Mat3` int DEFAULT '0',
  `MatColor1` int DEFAULT '0',
  `MatColor2` int DEFAULT '0',
  `MatColor3` int DEFAULT '0',
  PRIMARY KEY (`fID`),
  KEY `fHouseID` (`fHouseID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_furniture`
--

LOCK TABLES `rp_furniture` WRITE;
/*!40000 ALTER TABLE `rp_furniture` DISABLE KEYS */;
INSERT INTO `rp_furniture` VALUES (1,5,19370,2322.98,-1148.29,1051.41,0,0,-5.481,12,1000005,0,0,0,0,0,0,0,0),(2,5,19370,2326.09,-1148.28,1051.38,0,0,-0.482,12,1000005,0,0,0,0,0,0,0,0),(3,5,2257,2325.12,-1146.73,1050.71,0,0,-6.682,12,1000005,0,0,0,0,0,0,0,0),(6,5,2097,2333.22,-1135.8,1050.11,0,0,357.691,12,1000005,0,0,0,0,0,0,0,0),(8,5,19462,2326.36,-1147.34,1055.84,-96.4,88,176.339,12,1000005,0,0,0,0,0,0,0,0),(9,5,1493,2334.33,-1141.89,1049.65,0,0,336.202,12,1000005,0,0,146,0,0,4,0,0),(11,5,1504,2323.16,-1144.1,1049.64,0,0,0,12,1000005,0,0,0,0,0,0,0,0),(12,14,1433,2233.68,-1110.63,1050.08,0,0,157.608,5,1000014,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `rp_furniture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_gundamages`
--

DROP TABLE IF EXISTS `rp_gundamages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_gundamages` (
  `Weapon` tinyint DEFAULT NULL,
  `Damage` float DEFAULT NULL,
  UNIQUE KEY `Weapon` (`Weapon`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_gundamages`
--

LOCK TABLES `rp_gundamages` WRITE;
/*!40000 ALTER TABLE `rp_gundamages` DISABLE KEYS */;
/*!40000 ALTER TABLE `rp_gundamages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rp_payphones`
--

DROP TABLE IF EXISTS `rp_payphones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rp_payphones` (
  `phID` int NOT NULL AUTO_INCREMENT,
  `phNumber` int DEFAULT '0',
  `phX` float DEFAULT '0',
  `phY` float DEFAULT '0',
  `phZ` float DEFAULT '0',
  `phA` float DEFAULT '0',
  `phInterior` int DEFAULT '0',
  `phWorld` int DEFAULT '0',
  PRIMARY KEY (`phID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rp_payphones`
--

LOCK TABLES `rp_payphones` WRITE;
/*!40000 ALTER TABLE `rp_payphones` DISABLE KEYS */;
/*!40000 ALTER TABLE `rp_payphones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `server_info`
--

DROP TABLE IF EXISTS `server_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `server_info` (
  `totalconnections` int NOT NULL,
  `tax` int NOT NULL,
  `govvault` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_info`
--

LOCK TABLES `server_info` WRITE;
/*!40000 ALTER TABLE `server_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shots`
--

DROP TABLE IF EXISTS `shots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `playerid` smallint DEFAULT NULL,
  `weaponid` tinyint DEFAULT NULL,
  `hittype` tinyint DEFAULT NULL,
  `hitid` int DEFAULT NULL,
  `hitplayer` varchar(24) DEFAULT NULL,
  `pos_x` float DEFAULT NULL,
  `pos_y` float DEFAULT NULL,
  `pos_z` float DEFAULT NULL,
  `timestamp` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shots`
--

LOCK TABLES `shots` WRITE;
/*!40000 ALTER TABLE `shots` DISABLE KEYS */;
/*!40000 ALTER TABLE `shots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speedcameras`
--

DROP TABLE IF EXISTS `speedcameras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `speedcameras` (
  `speedID` int NOT NULL AUTO_INCREMENT,
  `speedRange` float DEFAULT '0',
  `speedLimit` float DEFAULT '0',
  `speedX` float DEFAULT '0',
  `speedY` float DEFAULT '0',
  `speedZ` float DEFAULT '0',
  `speedAngle` float DEFAULT '0',
  PRIMARY KEY (`speedID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedcameras`
--

LOCK TABLES `speedcameras` WRITE;
/*!40000 ALTER TABLE `speedcameras` DISABLE KEYS */;
/*!40000 ALTER TABLE `speedcameras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `texts`
--

DROP TABLE IF EXISTS `texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `texts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_number` int DEFAULT NULL,
  `recipient_number` int DEFAULT NULL,
  `sender` varchar(24) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `texts`
--

LOCK TABLES `texts` WRITE;
/*!40000 ALTER TABLE `texts` DISABLE KEYS */;
/*!40000 ALTER TABLE `texts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `player` varchar(25) NOT NULL,
  `officer` varchar(25) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `amount` int NOT NULL,
  `reason` varchar(64) NOT NULL,
  `paid` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turfs`
--

DROP TABLE IF EXISTS `turfs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turfs` (
  `id` tinyint DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `capturedby` varchar(24) DEFAULT 'No-one',
  `capturedgang` tinyint DEFAULT '-1',
  `type` tinyint DEFAULT '0',
  `time` tinyint DEFAULT '12',
  `min_x` float DEFAULT '0',
  `min_y` float DEFAULT '0',
  `max_x` float DEFAULT '0',
  `max_y` float DEFAULT '0',
  `height` float DEFAULT '0',
  `heightx` float NOT NULL,
  `heighty` float NOT NULL,
  `heightz` float NOT NULL,
  `heightvirtualworld` int NOT NULL,
  `heightinterior` int NOT NULL,
  `count` int NOT NULL DEFAULT '3',
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turfs`
--

LOCK TABLES `turfs` WRITE;
/*!40000 ALTER TABLE `turfs` DISABLE KEYS */;
INSERT INTO `turfs` VALUES (2,'Material Factory 2','No-one',-1,1,0,2228.15,-1144.64,2297.81,-1074.05,37.977,2284.84,-1111.58,37.977,0,0,3),(3,'Market','No-one',-1,7,0,1055.17,-1572.99,1196.08,-1400.49,15.37,1113.24,-1488.32,15.369,0,0,3),(4,'Unity Train Station','No-one',-1,7,0,1672.18,-1996.66,1823.73,-1737.28,13.567,1743.45,-1944.02,13.568,0,0,3),(5,'Chemical Lab','No-one',-1,7,0,1610.91,-2112.37,1847.41,-2010.22,13.583,1759.38,-2055.9,13.583,0,0,3),(7,'Santa Maria Beach','No-one',-1,7,0,566.228,-1885.79,810.708,-1700.15,11.611,722.991,-1846.8,11.612,0,0,3),(8,'Tennis Club','No-one',-1,2,0,611.071,-1322.41,803.827,-1058.34,13.12,755.231,-1258.83,13.12,0,0,3),(9,'TransFender Garage','No-one',-1,1,0,954.257,-1144.86,1162.46,-979.777,31.675,1036.39,-1028.8,31.675,0,0,3),(11,'Casino','No-one',-1,1,0,1262.81,-1183.45,1560.49,-919.904,17.56,1428.17,-1083.48,17.56,0,0,3),(14,'Downtow Los Santos','No-one',-1,3,0,1609.64,-1318.38,1777.9,-1164.6,14.543,1694.87,-1219.29,14.543,0,0,3),(15,'Commerce','No-one',-1,3,0,1610,-1469.51,1790.19,-1329.98,13.28,1658.47,-1425.54,13.28,0,0,3),(16,'Downtown Los Santos','No-one',-1,7,0,1463.15,-1293.57,1598.19,-1175.02,16.981,1539.78,-1277.49,16.98,0,0,3),(17,'Glen Park','No-one',-1,3,0,1797.51,-1305.69,2167.37,-1124.03,19.624,1972.96,-1235.47,19.622,0,0,3),(18,'Commerce','No-one',-1,7,0,1453.13,-1441.59,1605.22,-1304.22,11.456,1475.38,-1418.75,11.456,0,0,3),(19,'Las Colinas','No-one',-1,4,0,1945.36,-1109.76,2137.41,-1006.32,25.839,2040.69,-1037.51,25.839,0,0,3),(0,'Material Pickup 1','No-one',-1,7,0,1336.04,-1437.61,1455.49,-1173.75,13.276,1347.76,-1278.74,13.276,0,0,3),(1,'Material Factory 1','No-one',-1,1,0,2083.53,-2380.07,2344.44,-2138.11,13.37,2174.06,-2265.98,13.37,0,0,3),(10,'Material Pickup 2','No-one',-1,7,0,2221.16,-2059.79,2432.32,-1903.97,13.554,2393.68,-2008.72,13.554,0,0,3),(12,'M.O.E.Z Neighborhood','No-one',-1,7,0,2218.74,-1886.52,2408.74,-1747.49,13.547,2263.99,-1754.94,13.547,0,0,3),(6,'Idle Wood','No-one',-1,4,0,1891.41,-1866.1,2129.89,-1570.74,13.547,2042.11,-1642.02,13.547,0,0,3);
/*!40000 ALTER TABLE `turfs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `passwordchanged` tinyint(1) NOT NULL DEFAULT '0',
  `uid` int NOT NULL AUTO_INCREMENT,
  `username` varchar(24) DEFAULT NULL,
  `password` varchar(129) DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `lastlogin` datetime DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `setup` tinyint(1) DEFAULT '1',
  `gender` tinyint(1) DEFAULT '1',
  `age` tinyint DEFAULT '18',
  `skin` smallint DEFAULT '299',
  `camera_x` float DEFAULT '0',
  `camera_y` float DEFAULT '0',
  `camera_z` float DEFAULT '0',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `cash` int DEFAULT '5000',
  `bank` int DEFAULT '10000',
  `paycheck` int DEFAULT '0',
  `level` int DEFAULT '1',
  `exp` int DEFAULT '0',
  `minutes` int DEFAULT '0',
  `hours` int DEFAULT '0',
  `adminlevel` int DEFAULT '0',
  `adminname` varchar(24) DEFAULT 'None',
  `helperlevel` tinyint DEFAULT '0',
  `health` float DEFAULT '100',
  `armor` float DEFAULT '0',
  `upgradepoints` int DEFAULT '0',
  `warnings` tinyint DEFAULT '0',
  `injured` tinyint(1) DEFAULT '0',
  `hospital` tinyint(1) DEFAULT '0',
  `spawnhealth` float DEFAULT '50',
  `spawnarmor` float DEFAULT '0',
  `jailtype` tinyint(1) DEFAULT '0',
  `jailtime` int DEFAULT '0',
  `newbiemuted` tinyint(1) DEFAULT '0',
  `helpmuted` tinyint(1) DEFAULT '0',
  `admuted` tinyint(1) DEFAULT '0',
  `livemuted` tinyint(1) DEFAULT '0',
  `globalmuted` tinyint(1) DEFAULT '0',
  `reportmuted` tinyint DEFAULT '0',
  `reportwarns` tinyint DEFAULT '0',
  `fightstyle` tinyint DEFAULT '4',
  `locked` tinyint(1) DEFAULT '0',
  `accent` varchar(16) DEFAULT 'None',
  `cookies` int DEFAULT '0',
  `phone` int DEFAULT '0',
  `job` int DEFAULT '-1',
  `secondjob` tinyint DEFAULT '-1',
  `crimes` int DEFAULT '0',
  `arrested` int DEFAULT '0',
  `wantedlevel` tinyint DEFAULT '0',
  `materials` int DEFAULT '0',
  `weed` int DEFAULT '0',
  `cocaine` int DEFAULT '0',
  `meth` int DEFAULT '0',
  `painkillers` int DEFAULT '0',
  `seeds` int DEFAULT '0',
  `ephedrine` int DEFAULT '0',
  `muriaticacid` int DEFAULT '0',
  `bakingsoda` int DEFAULT '0',
  `cigars` int DEFAULT '0',
  `walkietalkie` tinyint(1) DEFAULT '0',
  `channel` int DEFAULT '0',
  `rentinghouse` int DEFAULT '0',
  `spraycans` int DEFAULT '0',
  `boombox` tinyint(1) DEFAULT '0',
  `mp3player` tinyint(1) DEFAULT '0',
  `phonebook` tinyint(1) DEFAULT '0',
  `fishingrod` tinyint(1) DEFAULT '0',
  `fishingbait` int DEFAULT '0',
  `fishweight` int DEFAULT '0',
  `components` int DEFAULT '0',
  `courierskill` int DEFAULT '0',
  `fishingskill` int DEFAULT '0',
  `guardskill` int DEFAULT '0',
  `weaponskill` int DEFAULT '0',
  `mechanicskill` int DEFAULT '0',
  `lawyerskill` int DEFAULT '0',
  `detectiveskill` int DEFAULT '0',
  `smugglerskill` int DEFAULT '0',
  `robberyskill` int NOT NULL DEFAULT '0',
  `hookerskill` int NOT NULL DEFAULT '0',
  `truckerskill` int NOT NULL DEFAULT '0',
  `pizzaskill` int NOT NULL DEFAULT '0',
  `craftskill` int NOT NULL DEFAULT '0',
  `carjackerskill` int NOT NULL DEFAULT '0',
  `forkliftskill` int NOT NULL DEFAULT '0',
  `farmerskill` int NOT NULL DEFAULT '0',
  `drugdealerskill` int NOT NULL DEFAULT '0',
  `toggletextdraws` tinyint(1) DEFAULT '0',
  `togglebug` tinyint(1) DEFAULT '0',
  `toggleooc` tinyint(1) DEFAULT '0',
  `togglephone` tinyint(1) DEFAULT '0',
  `toggleadmin` tinyint(1) DEFAULT '0',
  `togglehelper` tinyint(1) DEFAULT '0',
  `togglenewbie` tinyint(1) DEFAULT '0',
  `togglewt` tinyint(1) DEFAULT '0',
  `toggleradio` tinyint(1) DEFAULT '0',
  `togglevip` tinyint(1) DEFAULT '0',
  `togglemusic` tinyint(1) DEFAULT '0',
  `togglefaction` tinyint(1) DEFAULT '0',
  `togglegang` tinyint(1) DEFAULT '0',
  `togglenews` tinyint(1) DEFAULT '0',
  `toggleglobal` tinyint(1) DEFAULT '1',
  `togglecam` tinyint(1) DEFAULT '0',
  `carlicense` tinyint(1) DEFAULT '0',
  `vippackage` tinyint DEFAULT '0',
  `viptime` int DEFAULT '0',
  `vipcooldown` int DEFAULT '0',
  `weapon_0` tinyint DEFAULT '0',
  `weapon_1` tinyint DEFAULT '0',
  `weapon_2` tinyint DEFAULT '0',
  `weapon_3` tinyint DEFAULT '0',
  `weapon_4` tinyint DEFAULT '0',
  `weapon_5` tinyint DEFAULT '0',
  `weapon_6` tinyint DEFAULT '0',
  `weapon_7` tinyint DEFAULT '0',
  `weapon_8` tinyint DEFAULT '0',
  `weapon_9` tinyint DEFAULT '0',
  `weapon_10` tinyint DEFAULT '0',
  `weapon_11` tinyint DEFAULT '0',
  `weapon_12` tinyint DEFAULT '0',
  `ammo_0` smallint DEFAULT '0',
  `ammo_1` smallint DEFAULT '0',
  `ammo_2` smallint DEFAULT '0',
  `ammo_3` smallint DEFAULT '0',
  `ammo_4` smallint DEFAULT '0',
  `ammo_5` smallint DEFAULT '0',
  `ammo_6` smallint DEFAULT '0',
  `ammo_7` smallint DEFAULT '0',
  `ammo_8` smallint DEFAULT '0',
  `ammo_9` smallint DEFAULT '0',
  `ammo_10` smallint DEFAULT '0',
  `ammo_11` smallint DEFAULT '0',
  `ammo_12` smallint DEFAULT '0',
  `faction` tinyint DEFAULT '-1',
  `gang` tinyint DEFAULT '-1',
  `factionrank` tinyint DEFAULT '0',
  `gangrank` tinyint DEFAULT '0',
  `division` tinyint DEFAULT '-1',
  `contracted` int DEFAULT '0',
  `contractby` varchar(24) DEFAULT 'Nobody',
  `bombs` int DEFAULT '0',
  `completedhits` int DEFAULT '0',
  `failedhits` int DEFAULT '0',
  `reports` int DEFAULT '0',
  `helprequests` int DEFAULT '0',
  `speedometer` tinyint(1) DEFAULT '1',
  `factionmod` tinyint(1) DEFAULT '0',
  `gangmod` tinyint(1) DEFAULT '0',
  `banappealer` tinyint(1) DEFAULT '0',
  `helpermanager` tinyint(1) DEFAULT '0',
  `dynamicadmin` tinyint(1) DEFAULT '0',
  `adminpersonnel` tinyint(1) DEFAULT '0',
  `weedplanted` tinyint(1) DEFAULT '0',
  `weedtime` int DEFAULT '0',
  `weedgrams` int DEFAULT '0',
  `weed_x` float DEFAULT '0',
  `weed_y` float DEFAULT '0',
  `weed_z` float DEFAULT '0',
  `weed_a` float DEFAULT '0',
  `inventoryupgrade` int DEFAULT '0',
  `addictupgrade` int DEFAULT '0',
  `traderupgrade` int DEFAULT '0',
  `assetupgrade` int DEFAULT '0',
  `pistolammo` smallint DEFAULT '0',
  `shotgunammo` smallint DEFAULT '0',
  `smgammo` smallint DEFAULT '0',
  `arammo` smallint DEFAULT '0',
  `rifleammo` smallint DEFAULT '0',
  `hpammo` smallint DEFAULT '0',
  `poisonammo` smallint DEFAULT '0',
  `fmjammo` smallint DEFAULT '0',
  `ammotype` tinyint DEFAULT '0',
  `ammoweapon` tinyint DEFAULT '0',
  `dmwarnings` tinyint DEFAULT '0',
  `weaponrestricted` int DEFAULT '0',
  `referral_uid` int DEFAULT '0',
  `refercount` int DEFAULT '0',
  `watch` tinyint(1) DEFAULT '0',
  `gps` tinyint(1) DEFAULT '0',
  `prisonedby` varchar(24) DEFAULT 'No-one',
  `prisonreason` varchar(128) DEFAULT 'None',
  `togglehud` tinyint(1) DEFAULT '1',
  `clothes` smallint DEFAULT '-1',
  `showturfs` tinyint(1) DEFAULT '0',
  `showlands` tinyint(1) DEFAULT '0',
  `watchon` tinyint(1) DEFAULT '0',
  `gpson` tinyint(1) DEFAULT '0',
  `doublexp` int DEFAULT '0',
  `couriercooldown` int DEFAULT '0',
  `pizzacooldown` int DEFAULT '0',
  `detectivecooldown` int DEFAULT '0',
  `gascan` tinyint(1) DEFAULT NULL,
  `duty` int DEFAULT NULL,
  `bandana` tinyint DEFAULT NULL,
  `login_date` date DEFAULT NULL,
  `FormerAdmin` tinyint NOT NULL DEFAULT '0',
  `customtitle` varchar(128) DEFAULT NULL,
  `customcolor` int NOT NULL DEFAULT '-256',
  `scanneron` tinyint(1) DEFAULT '0',
  `rimkits` int DEFAULT '0',
  `bodykits` int DEFAULT '0',
  `policescanner` tinyint(1) DEFAULT '0',
  `firstaid` int DEFAULT '0',
  `extraSongs` int NOT NULL DEFAULT '0',
  `top10` tinyint(1) NOT NULL DEFAULT '1',
  `totalfires` int DEFAULT '0',
  `totalpatients` int DEFAULT '0',
  `money_earned` bigint DEFAULT '0',
  `money_spent` bigint DEFAULT '0',
  `rope` int DEFAULT '0',
  `insurance` tinyint(1) DEFAULT '0',
  `adminhide` tinyint(1) DEFAULT '0',
  `passportphone` int DEFAULT '0',
  `passportskin` smallint DEFAULT '0',
  `passportlevel` int DEFAULT '0',
  `passportname` varchar(24) DEFAULT 'None',
  `passport` tinyint(1) DEFAULT '0',
  `globalmutetime` int DEFAULT '0',
  `reportmutetime` int DEFAULT '0',
  `newbiemutetime` int DEFAULT '0',
  `togglereports` tinyint(1) DEFAULT '0',
  `thiefcooldown` int DEFAULT '0',
  `crackcooldown` int DEFAULT '0',
  `laborupgrade` int DEFAULT '0',
  `scripter` tinyint(1) DEFAULT '0',
  `factionleader` tinyint(1) DEFAULT '0',
  `thiefskill` int DEFAULT '0',
  `togglewhisper` tinyint(1) DEFAULT '0',
  `landkeys` tinyint NOT NULL DEFAULT '-1',
  `rarecooldown` int DEFAULT '0',
  `diamonds` smallint DEFAULT '0',
  `bugged` tinyint(1) DEFAULT '0',
  `buggedby` varchar(30) NOT NULL DEFAULT '',
  `gameaffairs` tinyint(1) DEFAULT '0',
  `crew` tinyint DEFAULT '-1',
  `newbies` mediumint DEFAULT '0',
  `rollerskates` tinyint DEFAULT '0',
  `marriedto` int DEFAULT '-1',
  `humanresources` tinyint(1) DEFAULT '0',
  `complaintmod` tinyint(1) DEFAULT '0',
  `webdev` tinyint(1) DEFAULT '0',
  `graphic` tinyint(1) DEFAULT '0',
  `vehlock` tinyint(1) DEFAULT '0',
  `sprunk` int DEFAULT '0',
  `truckinglevel` int DEFAULT '0',
  `truckingxp` int DEFAULT '0',
  `santagifts` int DEFAULT '0',
  `seckey` int unsigned DEFAULT NULL,
  `togglepoint` tinyint NOT NULL DEFAULT '0',
  `togglepm` tinyint(1) DEFAULT '0',
  `toggleturfs` tinyint(1) DEFAULT '0',
  `togglepoints` tinyint(1) DEFAULT '0',
  `tuckinglevel` int NOT NULL DEFAULT '1',
  `notoriety` int DEFAULT '0',
  `thirsttimer` int DEFAULT NULL,
  `thirst` int DEFAULT NULL,
  `thrist` int DEFAULT NULL,
  `gunlicense` tinyint NOT NULL DEFAULT '1',
  `togglevehicle` tinyint NOT NULL DEFAULT '0',
  `housealarm` tinyint NOT NULL DEFAULT '0',
  `dj` int NOT NULL DEFAULT '0',
  `helmet` int NOT NULL DEFAULT '0',
  `blindfold` int NOT NULL DEFAULT '0',
  `Ammo1` int DEFAULT '50',
  `Ammo2` int DEFAULT '50',
  `Ammo3` int DEFAULT '50',
  `Ammo4` int DEFAULT '50',
  `Ammo5` int DEFAULT '50',
  `Ammo6` int DEFAULT '50',
  `Ammo7` int DEFAULT '50',
  `Ammo8` int DEFAULT '50',
  `Ammo9` int DEFAULT '50',
  `Ammo10` int DEFAULT '50',
  `Ammo11` int DEFAULT '50',
  `Ammo12` int DEFAULT '50',
  `Ammo13` int DEFAULT '50',
  `weapon_13` int DEFAULT '0',
  `HungerDeathTimer` int NOT NULL DEFAULT '0',
  `Hunger` int NOT NULL DEFAULT '50',
  `HungerTimer` int NOT NULL DEFAULT '0',
  `spawnhouse` int NOT NULL DEFAULT '-1',
  `spawntype` int NOT NULL DEFAULT '0',
  `chatstyle` int NOT NULL DEFAULT '0',
  `addeddate` datetime DEFAULT NULL,
  `removeddate` datetime DEFAULT NULL,
  `adminstrike` int NOT NULL DEFAULT '0',
  `crowbar` int NOT NULL DEFAULT '0',
  `vehiclecmd` int NOT NULL DEFAULT '0',
  `sweep` int NOT NULL DEFAULT '0',
  `sweepleft` int NOT NULL DEFAULT '0',
  `rccam` int NOT NULL DEFAULT '0',
  `condom` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,2,'Mike_Zodiac','880DB386437B0EA253025F2BFC1D888555EC45BF240185AA11D81F8E21E7995FD2F615C8262ED0844730521E1B2622EDE9EEE7879D24B02649EF92E874FE8672','2019-08-11 17:47:13','2021-03-31 22:20:16','41.62.17.201',0,1,22,230,819.22,-1133.33,24.631,817.713,-1132.42,23.82,357.705,0,0,38058,1070514,0,18,42,195,24,10,'Zoldic',7,45,0,1,0,0,0,55,0,0,0,0,0,0,0,0,0,0,16,0,'None',6,457750,7,-1,6,0,0,0,0,0,0,0,0,0,5,0,0,1,0,0,0,1,0,0,1,0,0,0,0,4,0,0,5,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,6,6,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,'No-one','None',0,230,1,1,0,1,0,0,0,0,3,1,0,NULL,0,'3aspa',16776960,0,0,0,0,0,0,1,0,0,1010453833,922548785,0,2,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'NULL',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,2995,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,'2021-03-31 21:45:00','2021-03-31 21:36:00',0,0,0,0,0,0,0),(1,3,'Guillem_El_Chapo','F21DE41B434CD564C0F3E6B7A48B4F48E90341AF3C9CBDCFC98843F9E5FC775CD01BA1428190E604588FC88958743795D7A7CD4ABF715C5E15AC59A782C53BA2','2019-08-11 18:18:45','2019-08-13 14:14:50','25.70.18.118',0,1,18,58,2322.31,-1142.76,1051.63,2322.31,-1139.3,1050.49,270,12,4000002,871339,53881,0,33,17,83,4,10,'Guillem',0,55,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,5,0,'English',4,499060,11,12,0,0,0,50000,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,10,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,-1,6,0,-1,0,'Nobody',0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'John_Maxwell','k',0,-1,0,1,0,0,0,0,0,0,NULL,0,0,NULL,0,'Assistant Management',10092288,0,0,0,0,0,0,1,0,0,2264696761,1001365206,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,1,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,4,'Derek_Smith','30E8E57988E8A6D4EB1731C1EB20AA9986675B27DCC892E11E9597D37B589DE91C2868DB44559E109A6089C60E3B61275E945DC1D1047356335A1146E4138265','2019-08-11 20:46:51','2019-08-13 14:38:21','25.104.144.149',0,1,89,230,2072.44,-1666.3,14.495,2072.19,-1662.96,13.547,274.281,0,0,1048879,60136,0,11,26,36,10009,9,'Derek_Smith',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,5,0,'None',600,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'No-one',8,4,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mike_Zodiac','DM',0,173,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,'\"GOD\"',-15658752,0,0,0,0,0,0,1,0,1,891077972,890034093,0,2,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,5,'Zilo_Alamb','1B133A6D485F031F26407E1A5A41B4C8FEA715E8B00B4B914034E6192120FE51CDC4CB2F26562AAE74C1232083A845C6AEEE92DC325DD8F139A0C719EA9E5C44','2019-08-12 03:47:27','2019-08-12 03:47:27','127.0.0.1',0,1,18,299,1561.66,-2335.02,16.166,1559.95,-2332.01,15.08,88.348,0,0,5000,10000,0,1,0,4,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,6,'Zeno_Zoldyck','614CAD4F3F8535D4C8C9A952F9808778C2EEB9014755371D98D82446915B055E5CB2451C996EDB51BA94C890F3BC5C28A7F4513874E8E51248BD36ECE7342014','2019-08-12 04:01:01','2019-08-12 04:01:01','127.0.0.1',0,1,18,299,1563.3,-2330.99,16.132,1559.98,-2331.99,15.085,89.148,0,0,5000,10000,0,1,0,1,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,7,'Zeno_Zoldycks','614CAD4F3F8535D4C8C9A952F9808778C2EEB9014755371D98D82446915B055E5CB2451C996EDB51BA94C890F3BC5C28A7F4513874E8E51248BD36ECE7342014','2019-08-12 04:06:50','2019-08-12 04:06:50','127.0.0.1',0,1,18,299,0,0,0,0,0,0,0,0,0,5000,10000,0,1,0,0,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,8,'Zeno_Zoldycksq','614CAD4F3F8535D4C8C9A952F9808778C2EEB9014755371D98D82446915B055E5CB2451C996EDB51BA94C890F3BC5C28A7F4513874E8E51248BD36ECE7342014','2019-08-12 04:14:10','2019-08-12 11:41:38','127.0.0.1',0,1,18,3,1662.98,-1009.08,28.039,1660.56,-1014.98,23.61,187.948,0,0,2000,10000,0,1,0,12,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,389844,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,'No-one','None',1,-1,0,0,0,0,0,0,0,0,5,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,3000,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,2,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,9,'Guillem_Moskow','F21DE41B434CD564C0F3E6B7A48B4F48E90341AF3C9CBDCFC98843F9E5FC775CD01BA1428190E604588FC88958743795D7A7CD4ABF715C5E15AC59A782C53BA2','2019-08-12 11:41:53','2019-08-12 11:41:53','25.70.18.118',1,1,18,299,181.154,-1996.75,126.993,820.559,-1342.63,13.664,90,0,0,5000,10000,0,1,0,1,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,10,'Zou_louloulou','2F9959B230A44678DD2DC29F037BA1159F233AA9AB183CE3A0678EAAE002E5AA6F27F47144A1A4365116D3DB1B58EC47896623B92D85CB2F191705DAF11858B8','2019-08-12 14:38:04','2019-08-12 14:38:04','127.0.0.1',0,1,18,299,223.99,-1422.18,14.92,227.193,-1422.36,13.379,223.554,0,0,99895,10480,0,1,4,20,2,0,'None',0,97,0,0,0,1,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,4,-1,6,0,6,500,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,22,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,60245,65350,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,11,'Gui_Mo','F21DE41B434CD564C0F3E6B7A48B4F48E90341AF3C9CBDCFC98843F9E5FC775CD01BA1428190E604588FC88958743795D7A7CD4ABF715C5E15AC59A782C53BA2','2019-08-12 14:39:42','2019-08-12 14:39:42','25.70.18.118',0,1,18,299,1146.04,-1610.77,14.326,1142.85,-1609.36,13.953,358.782,0,0,5000,10000,0,1,0,1,0,0,'None',0,95,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,12,'Booda_Khaled','0E66A023B624963E119AE92C811A9CC39B6882F29D62ED9169AE90ADF8168E997D2357CF373E55FA892E8FAC132B4F107D628D0884022B2B36446CB12D3BE9A3','2019-08-12 18:50:21','2021-03-31 22:27:43','156.208.244.120',0,1,24,163,1300,-1380.49,15.452,1301.19,-1379.32,13.736,134.462,0,0,52165,52379,0,39,12,17,10,10,'Booda',7,100,100,0,0,0,0,50,0,0,0,1,0,0,0,0,0,0,4,0,'Arabic',3,810209,2,-1,1,0,1,0,8,8,8,0,0,0,1,1,10,1,1,0,0,1,0,0,1,2,0,0,0,16,0,0,4,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,2,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,-1,6,0,-1,500000,'Derek_Smith',0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,'No-one','None',1,-1,1,0,0,0,0,0,0,0,5,0,1,NULL,0,'Asst Management',-15658752,0,0,0,0,0,0,1,0,0,103279,57170,2,0,0,0,0,0,'None',0,0,0,1565666672,0,0,0,0,1,1,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,200,NULL,NULL,NULL,1,0,0,0,0,2,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,13,'Mike_d48','880DB386437B0EA253025F2BFC1D888555EC45BF240185AA11D81F8E21E7995FD2F615C8262ED0844730521E1B2622EDE9EEE7879D24B02649EF92E874FE8672','2021-03-29 19:18:14','2021-03-29 19:18:14','197.240.63.169',0,1,18,299,1065.33,-1612.72,17.72,1068.33,-1615.25,13.538,126.643,0,0,5000,10000,0,1,0,2,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,14,'Salvador_Tita','4E4D21366786E72A1C5E17A4C29B55AA1C0BEC1A93851BBDAE0F6FCF36A8C2515152853593BD6E59027A8017C5AEEF0C7CF21FEFA6E928B36C8BD189AD52DF8C','2021-03-29 19:19:13','2021-03-31 22:22:51','196.179.163.48',0,1,21,230,1222.92,-1418.78,17.237,1223.12,-1417.46,16.447,331.412,0,0,546407,104,0,2,202,44,9,10,'TiTa',0,100,25,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,11,-1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,1617474000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,-1,6,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,'Salvador_Tita','DM',0,-1,1,0,0,0,0,0,0,0,NULL,0,1,NULL,0,NULL,140800,0,0,0,0,0,0,1,0,0,17161502,16621143,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,-20,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,'2021-03-31 17:51:00','2021-03-31 13:09:00',0,0,0,0,0,0,0),(1,15,'Moez_Tofe7a','709AB2F9FF4C5A2F4872CBBF990B924799F8B0C34497046AA638C10A506ADC448FFFA4E2F6C85A80D01DED8097C29B1A2F25E9890F6758139C57237DEBE0187E','2021-03-29 20:32:31','2021-03-31 13:06:52','197.14.72.58',0,1,18,255,2473.95,-1671.06,13.639,2477.36,-1671.79,13.338,353.011,0,0,-782699388,10690,0,3,2,52,1,8,'MOEZ',0,226,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,3,1648731710,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,0,0,1,'Salvador_Tita','DM',1,-1,1,0,0,1,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,1838977776,2621682164,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,16,'Salvador_Yassine','4E4D21366786E72A1C5E17A4C29B55AA1C0BEC1A93851BBDAE0F6FCF36A8C2515152853593BD6E59027A8017C5AEEF0C7CF21FEFA6E928B36C8BD189AD52DF8C','2021-03-29 21:22:39','2021-03-29 21:22:39','196.179.163.48',0,1,21,7,1182.62,-1790.41,16.109,1185.47,-1791.01,13.57,359.683,0,0,5000,10000,0,1,0,2,0,0,'None',0,90,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,17,'Zven_Zengri','E830465529E569428D9A560AC067630438C8E590C8AA9BA342B71A56C5E24011C58228FE18E016C4F24B1E0B38D557CD581E41ABF48CA235658B97F06AFF13AD','2021-03-29 21:42:42','2021-03-29 21:42:42','197.0.25.133',0,1,18,178,1161.25,-1698.99,14.971,1162.32,-1702.06,14.172,198.025,0,0,5000,10000,0,1,0,3,0,0,'None',0,100,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,18,'anas_morello','A40E6165646BCE31F31E41FDB629650FAC77FA337019C8B5558044FD8F69697B48F79B4E7C61D657D922358962176275BA665D6CFBD7B32131A678726B2662A3','2021-03-30 00:41:15','2021-03-31 17:22:45','88.246.197.91',0,1,18,230,1235.69,-1301.14,15.164,1235.45,-1300.17,13.512,17.528,0,0,53520,10000,0,3,22,114,22,0,'None',0,40,100,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,995286,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,-1,6,0,0,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,2,0,0,0,0,0,0,0,0,NULL,1,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,50000,1480,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,1,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,19,'Abdu_Morello','4E0658D00F47D86D19A0E792E4BB94B16DB2E902D307DA5637F57CF60E7A174CB4BB6D7095621745B2065DF0C87B77AF69F5D0FBD63359AD3CC6B72F076C3E1E','2021-03-30 01:06:00','2021-03-30 01:06:00','81.213.243.205',0,1,18,299,1578.09,-1674.89,2112.14,1579.7,-1673.8,2110.54,54.396,2,5,4550,10000,0,1,0,25,0,0,'None',0,30,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,2,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,450,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,20,'Marcedes_BENZ','78888C5E83F51B2C6CA23A1D7D4C062F6177124E20F505813C0FCE133FA116401A75D98793393BE0248A4686A6F6B7F5F5F28CFA479B8038E19B6D5F7560E1BC','2021-03-31 06:14:56','2021-03-31 06:14:56','197.3.171.108',1,1,18,299,824.055,-1342.63,14.794,820.559,-1342.63,13.909,90,0,0,5000,10000,0,1,0,3,0,0,'None',0,125,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0),(1,21,'Wolverine_X','4C2AA672BD1253F2639AB9ACF4C5A14BB6D30A287CE8EC128433DA8B1E651D62684EE34E50A407337CF86BD0F14CE1C5712E3BEA35C231470C98E4B1ABFC1A0A','2021-03-31 11:26:10','2021-03-31 11:32:52','196.224.217.130',0,1,18,299,2159.68,942.727,10.774,2158.56,942.764,10.82,88.149,0,0,5000,10000,0,3,0,24,0,9,'None',0,216,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,4,0,'None',0,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,0,0,-1,0,'Nobody',0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'No-one','None',1,-1,0,0,0,0,0,0,0,0,NULL,0,0,NULL,0,NULL,-256,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,'None',0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,'',0,-1,0,0,-1,0,0,0,0,0,0,0,0,0,NULL,0,0,0,0,1,0,NULL,NULL,NULL,1,0,0,0,0,0,50,50,50,50,50,50,50,50,50,50,50,50,50,0,0,50,0,-1,0,0,NULL,NULL,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ownerid` int DEFAULT '0',
  `owner` varchar(24) DEFAULT 'Nobody',
  `modelid` smallint DEFAULT '0',
  `price` int DEFAULT '0',
  `tickets` int DEFAULT '0',
  `locked` tinyint(1) DEFAULT '0',
  `plate` varchar(32) DEFAULT 'None',
  `fuel` int DEFAULT '4500',
  `health` float DEFAULT '1000',
  `pos_x` float DEFAULT '0',
  `pos_y` float DEFAULT '0',
  `pos_z` float DEFAULT '0',
  `pos_a` float DEFAULT '0',
  `color1` smallint DEFAULT '0',
  `color2` smallint DEFAULT '0',
  `paintjob` tinyint DEFAULT '-1',
  `interior` tinyint DEFAULT '0',
  `world` int DEFAULT '0',
  `neon` smallint DEFAULT '0',
  `neonenabled` tinyint(1) DEFAULT '0',
  `trunk` tinyint(1) DEFAULT '0',
  `mod_1` smallint DEFAULT '0',
  `mod_2` smallint DEFAULT '0',
  `mod_3` smallint DEFAULT '0',
  `mod_4` smallint DEFAULT '0',
  `mod_5` smallint DEFAULT '0',
  `mod_6` smallint DEFAULT '0',
  `mod_7` smallint DEFAULT '0',
  `mod_8` smallint DEFAULT '0',
  `mod_9` smallint DEFAULT '0',
  `mod_10` smallint DEFAULT '0',
  `mod_11` smallint DEFAULT '0',
  `mod_12` smallint DEFAULT '0',
  `mod_13` smallint DEFAULT '0',
  `mod_14` smallint DEFAULT '0',
  `cash` int DEFAULT '0',
  `materials` int DEFAULT '0',
  `weed` int DEFAULT '0',
  `cocaine` int DEFAULT '0',
  `meth` int DEFAULT '0',
  `painkillers` int DEFAULT '0',
  `weapon_1` tinyint DEFAULT '0',
  `weapon_2` tinyint DEFAULT '0',
  `weapon_3` tinyint DEFAULT '0',
  `ammo_1` smallint DEFAULT '0',
  `ammo_2` smallint DEFAULT '0',
  `ammo_3` smallint DEFAULT '0',
  `gangid` tinyint DEFAULT '-1',
  `factiontype` tinyint DEFAULT '0',
  `type` int NOT NULL DEFAULT '0',
  `fgdivisionid` int NOT NULL DEFAULT '-1',
  `vippackage` tinyint NOT NULL DEFAULT '0',
  `job` tinyint DEFAULT '-1',
  `respawndelay` int DEFAULT '0',
  `pistolammo` smallint DEFAULT '0',
  `shotgunammo` smallint DEFAULT '0',
  `smgammo` smallint DEFAULT '0',
  `arammo` smallint DEFAULT '0',
  `rifleammo` smallint DEFAULT '0',
  `hpammo` smallint DEFAULT '0',
  `poisonammo` smallint DEFAULT '0',
  `fmjammo` smallint DEFAULT '0',
  `alarm` tinyint NOT NULL DEFAULT '0',
  `weapon_4` tinyint NOT NULL DEFAULT '0',
  `weapon_5` tinyint NOT NULL DEFAULT '0',
  `siren` tinyint DEFAULT '0',
  `rank` tinyint DEFAULT '0',
  `carImpounded` int DEFAULT '0',
  `carImpoundPrice` int DEFAULT '0',
  `forsaleprice` int NOT NULL DEFAULT '0',
  `forsale` int NOT NULL DEFAULT '0',
  `mileage` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,0,'Nobody',416,0,0,0,'EFJ 272',100,1000,1179.47,-1308.05,14.003,268.834,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(2,0,'Nobody',416,0,0,0,'CDQ 278',100,1000,1179.7,-1338.3,13.94,268.751,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(3,0,'Nobody',416,0,0,0,'LRU 243',100,1000,1147.29,-1313.08,13.82,359.776,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(4,0,'Nobody',416,0,0,0,'WRT 174',100,1000,1147.06,-1304.32,13.82,0.255,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(5,0,'Nobody',490,0,0,0,'IOP 577',100,1000,1146.94,-1295.16,13.78,0.301,1,3,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(6,0,'Nobody',407,0,0,0,'FDK 876',100,1000,1121.75,-1328.97,13.487,359.974,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(7,0,'Nobody',407,0,0,0,'LIR 441',100,1000,1126.47,-1329.03,13.487,358.567,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(8,0,'Nobody',407,0,0,0,'PJH 812',100,1000,1113.18,-1329.5,13.443,1.326,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(9,0,'Nobody',407,0,0,0,'KBC 965',100,1000,1108.46,-1329.65,13.427,359.682,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(10,0,'Nobody',407,0,0,0,'ADW 762',100,1000,1100.24,-1330.12,13.39,359.992,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(11,0,'Nobody',407,0,0,0,'TYL 946',100,1000,1095.44,-1330.32,13.374,358.425,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(12,0,'Nobody',445,0,0,0,'XPF 119',100,1000,1142.55,-1635.98,13.822,180.295,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(13,0,'Nobody',445,0,0,0,'MQS 769',100,1000,1059.37,-1610.99,13.522,126.661,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(14,0,'Nobody',445,0,0,0,'PAK 353',100,1000,1059.87,-1627.87,13.518,52.381,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(15,0,'Nobody',507,0,0,0,'DAH 174',100,1000,1054.49,-1627.57,13.45,31.857,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(16,0,'Nobody',507,0,0,0,'LBD 764',100,1000,1053.96,-1610.42,13.445,125.644,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(17,0,'Nobody',602,0,0,0,'EBP 790',100,1000,1049.27,-1610.28,13.389,127.103,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(18,0,'Nobody',602,0,0,0,'ILP 249',100,1000,1049.38,-1627.79,13.39,35.288,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(19,0,'Nobody',496,0,0,0,'DQM 370',100,1000,1660.58,-1015.38,23.614,189.096,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(20,0,'Nobody',463,0,0,0,'TNW 190',100,1000,1306.14,-866.206,39.118,270.238,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(21,0,'Nobody',426,0,0,0,'LGX 474',100,1000,1455.68,-1748.49,13.29,1.752,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(22,0,'Nobody',426,0,0,0,'VQT 882',100,1000,1491.64,-1748.56,13.29,358.785,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(23,0,'Nobody',426,0,0,0,'YFP 777',100,1000,1551.36,-1789.97,13.29,267.466,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(24,0,'Nobody',426,0,0,0,'FPL 743',100,1000,1551.38,-1795.08,13.29,271.339,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(25,0,'Nobody',426,0,0,0,'NSR 668',100,1000,1551.67,-1799.9,13.29,269.836,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(26,0,'Nobody',426,0,0,0,'OEE 557',100,1000,1407.17,-1778.83,13.289,90.014,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(27,0,'Nobody',426,0,0,0,'XEL 154',100,1000,1407.24,-1786.42,13.29,89.851,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(28,0,'Nobody',426,0,0,0,'TEG 232',100,1000,1407.52,-1793.36,13.29,89.052,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(29,0,'Nobody',426,0,0,0,'PPG 390',100,1000,1487.8,-1832.36,13.29,180.642,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(30,0,'Nobody',426,0,0,0,'OKC 240',100,1000,1471.81,-1832.38,13.317,178.554,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(31,0,'Nobody',525,0,0,0,'VFD 213',100,1000,1567.78,-1608.84,13.26,212.097,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(32,0,'Nobody',596,0,0,0,'JON 822',100,1000,1591.47,-1710.6,5.612,359.334,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(33,0,'Nobody',525,0,0,0,'LOX 771',100,1000,1571.83,-1608.47,13.262,211.918,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(34,0,'Nobody',596,0,0,0,'BKQ 956',100,1000,1587.5,-1710.61,5.612,359.262,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(35,0,'Nobody',525,0,0,0,'PAH 850',100,1000,1576.3,-1608.4,13.257,211.168,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(36,0,'Nobody',525,0,0,0,'OVX 258',100,1000,1580.5,-1608.34,13.26,211.87,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(37,0,'Nobody',596,0,0,0,'BNM 782',100,1000,1583.58,-1710.72,5.773,0.431,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(38,0,'Nobody',596,0,0,0,'CWE 102',100,1000,1602.73,-1605.01,13.212,88.541,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(39,0,'Nobody',596,0,0,0,'NRG 340',100,1000,1603.08,-1609.57,13.218,92.415,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(41,0,'Nobody',596,0,0,0,'FVX 160',100,1000,1602.88,-1613.34,13.217,89.09,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(42,0,'Nobody',596,0,0,0,'XMP 695',100,1000,1602.81,-1617.67,13.216,90.525,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(43,0,'Nobody',596,0,0,0,'HVL 767',100,1000,1602.76,-1622.25,13.215,90.531,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(44,0,'Nobody',596,0,0,0,'NHN 509',100,1000,1602.92,-1626.94,13.217,90.11,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(45,0,'Nobody',596,0,0,0,'FOS 203',100,1000,1603.53,-1631.02,13.23,90.858,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(46,0,'Nobody',525,0,0,0,'WDB 383',100,1000,1584.52,-1607.43,13.262,211.93,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(48,0,'Nobody',525,0,0,0,'WED 750',100,1000,1588.52,-1607.28,13.256,211.819,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(49,0,'Nobody',521,0,0,0,'HUJ 982',100,1000,1585.31,-1671.11,5.892,269.545,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(50,0,'Nobody',521,0,0,0,'MRP 289',100,1000,1585.05,-1668.48,5.893,269.545,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(51,0,'Nobody',416,0,0,0,'VVG 334',100,1000,2040.14,-1428.53,17.228,90.874,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(52,0,'Nobody',416,0,0,0,'KRD 883',100,1000,2039.8,-1423.58,17.23,91.938,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(53,0,'Nobody',554,0,0,0,'MXN 233',100,1000,1501.53,-1487.05,13.552,273.166,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(54,0,'Nobody',424,0,0,0,'XNH 207',100,1000,644.303,-1863.24,4.949,121.771,103,103,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(55,0,'Nobody',471,0,0,0,'WAJ 601',100,1000,645.962,-1866.13,4.469,122.599,6,3,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(56,0,'Nobody',453,0,0,0,'XKD 544',100,1000,738.474,-1496.18,-0.378,180.097,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(57,0,'Nobody',453,0,0,0,'CQL 699',100,1000,738.724,-1511.9,-0.394,178.428,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(58,0,'Nobody',453,0,0,0,'OQT 146',100,1000,737.587,-1527.05,-0.313,171.523,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(59,0,'Nobody',454,0,0,0,'NJN 610',100,1000,721.221,-1630.79,0.169,178.576,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(60,0,'Nobody',453,0,0,0,'CCQ 186',100,1000,718.142,-1495.32,-0.548,182.616,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(61,0,'Nobody',453,0,0,0,'DKX 616',100,1000,735.331,-1539.86,-0.06,169.157,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(62,0,'Nobody',452,0,0,0,'HKY 467',100,1000,715.126,-1671.34,-0.466,183.721,0,5,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(63,0,'Nobody',452,0,0,0,'TJB 464',100,1000,720.55,-1700.71,-0.438,179.202,0,103,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,2,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(64,0,'Nobody',493,0,0,0,'HMA 766',100,1000,1241.76,-2518.45,-0.109,193.599,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(65,0,'Nobody',455,0,0,0,'UVR 536',100,1000,2153.28,-2148.38,13.984,315.03,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(66,0,'Nobody',589,0,0,0,'JFI 905',100,1000,1947.45,-2120.84,13.205,89.929,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(67,0,'Nobody',463,0,0,0,'CAD 873',100,1000,1946.97,-2126.9,13.087,269.675,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(68,0,'Nobody',581,0,0,0,'NFA 242',100,1000,1938.15,-2141.36,13.159,180.65,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(69,0,'Nobody',439,0,0,0,'IVY 398',100,1000,1887.89,-2025.81,13.356,181.161,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(70,0,'Nobody',410,0,0,0,'KDX 438',100,1000,1866.45,-2030.5,13.206,270.26,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(71,0,'Nobody',522,0,0,0,'SNT 722',100,1000,1311.95,-1399.5,12.83,268.599,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(73,2,'Mike_Zodiac',522,0,0,0,'RFO 624',4500,1000,1232.86,-1298.96,13.092,269.996,0,0,-1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(74,0,'Nobody',428,0,0,0,'XNU 459',100,1000,580.185,-1309.97,14.01,277.128,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(75,0,'Nobody',582,0,0,0,'LJQ 992',100,1000,761.451,-1334.64,13.598,179.885,217,217,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(76,0,'Nobody',582,0,0,0,'SNG 862',100,1000,767.726,-1333.83,13.633,178.084,217,217,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(77,0,'Nobody',582,0,0,0,'KIN 648',100,1000,753.055,-1334.4,13.598,179.764,217,217,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(78,0,'Nobody',582,0,0,0,'KLT 192',100,1000,743.022,-1335.13,13.592,180.651,217,217,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(79,0,'Nobody',463,0,0,0,'OIU 330',100,1000,733.865,-1345.94,13.056,268.853,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(80,0,'Nobody',439,0,0,0,'NGK 378',100,1000,783.763,-1349.59,13.439,269.909,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(81,0,'Nobody',487,0,0,0,'ITP 207',100,1000,743.363,-1363.32,25.942,270.302,217,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(82,0,'Nobody',487,0,0,0,'PSI 438',100,1000,741.923,-1374.06,25.942,269.362,217,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,3,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(83,0,'Nobody',490,0,0,0,'THN 622',100,1000,306.168,-1482.32,24.721,232.091,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,1,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(84,0,'Nobody',451,0,0,0,'FTP 538',100,1000,285.39,-1527.56,24.3,235.147,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(85,0,'Nobody',552,0,0,0,'DUO 505',100,1000,806.904,-1439.7,13.149,196.929,217,217,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(86,0,'Nobody',411,0,0,0,'AGX 500',100,1000,288.354,-1522.46,24.306,237.298,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(87,0,'Nobody',490,0,0,0,'NBO 360',100,1000,303.418,-1486.15,24.729,233.119,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(88,0,'Nobody',490,0,0,0,'MNJ 569',100,1000,300.215,-1490.45,24.72,233.866,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(89,0,'Nobody',426,0,0,0,'PFE 882',100,1000,301.152,-1504.39,24.34,235.774,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(90,0,'Nobody',598,0,0,0,'EET 820',100,1000,297.741,-1509.09,24.341,231.864,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(91,0,'Nobody',451,0,0,0,'WFU 151',100,1000,290.621,-1517.76,24.323,238.395,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(92,0,'Nobody',598,0,0,0,'ODE 248',100,1000,294.11,-1513.56,24.342,235.919,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(93,0,'Nobody',487,0,0,0,'CPF 257',100,1000,300.781,-1534.13,76.716,246.267,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(94,0,'Nobody',487,0,0,0,'KNW 754',100,1000,306.474,-1523.55,76.701,232.133,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(95,0,'Nobody',487,0,0,0,'RTT 873',100,1000,313.925,-1511.05,76.712,229.627,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,6,0,-1,0,-1,3600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(96,2,'Mike_Zodiac',481,1000,0,0,'ORR 167',100,1000,1983.45,-2068.42,13.382,111.953,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(97,0,'Nobody',534,0,0,0,'RQX 570',100,1000,2291.42,-1682.71,13.66,2.175,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(98,0,'Nobody',463,0,0,0,'KWV 370',100,1000,2283.01,-1683.6,13.607,359.646,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(99,0,'Nobody',474,0,0,0,'JHU 112',100,1000,2327.89,-1677.57,14.154,269.229,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(100,0,'Nobody',587,0,0,0,'NBY 106',100,1000,2390.01,-1719.4,13.321,181.335,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(101,0,'Nobody',405,0,0,0,'LIA 829',100,1000,2473.48,-1693.95,13.39,1.234,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(102,0,'Nobody',481,0,0,0,'IPK 960',100,1000,2515.19,-1674.31,13.285,61.383,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(103,0,'Nobody',463,0,0,0,'MWP 235',100,1000,2391.53,-1490.63,23.369,270.583,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(104,0,'Nobody',400,0,0,0,'IIW 824',100,1000,2390.71,-1497.24,23.917,269.916,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(105,3,'Guillem_El_Chapo',522,400000,0,0,'LOE 339',100,1000,1973.52,-2060.89,13.387,89.947,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(106,0,'Nobody',522,0,0,0,'FDY 794',100,1000,1307.18,-11.453,1000.6,90.782,0,0,-1,18,3000107,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(107,14,'Salvador_Tita',541,0,0,0,'RRH 297',100,999.771,1225.87,-1836.3,13.633,324.196,1,1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2.238),(108,14,'Salvador_Tita',527,10000,0,0,'KYL 513',4499,1000,2123.56,-1131.5,25.435,344.586,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(109,0,'Nobody',522,0,0,0,'WFQ 967',100,1000,2325.1,-1252.78,22.071,261.441,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(110,0,'Nobody',426,0,0,0,'QOI 229',100,1000,1551.34,-1784.65,13.29,271.537,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(111,0,'Nobody',426,0,0,0,'ERN 518',100,1000,1551.53,-1774.84,13.291,269.571,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(112,0,'Nobody',426,0,0,0,'JKA 273',100,1000,1551.33,-1779.67,13.289,267.875,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,4,0,-1,0,-1,600,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(113,2,'Mike_Zodiac',527,10000,0,0,'AFM 743',100,935.016,2123.56,-1131.5,25.435,344.586,0,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,-1,0,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.515),(115,0,'Nobody',599,0,0,0,'TTG 410',4500,1000,1559.11,-1711.48,6.097,0.04,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(116,0,'Nobody',599,0,0,0,'WKH 593',4500,1000,1564.29,-1710.98,6.076,359.603,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0),(117,0,'Nobody',599,0,0,0,'GYW 232',4500,1000,1570.51,-1711.15,6.141,0.237,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(118,0,'Nobody',596,0,0,0,'SGS 945',4500,1000,1578.59,-1710.63,5.611,358.982,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(119,0,'Nobody',596,0,0,0,'PMR 767',4500,1000,1574.54,-1711.45,5.619,358.184,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(120,0,'Nobody',523,0,0,0,'PDG 704',4500,1000,1602.23,-1683.85,5.466,90.456,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(121,0,'Nobody',523,0,0,0,'XEJ 403',4500,1000,1601.73,-1687.99,5.459,87.949,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(122,0,'Nobody',523,0,0,0,'GLV 930',4500,1000,1601.9,-1692.23,5.459,87.949,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(123,0,'Nobody',523,0,0,0,'PWP 881',4500,1000,1601.89,-1696.03,5.464,87.949,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(124,0,'Nobody',523,0,0,0,'MOG 260',4500,1000,1602.96,-1700.23,5.462,90.456,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(125,0,'Nobody',523,0,0,0,'WUX 482',4500,1000,1602.8,-1704.37,5.459,90.456,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(126,0,'Nobody',596,0,0,0,'XBL 624',4500,1000,1595.3,-1710.84,5.634,359.508,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(127,0,'Nobody',490,0,0,0,'AQX 842',4500,1000,1526.63,-1644.05,6.019,180.931,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(128,0,'Nobody',490,0,0,0,'DXI 659',4500,1000,1530.4,-1644.2,6.019,181.999,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(129,0,'Nobody',601,0,0,0,'WPF 159',4500,1000,1534.47,-1645.06,5.723,178.926,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(130,0,'Nobody',601,0,0,0,'QEG 280',4500,1000,1538.85,-1644.83,5.649,179.3,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(131,0,'Nobody',427,0,0,0,'DNN 119',4500,1000,1545.66,-1651.13,6.024,91.355,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(132,0,'Nobody',427,0,0,0,'NBH 753',4500,1000,1545.25,-1655.08,5.985,92.83,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(133,0,'Nobody',427,0,0,0,'EBN 435',4500,1000,1545.31,-1659.06,5.988,92.83,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(134,0,'Nobody',427,0,0,0,'HEL 675',4500,1000,1545.81,-1663.04,6.02,91.582,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(135,0,'Nobody',560,0,0,0,'JGE 701',4500,1000,1546.03,-1668.12,5.596,90.062,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(136,0,'Nobody',560,0,0,0,'FKD 250',4500,1000,1546.19,-1672.08,5.596,91.185,7,7,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(137,0,'Nobody',560,0,0,0,'HVM 397',4500,1000,1546.1,-1676.39,5.596,91.133,4,4,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(138,0,'Nobody',560,0,0,0,'ECY 779',4500,1000,1546.02,-1680.44,5.596,90.839,8,8,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0),(139,0,'Nobody',560,0,0,0,'THV 965',4500,1000,1546.08,-1684.45,5.606,92.476,6,6,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,1,0,-1,0,-1,1000,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weapons`
--

DROP TABLE IF EXISTS `weapons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weapons` (
  `uid` int DEFAULT NULL,
  `slot` tinyint DEFAULT NULL,
  `weaponid` tinyint DEFAULT NULL,
  `ammo` smallint DEFAULT NULL,
  UNIQUE KEY `uid` (`uid`,`slot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weapons`
--

LOCK TABLES `weapons` WRITE;
/*!40000 ALTER TABLE `weapons` DISABLE KEYS */;
/*!40000 ALTER TABLE `weapons` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-31 22:57:18
