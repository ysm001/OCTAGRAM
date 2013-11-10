# ************************************************************
# Sequel Pro SQL dump
# バージョン 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# ホスト: 127.0.0.1 (MySQL 5.6.12)
# データベース: octagram
# 作成時刻: 2013-11-10 09:23:42 +0000
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
  `color` varchar(11) DEFAULT '#ffffff',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



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
  `tutorial_enabled` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
