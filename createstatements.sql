CREATE TABLE `geoinformation` (
  `geoinformationID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(127) DEFAULT NULL,
  `shortinformation` varchar(1023) DEFAULT NULL,
  `detailinformation` varchar(4000) DEFAULT NULL,
  `comment` varchar(63) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `userID` smallint(6) DEFAULT NULL,
  `picture` int(11) DEFAULT NULL,
  PRIMARY KEY (`geoinformationID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `geoinformationForGeolocation` (
  `geoinformationID` int(11) NOT NULL,
  `geolocationID` int(11) NOT NULL,
  PRIMARY KEY (`geoinformationID`,`geolocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `geolocation` (
  `geolocationID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(127) DEFAULT NULL,
  `zip` varchar(15) DEFAULT NULL,
  `city` varchar(63) DEFAULT NULL,
  `country` varchar(63) DEFAULT NULL,
  `location` geometry DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `userID` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`geolocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;