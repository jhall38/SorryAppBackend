-- MySQL dump 10.13  Distrib 5.5.50, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: SorryDatabase
-- ------------------------------------------------------
-- Server version	5.5.50-0ubuntu0.14.04.1

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
-- Current Database: `SorryDatabase`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `SorryDatabase` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `SorryDatabase`;

--
-- Table structure for table `tblPerson`
--

DROP TABLE IF EXISTS `tblPerson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblPerson` (
  `PersonID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  PRIMARY KEY (`PersonID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecord`
--

DROP TABLE IF EXISTS `tblRecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecord` (
  `RecordID` int(11) NOT NULL AUTO_INCREMENT,
  `RecordTime` datetime DEFAULT NULL,
  `PersonID` int(11) DEFAULT NULL,
  `RecordTypeID` int(11) DEFAULT NULL,
  PRIMARY KEY (`RecordID`),
  KEY `PersonID` (`PersonID`),
  KEY `RecordTypeID` (`RecordTypeID`),
  CONSTRAINT `tblrecord_ibfk_1` FOREIGN KEY (`PersonID`) REFERENCES `tblPerson` (`PersonID`),
  CONSTRAINT `tblrecord_ibfk_2` FOREIGN KEY (`RecordTypeID`) REFERENCES `tblRecordType` (`RecordTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=2428 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblRecordType`
--

DROP TABLE IF EXISTS `tblRecordType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblRecordType` (
  `RecordTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `RecordTypeName` varchar(50) DEFAULT NULL,
  `RecordTypeDescription` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`RecordTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'SorryDatabase'
--
/*!50003 DROP FUNCTION IF EXISTS `addNewPerson` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` FUNCTION `addNewPerson`(
  _Email VARCHAR(50),
  _FirstName VARCHAR(50),
  _LastName VARCHAR(50),
  _Gender VARCHAR(50)
) RETURNS int(11)
BEGIN
  
  IF EXISTS(
      SELECT * FROM tblPerson
      WHERE Email = _Email
  )
  THEN
      RETURN 0;
  END IF;

  
  INSERT INTO tblPerson(Email, FirstName, LastName, Gender)
  VALUES (_Email, _FirstName, _LastName, _Gender);
  RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `addNewRecordNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` FUNCTION `addNewRecordNotSorry`(
  _Email VARCHAR(50),
  _RecordTime DATETIME
) RETURNS int(11)
BEGIN
  DECLARE _PersonID INT;
  DECLARE _RecordTypeID INT;

  SELECT PersonID INTO _PersonID FROM tblPerson WHERE Email = _Email;


  SELECT RecordTypeID INTO _RecordTypeID FROM tblRecordType WHERE RecordTypeName = 'NotSorry';

  IF _PersonID IS NULL OR _RecordTypeID IS NULL
    THEN
    RETURN 0;
  END IF;

  INSERT INTO tblRecord(RecordTime, PersonID, RecordTypeID)
  VALUES( _RecordTime, _PersonID, _RecordTypeID);
  RETURN 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `addNewRecordSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` FUNCTION `addNewRecordSorry`(
  _Email VARCHAR(50),
  _RecordTime DATETIME
) RETURNS int(11)
BEGIN
  DECLARE _PersonID INT;
  DECLARE _RecordTypeID INT;

  SELECT PersonID INTO _PersonID FROM tblPerson WHERE Email = _Email;


  SELECT RecordTypeID INTO _RecordTypeID FROM tblRecordType WHERE RecordTypeName = 'Sorry';

  IF _PersonID IS NULL OR _RecordTypeID IS NULL
    THEN
    RETURN 0;
  END IF;

  INSERT INTO tblRecord(RecordTime, PersonID, RecordTypeID)
  VALUES( _RecordTime, _PersonID, _RecordTypeID);
  RETURN 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `countTodayRecordNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` FUNCTION `countTodayRecordNotSorry`(
_Email VARCHAR(50),
_today DATE
) RETURNS int(11)
BEGIN
  DECLARE _ret INT;

  SELECT COUNT(*)
  INTO _ret
  FROM tblRecord R
  JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
  JOIN tblPerson P ON P.PersonID = R.PersonID
  WHERE RT.RecordTypeName = 'NotSorry'
  AND P.Email = _Email
  AND YEAR(_today) = YEAR(R.RecordTime)
  AND MONTH(_today) = MONTH(R.RecordTime)
  AND DAY(_today) = DAY(R.RecordTime);

  RETURN _ret;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `countTodayRecordSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` FUNCTION `countTodayRecordSorry`(
_Email VARCHAR(50),
_today DATE
) RETURNS int(11)
BEGIN
  DECLARE _ret INT;

  SELECT COUNT(*)
  INTO _ret
  FROM tblRecord R
  JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
  JOIN tblPerson P ON P.PersonID = R.PersonID
  WHERE RT.RecordTypeName = 'Sorry'
  AND P.Email = _Email
  AND YEAR(_today) = YEAR(R.RecordTime)
  AND MONTH(_today) = MONTH(R.RecordTime)
  AND DAY(_today) = DAY(R.RecordTime);

  RETURN _ret;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addNewPerson` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `addNewPerson`(
IN _Email VARCHAR(50),
IN _FirstName VARCHAR(50),
IN _LastName VARCHAR(50),
IN _Gender VARCHAR(50),
OUT _Ret INT)
BEGIN
  
  IF EXISTS(
      SELECT * FROM tblPerson
      WHERE Email = _Email
      AND FirstName = _FirstName
      AND LastName = _LastName
      AND Gender = _Gender
  )
  THEN
      SET _Ret = 0;
  ELSE
  INSERT INTO tblPerson(Email, FirstName, LastName, Gender)
  VALUES (_Email, _FirstName, _LastName, _Gender);
  SET _Ret = 1;
  END IF;
  SELECT _Ret;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countLeaderNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countLeaderNotSorry`()
BEGIN

SELECT P.FirstName, P.LastName, COUNT(RecordID) as Score
FROM tblRecord R
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
JOIN tblPerson P on R.PersonID = P.PersonID
WHERE RT.RecordTypeName = 'NotSorry'
GROUP BY P.Email, P.FirstName, P.LastName
ORDER BY Score DESC
LIMIT 10;


    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countLeaderSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countLeaderSorry`()
BEGIN

    SELECT P.FirstName, P.LastName, COUNT(RecordID) as Score
    FROM tblRecord R
    JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
    JOIN tblPerson P on R.PersonID = P.PersonID
    WHERE RT.RecordTypeName = 'Sorry'
    GROUP BY P.Email, P.FirstName, P.LastName
    ORDER BY Score DESC
    LIMIT 10;

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countMonthNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countMonthNotSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, DATE(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(DATE(_Today), INTERVAL 31 DAY)
AND DATE(R.RecordTime) <= DATE(_Today)
AND P.Email = _Email
AND RT.RecordTypeName = 'NotSorry'
GROUP BY DATE(R.RecordTime), P.FirstName, P.LastName
ORDER BY DATE(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countMonthSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countMonthSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, DATE(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(DATE(_Today), INTERVAL 31 DAY)
AND DATE(R.RecordTime) <= DATE(_Today)
AND P.Email = _Email
AND RT.RecordTypeName = 'Sorry'
GROUP BY DATE(R.RecordTime), P.FirstName, P.LastName
ORDER BY DATE(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countWeekNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countWeekNotSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, DATE(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(DATE(_Today), INTERVAL 7 DAY)
AND P.Email = _Email
AND RT.RecordTypeName = 'NotSorry'
GROUP BY DATE(R.RecordTime), P.FirstName, P.LastName
ORDER BY DATE(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countWeekSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countWeekSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, DATE(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(_Today, INTERVAL 7 DAY)
AND DATE(R.RecordTime) <= DATE(_Today)
AND P.Email = _Email
AND RT.RecordTypeName = 'Sorry'
GROUP BY DATE(R.RecordTime), P.FirstName, P.LastName
ORDER BY DATE(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countYearNotSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countYearNotSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, MONTH(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(DATE(_Today), INTERVAL 365 DAY)
AND DATE(R.RecordTime) <= _Today
AND P.Email = _Email
AND RT.RecordTypeName = 'NotSorry'
GROUP BY MONTH(R.RecordTime), P.FirstName, P.LastName
ORDER BY MONTH(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countYearSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `countYearSorry`(
IN _Email VARCHAR(50),
IN _Today DATETIME
)
BEGIN
SELECT P.FirstName, P.LastName, MONTH(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) >= DATE_SUB(_Today, INTERVAL 365 DAY)
AND DATE(R.RecordTime) <= _Today
AND P.Email = _Email
AND RT.RecordTypeName = 'Sorry'
GROUP BY MONTH(R.RecordTime), P.FirstName, P.LastName
ORDER BY MONTH(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertRecord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `InsertRecord`(
IN _PersonID INT,
IN _RecordTime DATETIME,
IN _RecordTypeName VARCHAR(50)
)
BEGIN
DECLARE _RecordTypeID INT;
SELECT _RecordTypeID;

SELECT RecordTypeID
INTO _RecordTypeID
FROM RecordType
WHERE RecordTypeName = _RecordTypeName;

START TRANSACTION;
INSERT INTO Record(RecordTypeID, PersonID, RecordTime)
VALUES (_RecordTypeID, _PersonID, _RecordTime);
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tmpCountMonthSorry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `tmpCountMonthSorry`(
IN _Email VARCHAR(50)
)
BEGIN
SELECT P.FirstName, P.LastName, DATE(R.RecordTime) AS Date, COUNT(R.RecordID) AS SCORE
FROM tblRecord R
JOIN tblPerson P ON P.PersonID = R.PersonID
JOIN tblRecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE DATE(R.RecordTime) > DATE_SUB(now(), INTERVAL 31 DAY)
AND P.Email = _Email
AND RT.RecordTypeName = 'Sorry'
GROUP BY DATE(R.RecordTime), P.FirstName, P.LastName
ORDER BY DATE(R.RecordTime);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `uspCountRecord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `uspCountRecord`(




IN _PersonID INT,
IN _RcordTypeName VARCHAR(50),
IN _TimeRange TIME,
OUT _CountRecord INT
)
BEGIN

SELECT COUNT(*)
INTO _CountRecord
FROM Record R 
JOIN RecordType RT ON R.RecordTypeID = RT.RecordTypeID
WHERE PersonID = _PersonID
AND RecordTypeName = _RecordTypeName
AND R.RecordTime > (NOW() - _TimeRange);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `uspInsertPerson` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`Matt`@`localhost` PROCEDURE `uspInsertPerson`(
IN _FirstName VARCHAR(50),
IN _LastName VARCHAR(50),
IN _Email VARCHAR(50),
IN _Gender VARCHAR(50),
IN _DOB DATE,
OUT _PersonID INT
)
BEGIN
  START TRANSACTION;

INSERT INTO tblPerson(Email, Gender, FirstName, LastName, DOB)
SELECT * FROM (SELECT _Email, _Gender, _FirstName, _LastName, _DOB) AS TMP
WHERE NOT EXISTS(SELECT * FROM tblPerson
	WHERE Email = _Email
	AND Gender = _Gender
	AND FirstName = _FirstName
	AND LastName = _LastName
	AND DOB = _DOB) LIMIT 1;

	SELECT PersonID
  INTO _PersonID
	FROM tblPerson
	WHERE Email = _Email
	AND Gender = _Gender
	AND FirstName = _FirstName
	AND LastName = _LastName
	AND DOB = _DOB;

COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-30  6:00:41
