# ************************************************************
# Sequel Pro SQL dump
# バージョン 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# ホスト: 127.0.0.1 (MySQL 5.6.12)
# データベース: octagram
# 作成時刻: 2013-11-09 04:13:17 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# テーブルのダンプ accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(32) NOT NULL DEFAULT '',
  `token` varchar(255) NOT NULL DEFAULT '',
  `uid` varchar(64) NOT NULL DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;

INSERT INTO `accounts` (`id`, `provider`, `token`, `uid`, `user_id`)
VALUES
	(12,'Google','ya29.AHES6ZSDD8htClSLqSvpAShBUw5n3bFF0FBaU3bR7hNfsL-xciq6vg','109869492828841211695',18),
	(13,'Google','ya29.AHES6ZQwK1n6BWAniNEgY9i9AceIWPSkKuXSOeoQmR0wNnSc610eMSs','102240562369513077819',19),
	(14,'Google','ya29.AHES6ZQwMfTtNzZR7zFm3ar721kjy8Tn2ownHHitf_LZiCis5q0lhA0','102240562369513077819',20),
	(15,'Google','ya29.AHES6ZTNdVyDDidQIyE83T0zf1eAjW4BAS4BFd0KfiyRDGesLnwoEvo','102240562369513077819',21),
	(16,'Google','ya29.AHES6ZQm9zGDc72gtxI9LxzrM-VqK2u1Td954hpw6LZmlZo6fO0jvO4','102240562369513077819',22),
	(17,'Google','ya29.AHES6ZSQQvMlTyCJe2UlVo7_KtEolfVnQJpkMKZW0OON1MFbfeL0woQ','102240562369513077819',23),
	(18,'Google','ya29.AHES6ZSinAZIMoGidTLAy6Cxp55j2_AJz1ZxHEqzmIUmQ8EgElvHliw','102240562369513077819',24),
	(19,'Google','ya29.AHES6ZTwtN_qyw26Ox_Tjn3uQ-fYCVV4Q6-E_MaxVmasCShztscOrDQ','102240562369513077819',25),
	(20,'Google','ya29.AHES6ZRsmf2UdVsdLX9eSRCRPoGjWpWm08qOUxZQSiIhYk9LC9_MUXo','102240562369513077819',26),
	(21,'Google','ya29.AHES6ZQ06nv6e6e3IZeOKrviqM_8g_Phaoe1THoTDs5fgfhu83B9mC4','102240562369513077819',27),
	(22,'Google','ya29.AHES6ZQ9U7FbO6N-7VIDV3QJxNS0koErar8AsBx7OUmWtNdN4QhF__g','102240562369513077819',28),
	(23,'Google','ya29.AHES6ZTwu-oEZA__jGqpKnKwQ4DcfxqBSQ-t4zmzLAAhIEJulmmFKTA','102240562369513077819',29),
	(24,'Google','ya29.AHES6ZQjea0zdNHmqrE-VC25kfZ7YWhfMo6N4aaW19BAPoA9LpL-80E','102240562369513077819',30),
	(25,'Google','ya29.AHES6ZRkmtHiF7QRlETMGTbpm4ZiNf71q4pFwPoxQ8ccMBj7Wfy25No','102240562369513077819',31),
	(26,'Google','ya29.AHES6ZQVVlLnTO6ePPUDayuXfuqP0AfuoCMuIq5FPyrSYimuR099Dbo','102240562369513077819',32),
	(27,'Google','ya29.AHES6ZRY_wss_tN57Io3onYbA95VNemMhCRdZtniTcGBPjaNcZDMkCA','102240562369513077819',33),
	(28,'Google','ya29.AHES6ZQIywGHo8lzOh46PvSHex51anJuYAmWIx3wBJQXicxjdcBpYzg','102240562369513077819',34),
	(29,'Google','ya29.AHES6ZQIywGHo8lzOh46PvSHex51anJuYAmWIx3wBJQXicxjdcBpYzg','102240562369513077819',35),
	(30,'Google','ya29.AHES6ZQIywGHo8lzOh46PvSHex51anJuYAmWIx3wBJQXicxjdcBpYzg','102240562369513077819',36),
	(31,'Google','ya29.AHES6ZQIywGHo8lzOh46PvSHex51anJuYAmWIx3wBJQXicxjdcBpYzg','102240562369513077819',37),
	(32,'Google','ya29.AHES6ZQIywGHo8lzOh46PvSHex51anJuYAmWIx3wBJQXicxjdcBpYzg','102240562369513077819',38),
	(33,'Google','ya29.AHES6ZQO32tYVMM53RnldkzHveuWAJaishoQQYA567kQi9we2NzrA2Q','102240562369513077819',39),
	(34,'Google','ya29.AHES6ZSsTwCJuCMwi5s6uJI6WilV6sUrjhw_kCZC6r6o9GI','102240562369513077819',40);

/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;


# テーブルのダンプ battle_log_associations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `battle_log_associations`;

