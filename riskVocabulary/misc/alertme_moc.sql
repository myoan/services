SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `alertme_moc` DEFAULT CHARACTER SET utf8 ;
USE `alertme_moc` ;

-- -----------------------------------------------------
-- Table `alertme_moc`.`risk_expression`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `alertme_moc`.`risk_expression` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `words` VARCHAR(1000) NOT NULL COMMENT 'リスク表現ワード\n「,」区切り' ,
  `fault` VARCHAR(1000) NOT NULL COMMENT 'fault' ,
  `failure` VARCHAR(1000) NOT NULL COMMENT 'failure' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Risk Infomation';

-- -----------------------------------------------------
-- Table `alertme_moc`.`risk_keyword`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `alertme_moc`.`risk_keyword` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `keyword` VARCHAR(1000) NOT NULL COMMENT 'keyword' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Keyword Infomation';

-- -----------------------------------------------------
-- Table `alertme_moc`.`risk_kw_relation`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `alertme_moc`.`risk_kw_relation` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `kw_id` INT NOT NULL,
  `risk_id` INT NOT NULL,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'Risk - Keyword Relationships';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
