-- Database: socialnetwork
-- With some additional tables
-- Designed by Amir using MySQL

------------------------------------------------------
-- Table structure for table `chat`

DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat` (
  `chat_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) NOT NULL,
  `to` mediumint(8) NOT NULL,
  `message` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  KEY `fk_chat_user_idx` (`user_id`),
  CONSTRAINT `fk_chat_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `chat` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `comment`

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `comment_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status_id` mediumint(8) NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  `depth` mediumint(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (`comment_id`),
  KEY `fk_comment_status_idx` (`status_id`),
  KEY `fk_comment_user_idx` (`user_id`),
  KEY `fk_comment_comment_idx` (`comment_id`),
  CONSTRAINT `fk_comment_comment` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`comment_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `comment` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `follower`

DROP TABLE IF EXISTS `follower`;
CREATE TABLE `follower` (
  `follower_id` mediumint(8) NOT NULL,
  `privacy` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`follower_id`,`user_id`),
  KEY `fk_follower_user_idx` (`user_id`),
  CONSTRAINT `fk_follower_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `follower` WRITE;
INSERT INTO `follower` VALUES (1,0,'2015-06-27 17:39:40',2),(3,0,'2015-06-27 17:39:40',2),(6,0,'2015-06-27 18:55:07',2);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `following`

DROP TABLE IF EXISTS `following`;
CREATE TABLE `following` (
  `following_id` mediumint(8) NOT NULL,
  `privacy` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`following_id`,`user_id`),
  KEY `fk_following_user_idx` (`user_id`),
  CONSTRAINT `fk_following_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `following` WRITE;
INSERT INTO `following` VALUES (1,0,'2015-06-27 17:39:40',2),(2,0,'2015-06-27 21:30:09',1),(3,0,'2015-06-27 17:39:40',2),(6,0,'2015-06-27 18:56:12',2),(7,0,'2015-06-27 18:56:12',2);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `message`

DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `message_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `message` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `is_spam` tinyint(1) NOT NULL DEFAULT '0',
  `is_reply` tinyint(1) DEFAULT '1',
  `user_id` mediumint(8) NOT NULL,
  `user_id1` mediumint(8) NOT NULL,
  PRIMARY KEY (`message_id`),
  KEY `fk_message_user_idx` (`user_id`),
  KEY `fk_message_user1_idx` (`user_id1`),
  CONSTRAINT `fk_message_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_user1` FOREIGN KEY (`user_id1`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

LOCK TABLES `message` WRITE;
INSERT INTO `message` VALUES (1,'This is a message','2015-06-28 11:31:07',0,0,1,1,2);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `notification`

DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `notification_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `type` smallint(5) DEFAULT NULL,
  `privacy` tinyint(3) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_user_idx` (`user_id`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `notification` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `permission`

DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `permission_id` mediumint(8) NOT NULL DEFAULT '0',
  `role_id` mediumint(8) NOT NULL DEFAULT '0',
  `permission_access` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`permission_id`),
  KEY `fk_permission_role_idx` (`role_id`),
  CONSTRAINT `fk_permission_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `permission` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `privacy`