CREATE TABLE `battle_log_associations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `challenger_log_id` int(11) unsigned NOT NULL,
  `defender_log_id` int(11) unsigned NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `battle_log_associations` WRITE;
/*!40000 ALTER TABLE `battle_log_associations` DISABLE KEYS */;

INSERT INTO `battle_log_associations` (`id`, `challenger_log_id`, `defender_log_id`, `created`, `modified`)
VALUES
	(157,316,317,'2013-11-08 04:26:43','2013-11-08 04:26:43'),
	(158,318,319,'2013-11-08 04:27:55','2013-11-08 04:27:55'),
	(159,320,321,'2013-11-08 04:28:00','2013-11-08 04:28:00'),
	(160,322,323,'2013-11-08 05:35:48','2013-11-08 05:35:48'),
	(161,324,325,'2013-11-08 05:35:55','2013-11-08 05:35:55'),
	(162,326,327,'2013-11-08 05:35:59','2013-11-08 05:35:59'),
	(163,328,329,'2013-11-08 05:36:02','2013-11-08 05:36:02'),
	(164,330,331,'2013-11-08 05:36:06','2013-11-08 05:36:06'),
	(165,332,333,'2013-11-08 05:36:13','2013-11-08 05:36:13'),
	(166,334,335,'2013-11-08 05:36:16','2013-11-08 05:36:16'),
	(198,398,399,'2013-11-09 02:04:58','2013-11-09 02:04:58'),
	(199,400,401,'2013-11-09 02:07:00','2013-11-09 02:07:00'),
	(200,402,403,'2013-11-09 02:19:24','2013-11-09 02:19:24'),
	(201,404,405,'2013-11-09 02:19:49','2013-11-09 02:19:49'),
	(202,406,407,'2013-11-09 02:21:36','2013-11-09 02:21:36'),
	(203,408,409,'2013-11-09 02:23:49','2013-11-09 02:23:49'),
	(204,410,411,'2013-11-09 02:30:36','2013-11-09 02:30:36'),
	(205,412,413,'2013-11-09 02:30:53','2013-11-09 02:30:53'),
	(206,414,415,'2013-11-09 02:33:13','2013-11-09 02:33:13'),
	(207,416,417,'2013-11-09 02:33:45','2013-11-09 02:33:45'),
	(208,418,419,'2013-11-09 02:35:04','2013-11-09 02:35:04'),
	(209,420,421,'2013-11-09 02:35:37','2013-11-09 02:35:37'),
	(210,422,423,'2013-11-09 02:35:46','2013-11-09 02:35:46');

/*!40000 ALTER TABLE `battle_log_associations` ENABLE KEYS */;
UNLOCK TABLES;


# テーブルのダンプ battle_logs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `battle_logs`;

CREATE TABLE `battle_logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `opponent_id` int(11) unsigned NOT NULL,
  `remaining_hp` int(11) unsigned NOT NULL,
  `consumed_energy` int(11) unsigned NOT NULL,
  `is_winner` int(11) unsigned NOT NULL,
  `program_id` int(11) unsigned DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `rate` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `battle_logs` WRITE;
/*!40000 ALTER TABLE `battle_logs` DISABLE KEYS */;

INSERT INTO `battle_logs` (`id`, `created`, `modified`, `opponent_id`, `remaining_hp`, `consumed_energy`, `is_winner`, `program_id`, `score`, `rate`)
VALUES
	(408,'2013-11-09 02:23:49','2013-11-09 02:23:49',74,6,340,1,53,77280,1500),
	(409,'2013-11-09 02:23:49','2013-11-09 02:23:49',53,0,0,0,74,10000,1500),
	(410,'2013-11-09 02:30:36','2013-11-09 02:30:36',74,6,340,1,53,77280,1516),
	(411,'2013-11-09 02:30:36','2013-11-09 02:30:36',53,0,0,0,74,10000,1484),
	(412,'2013-11-09 02:30:53','2013-11-09 02:30:53',74,6,340,1,53,77280,1530),
	(413,'2013-11-09 02:30:53','2013-11-09 02:30:53',53,0,0,0,74,10000,1470),
	(414,'2013-11-09 02:33:13','2013-11-09 02:33:13',74,6,340,1,53,77280,1543),
	(415,'2013-11-09 02:33:13','2013-11-09 02:33:13',53,0,0,0,74,10000,1457),
	(416,'2013-11-09 02:33:45','2013-11-09 02:33:45',74,6,340,1,53,77280,1555),
	(417,'2013-11-09 02:33:45','2013-11-09 02:33:45',53,0,0,0,74,10000,1445),
	(418,'2013-11-09 02:35:04','2013-11-09 02:35:04',74,6,340,1,53,77280,1566),
	(419,'2013-11-09 02:35:04','2013-11-09 02:35:04',53,0,0,0,74,10000,1434),
	(420,'2013-11-09 02:35:37','2013-11-09 02:35:37',74,6,340,1,53,77280,1576),
	(421,'2013-11-09 02:35:37','2013-11-09 02:35:37',53,0,0,0,74,10000,1424),
	(422,'2013-11-09 02:35:46','2013-11-09 02:35:46',74,6,340,1,53,77280,1585),
	(423,'2013-11-09 02:35:46','2013-11-09 02:35:46',53,0,0,0,74,10000,1415);

