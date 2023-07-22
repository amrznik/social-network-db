-------------------------------------------------------
--------- Design of a Social Network Database ---------
-------------------------------------------------------

-- Designed by Amir using MySQL

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-------------------------------------------------------
-- Schema socialnetwork
-------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `socialnetwork` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `socialnetwork` ;

-------------------------------------------------------
-- Table `socialnetwork`.`user`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`user` (
  `user_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `token` MEDIUMINT(5) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `name_first` VARCHAR(45) NOT NULL,
  `name_middle` VARCHAR(45) NULL,
  `name_last` VARCHAR(45) NOT NULL,
  `email_id` VARCHAR(100) NOT NULL,
  `picture` VARCHAR(255) NOT NULL DEFAULT '/web/image/default.jpg',
  `online` TINYINT(3) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`profile`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`profile` (
  `profile_id` BIGINT(8) NOT NULL AUTO_INCREMENT,
  `user_id` MEDIUMINT(8) NOT NULL,
  `privacy` TINYINT(3) NOT NULL DEFAULT 1,
  `about_me` VARCHAR(160) NULL,
  `relationship` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `interests` VARCHAR(255) NULL,
  `education` VARCHAR(255) NULL,
  `hobbies` VARCHAR(255) NULL,
  `fav_movies` VARCHAR(255) NULL,
  `fav_artists` VARCHAR(255) NULL,
  `fav_books` VARCHAR(255) NULL,
  `fav_animals` VARCHAR(255) NULL,
  `religion` TINYINT(3) NULL,
  `everything_else` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_receiver` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`profile_id`),
  INDEX `fk_profile_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`Follower`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`Follower` (
  `follower_id` MEDIUMINT(8) NOT NULL,
  `privacy` TINYINT(3) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` MEDIUMINT(8) NOT NULL,
  INDEX `fk_follower_user_idx` (`user_id` ASC),
  PRIMARY KEY (`follower_id`, `user_id`),
  CONSTRAINT `fk_follower_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`status`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`status` (
  `status_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `privacy` TINYINT(3) NOT NULL DEFAULT 0,
  `user_id` MEDIUMINT(8) NOT NULL,
  `depth` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `parent_id` MEDIUMINT(8) NOT NULL DEFAULT 0,
  INDEX `fk_status_user_idx` (`user_id` ASC),
  UNIQUE INDEX `status_id_UNIQUE` (`status_id` ASC),
  PRIMARY KEY (`status_id`),
  CONSTRAINT `fk_status_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`message`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`message` (
  `message_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(500) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `is_spam` TINYINT(1) NOT NULL DEFAULT 0,
  `is_reply` TINYINT(1) NULL DEFAULT 1,
  `user_id` MEDIUMINT(8) NOT NULL,
  `user_id1` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`message_id`),
  INDEX `fk_message_user_idx` (`user_id` ASC),
  INDEX `fk_message_user1_idx` (`user_id1` ASC),
  CONSTRAINT `fk_message_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`user_id1`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`thumb_up`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`thumb_up` (
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status_id` MEDIUMINT(8) NOT NULL,
  `user_id` MEDIUMINT(8) NOT NULL,
  INDEX `fk_thumb_up_status_idx` (`status_id` ASC),
  INDEX `fk_thumb_up_user_idx` (`user_id` ASC),
  PRIMARY KEY (`status_id`, `user_id`),
  CONSTRAINT `fk_thumb_up_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `socialnetwork`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thumb_up_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`notification`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`notification` (
  `notification_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(255) NOT NULL,
  `type` SMALLINT(5) NULL,
  `privacy` TINYINT(3) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`notification_id`),
  INDEX `fk_notification_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_notification_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`chat`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`chat` (
  `chat_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `user_id` MEDIUMINT(8) NOT NULL,
  `to` MEDIUMINT(8) NOT NULL,
  `message` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  INDEX `fk_chat_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_chat_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`privacy`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`privacy` (
  `privacy_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `profile` TINYINT(3) NOT NULL DEFAULT 1,
  `address` TINYINT(3) NOT NULL DEFAULT 2,
  `status` TINYINT(3) NOT NULL DEFAULT 1,
  `friend` TINYINT(3) NOT NULL DEFAULT 1,
  `user_id` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`privacy_id`),
  INDEX `fk_privacy_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_privacy_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`comment`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`comment` (
  `comment_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status_id` MEDIUMINT(8) NOT NULL,
  `user_id` MEDIUMINT(8) NOT NULL,
  `depth` MEDIUMINT(8) NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_id`),
  INDEX `fk_comment_status_idx` (`status_id` ASC),
  INDEX `fk_comment_user_idx` (`user_id` ASC),
  INDEX `fk_comment_comment_idx` (`comment_id` ASC),
  CONSTRAINT `fk_comment_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `socialnetwork`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_comment`
    FOREIGN KEY (`comment_id`)
    REFERENCES `socialnetwork`.`comment` (`comment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`tag`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`tag` (
  `tag_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `status_id` MEDIUMINT(8) NOT NULL,
  `tag_name` VARCHAR(45) NULL,
  PRIMARY KEY (`tag_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`status_has_tag`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`status_has_tag` (
  `tag_id` MEDIUMINT(8) NOT NULL,
  `status_id` MEDIUMINT(8) NOT NULL,
  INDEX `fk_status_has_tag_status_idx` (`status_id` ASC),
  INDEX `fk_status_has_tag_tag_idx` (`tag_id` ASC),
  PRIMARY KEY (`tag_id`, `status_id`),
  CONSTRAINT `fk_status_has_tag_tag`
    FOREIGN KEY (`tag_id`)
    REFERENCES `socialnetwork`.`tag` (`tag_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_status_has_tag_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `socialnetwork`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-------------------------------------------------------
-- Table `socialnetwork`.`role`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`role` (
  `role_id` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `role_name` VARCHAR(255) NOT NULL DEFAULT 'Normal',
  PRIMARY KEY (`role_id`))
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`user_has_role`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`user_has_role` (
  `user_id` MEDIUMINT(8) NOT NULL,
  `role_id` MEDIUMINT(8) NOT NULL,
  INDEX `fk_user_has_role_user_idx` (`user_id` ASC),
  INDEX `fk_user_has_role_role_idx` (`role_id` ASC),
  PRIMARY KEY (`role_id`, `user_id`),
  CONSTRAINT `fk_user_has_role_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_role_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `socialnetwork`.`role` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`permission`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`permission` (
  `permission_id` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `role_id` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `permission_access` VARCHAR(255) NULL,
  PRIMARY KEY (`permission_id`),
  INDEX `fk_permission_role_idx` (`role_id` ASC),
  CONSTRAINT `fk_permission_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `socialnetwork`.`role` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`Following`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`Following` (
  `following_id` MEDIUMINT(8) NOT NULL,
  `privacy` TINYINT(3) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`following_id`, `user_id`),
  INDEX `fk_following_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_following_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`thumb_up_comment`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`thumb_up_comment` (
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment_id` MEDIUMINT(8) NOT NULL,
  `user_id` MEDIUMINT(8) NOT NULL,
  INDEX `fk_thumb_up_comment_comment_idx` (`comment_id` ASC),
  INDEX `fk_thumb_up_comment_user_idx` (`user_id` ASC),
  PRIMARY KEY (`comment_id`, `user_id`),
  CONSTRAINT `fk_thumb_up_comment_comment`
    FOREIGN KEY (`comment_id`)
    REFERENCES `socialnetwork`.`comment` (`comment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thumb_up_comment_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`status_parent`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`status_parent` (
  `status_id` MEDIUMINT(8) NOT NULL,
  `status_parent_id` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`status_id`),
  INDEX `fk_status_parent_status2_idx` (`status_parent_id` ASC),
  CONSTRAINT `fk_status_parent_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `socialnetwork`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_status_parent_status2`
    FOREIGN KEY (`status_parent_id`)
    REFERENCES `socialnetwork`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-------------------------------------------------------
-- Table `socialnetwork`.`user_block`
-------------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`user_block` (
  `blocker_id` MEDIUMINT(8) NOT NULL,
  `blocking_id` MEDIUMINT(8) NOT NULL,
  PRIMARY KEY (`blocker_id`, `blocking_id`),
  INDEX `fk_user_block_user2_idx` (`blocking_id` ASC),
  CONSTRAINT `fk_user_block_user`
    FOREIGN KEY (`blocker_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_block_user2`
    FOREIGN KEY (`blocking_id`)
    REFERENCES `socialnetwork`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
