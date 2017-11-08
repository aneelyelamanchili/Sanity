DROP DATABASE if exists Sanity;

CREATE DATABASE Sanity; 

USE Sanity;

CREATE TABLE `TotalUsers` (
	`userID` INT(11) auto_increment NOT NULL, 
    `FirstName` VARCHAR(50) NOT NULL,
    `LastName` VARCHAR(50) NOT NULL,
    `Password` INT(16) NOT NULL, 
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
    `Frequency` INT NOT NULL,
    `Date` VARCHAR(50) NOT NULL, -- check if date + x*frequency is even number, if so set totalamountspent to 0 and store in history
    `BigBudgetDaysLeft` INT NOT NULL,
    FOREIGN KEY(`userID`) REFERENCES `TotalUsers`(`userID`),
    PRIMARY KEY(`bigBudgetID`)
);

CREATE TABLE `Budgets` (
	`budgetID` INT(11) auto_increment NOT NULL,
    `bigBudgetID` INT(11) NOT NULL,
    `BudgetAmount` FLOAT NOT NULL,
    `BudgetName` VARCHAR(50) NOT NULL,
	`TotalAmountSpent` FLOAT NOT NULL,
    FOREIGN KEY(`bigBudgetID`) REFERENCES `BigBudgets`(`bigBudgetID`),
    PRIMARY KEY(`budgetID`)
);

CREATE TABLE `Transactions` (
	`transactionID` INT(11) auto_increment NOT NULL,
    `budgetID` INT(11) NOT NULL,
    `Amount` VARCHAR(50) NOT NULL,
    `Details` VARCHAR(50) NOT NULL,
	`Latitude` FLOAT NOT NULL,
    `Longitude` FLOAT NOT NULL,
    `DateValue` VARCHAR(50) NOT NULL,
    FOREIGN KEY(`budgetID`) REFERENCES `Budgets`(`budgetID`),
    PRIMARY KEY(`transactionID`)
);

 INSERT INTO `TotalUsers`(FirstName, LastName, Password, Email) VALUES ('Aneel', 'Yelamanchili', 314, 'a');
 INSERT INTO `BigBudgets` (userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent, Frequency, Date, BigBudgetDaysLeft) VALUES (1, 'AneelLife', 2, 10, 10, 100000, 0, 10, 'date', 2);
 INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName, TotalAmountSpent) VALUES (1, 50000, 'Credit Cards', 0);
 INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName, TotalAmountSpent) VALUES (1, 50000, 'Ultimate Succ', 0);
 INSERT INTO `Transactions`(transactionID, budgetID, Amount, Details, Latitude, Longitude, DateValue) VALUES(1, 1, '+500.12', 'Eating Ass', 33.0224,117.2851, '12/30/2016');
  INSERT INTO `Transactions`(transactionID, budgetID, Amount, Details, Latitude, Longitude, DateValue) VALUES(2, 1, '-20.29', 'Sucking Tommy Trojan', 34.0224,118.2851, '11/20/2017');