/*!40000 ALTER TABLE `battle_logs` ENABLE KEYS */;
UNLOCK TABLES;


# テーブルのダンプ programs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `programs`;

CREATE TABLE `programs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `comment` varchar(64) DEFAULT NULL,
  `data_url` varchar(255) NOT NULL DEFAULT '',
  `user_id` int(64) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `is_preset` tinyint(11) DEFAULT '0',
  `rate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;

INSERT INTO `programs` (`id`, `name`, `comment`, `data_url`, `user_id`, `created`, `modified`, `is_preset`, `rate`)
VALUES
	(52,'random_walk','','/OCTAGRAM/sample_service/app/webroot/files/programs/18/random_walk',18,'2013-11-06 17:55:04','2013-11-06 17:56:47',0,1500),
	(53,'kill','','/OCTAGRAM/sample_service/app/webroot/files/programs/18/kill',18,'2013-11-06 18:45:27','2013-11-06 18:49:11',0,1594),
	(54,'stay','','/OCTAGRAM/sample_service/app/webroot/files/programs/18/stay',18,'2013-11-06 18:49:38','2013-11-06 18:49:38',0,1500),
	(58,'search_and_destroy','','/OCTAGRAM/sample_service/app/webroot/files/programs/18/search_and_destroy',18,'2013-11-06 20:53:29','2013-11-06 20:53:29',0,1500),
	(59,'test','','/OCTAGRAM/sample_service/app/webroot/files/programs/18/test',18,'2013-11-08 07:50:12','2013-11-08 08:43:46',0,1500),
	(60,'stay','','/OCTAGRAM/sample_service/app/webroot/files/programs/21/stay',21,'2013-11-08 07:50:22','2013-11-08 07:50:22',0,1500),
	(72,'randomwalk',NULL,'/OCTAGRAM/sample_service/app/webroot/files/programs/40/randomwalk',40,'2013-11-08 09:31:01','2013-11-08 09:31:01',1,1500),
	(73,'test','','/OCTAGRAM/sample_service/app/webroot/files/programs/40/test',40,'2013-11-08 09:42:40','2013-11-08 09:42:40',0,1500),
	(74,'stay','','/OCTAGRAM/sample_service/app/webroot/files/programs/40/stay',40,'2013-11-09 02:19:07','2013-11-09 02:19:07',0,1406);

/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;


# テーブルのダンプ statistics
# ------------------------------------------------------------

DROP TABLE IF EXISTS `statistics`;

CREATE TABLE `statistics` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `score` int(11) unsigned NOT NULL DEFAULT '0',
  `combat_num` int(11) unsigned NOT NULL DEFAULT '0',
  `program_id` int(11) unsigned NOT NULL DEFAULT '0',
  `kill_num` int(11) unsigned NOT NULL DEFAULT '0',
  `total_damage` int(11) unsigned NOT NULL DEFAULT '0',
  `total_damaged` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `statistics` WRITE;
/*!40000 ALTER TABLE `statistics` DISABLE KEYS */;

INSERT INTO `statistics` (`id`, `score`, `combat_num`, `program_id`, `kill_num`, `total_damage`, `total_damaged`)
VALUES
	(4,0,0,52,0,0,0),
	(5,14,15,53,14,0,0),
	(6,8,15,54,8,0,0),
	(9,14,26,58,14,0,0);

/*!40000 ALTER TABLE `statistics` ENABLE KEYS */;
UNLOCK TABLES;


# テーブルのダンプ users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `role` varchar(24) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `nickname` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(64) DEFAULT NULL,
  `icon_url` varchar(256) DEFAULT NULL,
  `cc_name` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `username`, `password`, `role`, `created`, `modified`, `nickname`, `email`, `icon_url`, `cc_name`)
VALUES
	(18,'109869492828841211695','ya29.AHES6ZSDD8htClSLqSvpAShBUw5n3bFF0FBaU3bR7hNfsL-xciq6vg',NULL,'2013-11-05 13:42:13','2013-11-09 00:16:57','安田竜','ry.ysd01@gmail.com','http://www.gravatar.com/avatar/2f437339d839f57a5fbb45dede39489f?d=http%3A%2F%2Fwww.gravatar.com%2Favatar%2F00000000000000000000000000000000&s=200',''),
	(40,'102240562369513077819','ya29.AHES6ZSsTwCJuCMwi5s6uJI6WilV6sUrjhw_kCZC6r6o9GI',NULL,'2013-11-08 09:31:01','2013-11-09 02:37:59','山田太郎','ry.ysd03@gmail.com','http://www.gravatar.com/avatar/7e17865a63bcde781e4b37351a6a40e7?d=http%3A%2F%2Fwww.gravatar.com%2Favatar%2F00000000000000000000000000000000&s=200',NULL);

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