DROP TABLE IF EXISTS `privacy`;
CREATE TABLE `privacy` (
  `privacy_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `profile` tinyint(3) NOT NULL DEFAULT '1',
  `address` tinyint(3) NOT NULL DEFAULT '2',
  `status` tinyint(3) NOT NULL DEFAULT '1',
  `friend` tinyint(3) NOT NULL DEFAULT '1',
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`privacy_id`),
  KEY `fk_privacy_user_idx` (`user_id`),
  CONSTRAINT `fk_privacy_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `privacy` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `profile`

DROP TABLE IF EXISTS `profile`;
CREATE TABLE `profile` (
  `profile_id` bigint(8) NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) NOT NULL,
  `privacy` tinyint(3) NOT NULL DEFAULT '1',
  `about_me` varchar(160) DEFAULT NULL,
  `relationship` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `interests` varchar(255) DEFAULT NULL,
  `education` varchar(255) DEFAULT NULL,
  `hobbies` varchar(255) DEFAULT NULL,
  `fav_movies` varchar(255) DEFAULT NULL,
  `fav_artists` varchar(255) DEFAULT NULL,
  `fav_books` varchar(255) DEFAULT NULL,
  `fav_animals` varchar(255) DEFAULT NULL,
  `religion` tinyint(3) DEFAULT NULL,
  `everything_else` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_receiver` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`profile_id`),
  KEY `fk_profile_user_idx` (`user_id`),
  CONSTRAINT `fk_profile_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `profile` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `role`

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_id` mediumint(8) NOT NULL DEFAULT '0',
  `role_name` varchar(255) NOT NULL DEFAULT 'Normal',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `role` WRITE;
INSERT INTO `role` VALUES (0,'Normal'),(1,'Editor'),(2,'Analyser');
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `status`

DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `status_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `message` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `privacy` tinyint(3) NOT NULL DEFAULT '0',
  `user_id` mediumint(8) NOT NULL,
  `depth` mediumint(8) NOT NULL DEFAULT '0',
  `parent_id` mediumint(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (`status_id`),
  UNIQUE KEY `status_id_UNIQUE` (`status_id`),
  KEY `fk_status_user_idx` (`user_id`),
  CONSTRAINT `fk_status_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

LOCK TABLES `status` WRITE;
INSERT INTO `status` VALUES (4,'This is a test','2015-06-27 15:44:19',0,1,0,0),(5,'Hi, how are you?','2015-06-27 21:15:15',0,2,1,4),(6,'SQL Queries','2015-06-27 21:15:15',0,2,0,0),(8,'Query 18','2015-06-28 13:49:59',0,1,2,5),(9,'Query 18_2','2015-06-28 15:35:48',0,3,3,8),(10,'post1','2015-06-28 19:17:32',0,6,0,0),(11,'post2','2015-06-28 19:51:06',0,6,0,0),(12,'post3','2015-06-28 19:51:11',0,6,0,0),(13,'post4','2015-06-28 19:51:15',0,6,0,0),(14,'post5','2015-06-28 19:51:24',0,6,0,0),(16,'topStatus','2015-06-29 10:53:23',0,1,0,0);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `status_has_tag`

DROP TABLE IF EXISTS `status_has_tag`;
CREATE TABLE `status_has_tag` (
  `tag_id` mediumint(8) NOT NULL,
  `status_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`tag_id`,`status_id`),
  KEY `fk_status_has_tag_status_idx` (`status_id`),
  KEY `fk_status_has_tag_tag_idx` (`tag_id`),
  CONSTRAINT `fk_status_has_tag_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_status_has_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `status_has_tag` WRITE;
INSERT INTO `status_has_tag` VALUES (11,4),(12,4),(16,6);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `status_parent`

DROP TABLE IF EXISTS `status_parent`;
CREATE TABLE `status_parent` (
  `status_id` mediumint(8) NOT NULL,
  `status_parent_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`status_id`),
  KEY `fk_status_parent_status2_idx` (`status_parent_id`),
  CONSTRAINT `fk_status_parent_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_status_parent_status2` FOREIGN KEY (`status_parent_id`) REFERENCES `status` (`status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `status_parent` WRITE;
INSERT INTO `status_parent` VALUES (5,4),(8,5),(9,8),(16,16);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `tag`

DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `tag_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `status_id` mediumint(8) NOT NULL,
  `tag_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

LOCK TABLES `tag` WRITE;
INSERT INTO `tag` VALUES (11,4,'#Test'),(12,4,'#Test_Message'),(14,8,'#Q18'),(15,9,'#Q18_2'),(16,6,'#Test');
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `thumb_up`

DROP TABLE IF EXISTS `thumb_up`;
CREATE TABLE `thumb_up` (
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status_id` mediumint(8) NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`status_id`,`user_id`),
  KEY `fk_thumb_up_status_idx` (`status_id`),
  KEY `fk_thumb_up_user_idx` (`user_id`),
  CONSTRAINT `fk_thumb_up_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_thumb_up_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `thumb_up` WRITE;
INSERT INTO `thumb_up` VALUES ('2015-06-28 21:06:34',4,2),('2015-06-28 21:06:34',4,3),('2015-06-28 21:06:34',4,6),('2015-06-28 21:01:58',6,1),('2015-06-28 21:01:58',6,2),('2015-06-28 21:01:58',6,3),('2015-06-28 21:01:58',6,6),('2015-06-29 16:00:47',9,7);
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `thumb_up_comment`

DROP TABLE IF EXISTS `thumb_up_comment`;
CREATE TABLE `thumb_up_comment` (
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment_id` mediumint(8) NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`comment_id`,`user_id`),
  KEY `fk_thumb_up_comment_comment_idx` (`comment_id`),
  KEY `fk_thumb_up_comment_user_idx` (`user_id`),
  CONSTRAINT `fk_thumb_up_comment_comment` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`comment_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_thumb_up_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `thumb_up_comment` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `user`

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `token` mediumint(5) NOT NULL,
  `username` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `name_first` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `name_middle` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_last` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `email_id` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `picture` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '/web/image/default.jpg',
  `online` tinyint(3) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `user` WRITE;
INSERT INTO `user` VALUES (1,1,'David','12345678','David',' ','Foo','David_Foo@yahoo.com','9',1,'2015-06-24 22:57:35'),(2,1,'Alex','12345678','Alex',' ','Bar','Alex_Bar@yahoo.com','9',1,'2015-06-24 22:58:37'),(3,1,'Luis','99999999','Lio',' ','Luis','Lio_Luis@yahoo.com','9',1,'2015-06-27 12:20:01'),(6,1,'Bob','12345678','Bob',' ','Baz','Bob_Baz@yahoo.com','9',1,'2015-06-27 18:53:14'),(7,1,'Alice','12345678','Alice',' ','Baz','Alice_Baz@yahoo.com','9',1,'2015-06-27 18:53:43');
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `user_block`

DROP TABLE IF EXISTS `user_block`;
CREATE TABLE `user_block` (
  `blocker_id` mediumint(8) NOT NULL,
  `blocking_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`blocker_id`,`blocking_id`),
  KEY `fk_user_block_user2_idx` (`blocking_id`),
  CONSTRAINT `fk_user_block_user` FOREIGN KEY (`blocker_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_block_user2` FOREIGN KEY (`blocking_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_block` WRITE;
UNLOCK TABLES;

------------------------------------------------------
-- Table structure for table `user_has_role`

DROP TABLE IF EXISTS `user_has_role`;
CREATE TABLE `user_has_role` (
  `user_id` mediumint(8) NOT NULL,
  `role_id` mediumint(8) NOT NULL,
  PRIMARY KEY (`role_id`,`user_id`),
  KEY `fk_user_has_role_user_idx` (`user_id`),
  KEY `fk_user_has_role_role_idx` (`role_id`),
  CONSTRAINT `fk_user_has_role_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_role_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_has_role` WRITE;
INSERT INTO `user_has_role` VALUES (2,1),(6,1);
UNLOCK TABLES;