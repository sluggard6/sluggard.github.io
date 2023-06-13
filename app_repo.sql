-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema app_repo
-- -----------------------------------------------------
-- 应用仓库数据库

-- -----------------------------------------------------
-- Schema app_repo
--
-- 应用仓库数据库
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `app_repo` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `app_repo` ;

-- -----------------------------------------------------
-- Table `app_repo`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`user` (
  `id` BIGINT NOT NULL,
  `username` VARCHAR(16) NOT NULL COMMENT '用户名称',
  `email` VARCHAR(255) NULL COMMENT '邮箱地址',
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`))
COMMENT = '用户表';


-- -----------------------------------------------------
-- Table `app_repo`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`account` (
  `id` BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  `account` VARCHAR(45) NOT NULL COMMENT '登录账号',
  `password` VARCHAR(64) NOT NULL COMMENT '登录密码',
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_fk_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `account_user_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `app_repo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '用户账户表';


-- -----------------------------------------------------
-- Table `app_repo`.`permission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`permission` (
  `id` BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  `name` VARCHAR(45) NOT NULL COMMENT '权限名称',
  PRIMARY KEY (`id`))
COMMENT = '权限表';


-- -----------------------------------------------------
-- Table `app_repo`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`role` (
  `id` BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  `name` VARCHAR(45) NULL COMMENT '角色名称',
  PRIMARY KEY (`id`))
COMMENT = '用户角色表';


-- -----------------------------------------------------
-- Table `app_repo`.`role_permission_mapping`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`role_permission_mapping` (
  `permission_id` BIGINT NOT NULL COMMENT '权限id',
  `role_id` BIGINT NOT NULL COMMENT '角色id',
  PRIMARY KEY (`permission_id`, `role_id`),
  INDEX `role_fk_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `permission_fk`
    FOREIGN KEY (`permission_id`)
    REFERENCES `app_repo`.`permission` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `role_fk`
    FOREIGN KEY (`role_id`)
    REFERENCES `app_repo`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '角色权限映射表';


-- -----------------------------------------------------
-- Table `app_repo`.`user_role_mapping`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`user_role_mapping` (
  `user_id` BIGINT NOT NULL,
  `role_id` BIGINT NOT NULL COMMENT '角色id',
  PRIMARY KEY (`user_id`, `role_id`),
  INDEX `role_fk_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `user_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `app_repo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `role_fk`
    FOREIGN KEY (`role_id`)
    REFERENCES `app_repo`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '用户角色映射表';


-- -----------------------------------------------------
-- Table `app_repo`.`app_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`app_info` (
  `id` BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  `user_id` BIGINT NOT NULL COMMENT '所属用户',
  `name` VARCHAR(45) NOT NULL COMMENT '应用名称',
  `dis_name` VARCHAR(45) NULL COMMENT '应用显示名称',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_name_uq` (`user_id` ASC, `name` ASC) INVISIBLE,
  CONSTRAINT `app_user_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `app_repo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '应用信息表';


-- -----------------------------------------------------
-- Table `app_repo`.`app_package`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_repo`.`app_package` (
  `id` BIGINT UNIQUE NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  PRIMARY KEY (`id`))
COMMENT = '应用包文件表';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
