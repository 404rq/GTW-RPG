-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 15, 2016 at 08:46 PM
-- Server version: 5.5.47-0+deb8u1
-- PHP Version: 5.6.19-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gtw`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `ID` int(11) NOT NULL,
  `account` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `business`
--

CREATE TABLE IF NOT EXISTS `business` (
`bID` int(11) NOT NULL,
  `bName` varchar(255) DEFAULT NULL,
  `bOwner` varchar(255) DEFAULT NULL,
  `bCost` int(11) DEFAULT NULL,
  `bPos` varchar(255) DEFAULT NULL,
  `bPayout` int(11) DEFAULT NULL,
  `bPayoutTime` int(11) DEFAULT NULL,
  `bPayoutOTime` int(11) DEFAULT NULL,
  `bPayoutUnit` varchar(255) DEFAULT NULL,
  `bPayoutCurTime` int(11) DEFAULT NULL,
  `bBank` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupLog`
--

CREATE TABLE IF NOT EXISTS `groupLog` (
  `name` varchar(255) DEFAULT NULL,
  `log` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupmember`
--

CREATE TABLE IF NOT EXISTS `groupmember` (
  `account` varchar(255) DEFAULT NULL,
  `groupName` varchar(255) DEFAULT NULL,
  `rank` varchar(255) DEFAULT NULL,
  `warningLvl` varchar(255) DEFAULT NULL,
  `joined` varchar(255) DEFAULT NULL,
  `lastTime` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groupRanks`
--

CREATE TABLE IF NOT EXISTS `groupRanks` (
  `groupName` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `permissions` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
  `name` varchar(255) DEFAULT NULL,
  `leader` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `chatcolor` varchar(255) DEFAULT NULL,
  `notecolor` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `turfcolor` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE IF NOT EXISTS `houses` (
`ID` int(10) NOT NULL,
  `X` double NOT NULL,
  `Y` double NOT NULL,
  `Z` double NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `INTX` double NOT NULL,
  `INTY` double NOT NULL,
  `INTZ` double NOT NULL,
  `MONEY` int(11) NOT NULL,
  `WEAP1` int(11) NOT NULL,
  `WEAP2` int(11) NOT NULL,
  `WEAP3` int(11) NOT NULL,
  `LOCKED` int(11) NOT NULL,
  `PRICE` int(11) NOT NULL,
  `OWNER` varchar(255) NOT NULL,
  `RENTABLE` int(11) NOT NULL,
  `RENTALPRICE` int(11) NOT NULL,
  `RENT1` varchar(255) NOT NULL,
  `RENT2` varchar(255) NOT NULL,
  `RENT3` varchar(255) NOT NULL,
  `RENT4` varchar(255) NOT NULL,
  `RENT5` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lastNick`
--

CREATE TABLE IF NOT EXISTS `lastNick` (
  `account` varchar(255) DEFAULT NULL,
  `nick` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `moneylog`
--

CREATE TABLE IF NOT EXISTS `moneylog` (
`ID` int(11) NOT NULL,
  `account` varchar(255) NOT NULL,
  `nick` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `date` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `police_chiefs`
--

CREATE TABLE IF NOT EXISTS `police_chiefs` (
  `ID` int(11) NOT NULL,
  `account` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `turfs`
--

CREATE TABLE IF NOT EXISTS `turfs` (
  `X` decimal(10,0) DEFAULT NULL,
  `Y` decimal(10,0) DEFAULT NULL,
  `Z` decimal(10,0) DEFAULT NULL,
  `sizeX` decimal(10,0) DEFAULT NULL,
  `sizeY` decimal(10,0) DEFAULT NULL,
  `red` decimal(10,0) DEFAULT NULL,
  `green` decimal(10,0) DEFAULT NULL,
  `blue` decimal(10,0) DEFAULT NULL,
  `owner` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `turfs`
--

INSERT INTO `turfs` (`X`, `Y`, `Z`, `sizeX`, `sizeY`, `red`, `green`, `blue`, `owner`) VALUES
(1951, -1743, 13, 40, 123, 255, 255, 255, ''),
(2011, -1743, 13, 60, 60, 0, 0, 0, ''),
(2010, -1664, 13, 60, 40, 0, 0, 0, ''),
(2126, -1743, 13, 60, 100, 0, 0, 0, ''),
(2051, -1603, 13, 100, 50, 0, 0, 0, ''),
(2225, -1723, 13, 140, 70, 73, 241, 97, ''),
(2227, -1826, 13, 140, 80, 0, 0, 0, ''),
(2373, -1725, 13, 180, 100, 0, 0, 0, ''),
(2423, -1823, 13, 130, 80, 0, 255, 255, ''),
(2422, -1924, 13, 86, 45, 0, 255, 255, ''),
(2422, -2041, 13, 110, 60, 0, 255, 255, ''),
(2624, -2038, 13, 90, 60, 0, 255, 255, ''),
(2723, -2040, 13, 80, 45, 0, 255, 255, ''),
(2723, -1986, 13, 90, 95, 0, 255, 255, ''),
(2439, -1565, 24, 70, 40, 0, 255, 255, ''),
(2461, -1434, 28, 55, 170, 0, 255, 255, ''),
(2521, -1436, 28, 40, 170, 0, 255, 255, ''),
(2379, -1248, 24, 60, 50, 0, 255, 255, ''),
(2460, -1248, 24, 110, 50, 0, 255, 255, ''),
(2579, -1248, 46, 60, 50, 0, 255, 255, ''),
(1874, -1127, 23, 85, 60, 0, 0, 0, ''),
(1979, -1128, 25, 80, 45, 0, 0, 0, ''),
(1860, -1453, 13, 100, 100, 0, 0, 0, ''),
(1576, 660, 10, 180, 120, 0, 255, 255, ''),
(1396, 661, 10, 160, 120, 0, 255, 255, ''),
(1825, 647, 10, 30, 100, 0, 255, 255, ''),
(1875, 641, 10, 120, 130, 0, 255, 255, ''),
(2000, 631, 10, 155, 35, 0, 255, 255, ''),
(1997, 683, 10, 155, 60, 0, 255, 255, ''),
(1999, 764, 10, 140, 35, 0, 255, 255, ''),
(2162, 642, 10, 130, 65, 0, 255, 255, ''),
(2302, 643, 10, 130, 60, 0, 255, 255, ''),
(2437, 647, 10, 30, 80, 0, 255, 255, ''),
(2437, 1382, 10, 110, 85, 0, 255, 255, ''),
(2616, 1961, 10, 50, 60, 0, 255, 255, ''),
(2551, 2039, 10, 65, 50, 0, 255, 255, ''),
(2537, 2122, 10, 80, 100, 0, 255, 255, ''),
(2631, 2199, 10, 70, 80, 0, 255, 255, ''),
(2804, 2121, 10, 60, 150, 0, 255, 255, ''),
(2803, 2024, 10, 35, 70, 0, 255, 255, ''),
(2238, 2724, 10, 160, 100, 0, 255, 255, ''),
(2187, 2783, 10, 50, 40, 0, 255, 255, ''),
(1778, 2563, 10, 130, 110, 0, 255, 255, ''),
(1017, 2302, 10, 100, 100, 0, 255, 255, ''),
(916, 2302, 10, 70, 70, 0, 255, 255, ''),
(916, 2203, 10, 85, 80, 0, 255, 255, ''),
(916, 1961, 10, 85, 200, 0, 255, 255, ''),
(917, 1862, 10, 85, 90, 170, 123, 49, ''),
(1016, 1961, 10, 95, 95, 0, 255, 255, ''),
(-2245, 576, 35, 88, 146, 0, 0, 0, ''),
(-2245, 739, 49, 88, 60, 0, 0, 0, ''),
(-2132, 575, 35, 45, 147, 0, 255, 255, ''),
(-2131, 741, 69, 115, 60, 0, 255, 255, ''),
(-2245, 816, 49, 90, 90, 0, 0, 0, ''),
(-2245, 927, 66, 89, 80, 0, 255, 255, ''),
(-2245, 1027, 83, 89, 65, 0, 255, 255, ''),
(-2376, 816, 35, 100, 135, 0, 255, 255, ''),
(-2376, 676, 35, 100, 125, 0, 0, 0, ''),
(-2376, 576, 24, 100, 85, 0, 0, 0, ''),
(-2130, 817, 69, 115, 100, 0, 255, 255, ''),
(-2245, 1102, 80, 90, 65, 0, 255, 255, ''),
(-2377, 966, 45, 65, 85, 0, 255, 255, ''),
(-2802, -204, 7, 85, 125, 0, 255, 255, ''),
(-2699, -203, 4, 90, 125, 0, 255, 255, ''),
(2219, -1967, 13, 100, 120, 0, 255, 255, ''),
(1967, -1927, 13, 100, 65, 189, 70, 150, ''),
(1826, -1928, 13, 120, 65, 0, 255, 255, ''),
(1827, -1849, 13, 120, 80, 73, 241, 97, ''),
(1089, -1134, 23, 75, 95, 0, 255, 255, ''),
(1172, -1134, 23, 90, 95, 255, 255, 255, ''),
(1171, -1032, 32, 90, 75, 0, 255, 255, ''),
(969, -1133, 23, 110, 95, 0, 255, 0, ''),
(1982, -1255, 23, 80, 110, 0, 0, 0, ''),
(2360, -1145, 27, 90, 30, 152, 110, 52, ''),
(2458, -1142, 35, 90, 40, 0, 255, 255, ''),
(2650, -1248, 50, 65, 45, 0, 255, 255, ''),
(2580, -1435, 34, 60, 90, 0, 255, 255, ''),
(2580, -1338, 38, 60, 70, 0, 255, 255, ''),
(2379, -1376, 24, 70, 110, 0, 255, 255, ''),
(-2080, 577, 35, 65, 140, 0, 255, 255, ''),
(-2132, 920, 79, 115, 120, 0, 255, 255, ''),
(-2519, 716, 27, 120, 80, 0, 255, 255, ''),
(-2519, 576, 14, 120, 120, 0, 0, 0, ''),
(-2800, -61, 7, 85, 100, 0, 255, 255, '');

-- --------------------------------------------------------

--
-- Table structure for table `turf_colors`
--

CREATE TABLE IF NOT EXISTS `turf_colors` (
  `group` varchar(255) NOT NULL,
  `red` int(11) NOT NULL,
  `green` int(11) NOT NULL,
  `blue` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
`ID` int(11) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `model` decimal(10,0) DEFAULT NULL,
  `locked` decimal(10,0) DEFAULT NULL,
  `engine` decimal(10,0) DEFAULT NULL,
  `health` decimal(10,0) DEFAULT NULL,
  `fuel` decimal(10,0) DEFAULT NULL,
  `paint` decimal(10,0) DEFAULT NULL,
  `pos` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `upgrades` varchar(255) DEFAULT NULL,
  `inventory` varchar(255) DEFAULT NULL,
  `headlight` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `business`
--
ALTER TABLE `business`
 ADD PRIMARY KEY (`bID`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `moneylog`
--
ALTER TABLE `moneylog`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `police_chiefs`
--
ALTER TABLE `police_chiefs`
 ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
 ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `business`
--
ALTER TABLE `business`
MODIFY `bID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `moneylog`
--
ALTER TABLE `moneylog`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
