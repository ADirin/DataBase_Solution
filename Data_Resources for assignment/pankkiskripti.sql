-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.3.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table pankki2.asiakas
CREATE TABLE IF NOT EXISTS `asiakas` (
  `Asiakasnumero` int(11) NOT NULL,
  `Etunimi` varchar(40) DEFAULT NULL,
  `Sukunimi` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`Asiakasnumero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table pankki2.asiakas: ~5 rows (approximately)
/*!40000 ALTER TABLE `asiakas` DISABLE KEYS */;
INSERT INTO `asiakas` (`Asiakasnumero`, `Etunimi`, `Sukunimi`) VALUES
	(1, 'Viivi', 'Tervola'),
	(2, 'Bob', 'Smith'),
	(3, 'Ilmari', 'Kolehmainen'),
	(4, 'Gunilla', 'Jespersen'),
	(5, 'Taisto', 'Kukkonen');
/*!40000 ALTER TABLE `asiakas` ENABLE KEYS */;

-- Dumping structure for table pankki2.tili
CREATE TABLE IF NOT EXISTS `tili` (
  `Numero` int(11) NOT NULL,
  `Saldo` decimal(10,2) NOT NULL,
  `Haltija` int(11) NOT NULL,
  PRIMARY KEY (`Numero`),
  KEY `Haltija` (`Haltija`),
  CONSTRAINT `tili_ibfk_1` FOREIGN KEY (`Haltija`) REFERENCES `asiakas` (`Asiakasnumero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table pankki2.tili: ~7 rows (approximately)
/*!40000 ALTER TABLE `tili` DISABLE KEYS */;
INSERT INTO `tili` (`Numero`, `Saldo`, `Haltija`) VALUES
	(100, 1000.00, 1),
	(101, 2800.00, 2),
	(102, 1342.57, 2),
	(103, 760.00, 3),
	(104, -12.54, 4),
	(105, 138740.69, 2),
	(106, 224.75, 5);
/*!40000 ALTER TABLE `tili` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
