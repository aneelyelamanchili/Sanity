DROP DATABASE if exists Sanity;

CREATE DATABASE Sanity; 

USE Sanity;

CREATE TABLE `TotalUsers` (
	`userID` INT(11) auto_increment NOT NULL, 
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Password` VARCHAR(50) NOT NULL, 
    `Email` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`userID`) 
);

CREATE TABLE `BigBudgets` (
	`bigBudgetID` INT(11) auto_increment NOT NULL,
    `userID` INT(11) NOT NULL,
    `BigBudgetName` VARCHAR(50) NOT NULL,
    `BarGraphColor` INT(11) NOT NULL,
    `Latitude` FLOAT NOT NULL,
    `Longitude` FLOAT NOT NULL,
    `BigBudgetAmount` FLOAT NOT NULL,
    `TotalAmountSpent` FLOAT NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
    PRIMARY KEY(`bigBudgetID`)
);

CREATE TABLE `Budgets` (
	`budgetID` INT(11) auto_increment NOT NULL,
    `bigBudgetID` INT(11) NOT NULL,
    `BudgetAmount` FLOAT NOT NULL,
    `BudgetName` VARCHAR(50) NOT NULL,
    FOREIGN KEY(`bigBudgetID`) REFERENCES `BigBudgets`(`bigBudgetID`),
    PRIMARY KEY(`budgetID`)
);

INSERT INTO `TotalUsers`(FirstName, LastName, Password, Email) VALUES ('Aneel', 'Yelamanchili', 'a', 'a');
INSERT INTO `BigBudgets` (userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent) VALUES (1, 'AneelLife', 2, 10, 10, 100000, 0);
INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName) VALUES (1, 50000, 'Credit Cards');
INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName) VALUES (1, 50000, 'Ultimate Succ');