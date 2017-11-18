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
    `PeriodNotification` VARCHAR(50) NOT NULL,
    `PeriodNotificationChecked` VARCHAR(50) NOT NULL,
    `LimitNotification` VARCHAR(50) NOT NULL,
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
    `Amount` FLOAT NOT NULL,
    `Details` VARCHAR(50) NOT NULL,
	`Latitude` FLOAT NOT NULL,
    `Longitude` FLOAT NOT NULL,
    `DateValue` VARCHAR(50) NOT NULL,
    FOREIGN KEY(`budgetID`) REFERENCES `Budgets`(`budgetID`),
    PRIMARY KEY(`transactionID`)
);

CREATE TABLE `History` (
	`historyID` INT(11) auto_increment NOT NULL,
    `budgetID` INT(11) NOT NULL,
    `CategoryAmount` FLOAT NOT NULL,
    `TotalAmountSpent` FLOAT NOT NULL,
    `HistoryNum` INT(11) NOT NULL,
    `StartDate` VARCHAR(50) NOT NULL,
    FOREIGN KEY(`BudgetID`) REFERENCES `Budgets`(`budgetID`),
    PRIMARY KEY(`historyID`)
);

--  INSERT INTO `TotalUsers`(FirstName, LastName, Password, Email) VALUES ('Aneel', 'Yelamanchili', 314, 'a');
--  INSERT INTO `BigBudgets` (userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent, Frequency, Date, BigBudgetDaysLeft, PeriodNotification, PeriodNotificationChecked, LimitNotification) VALUES (1, 'AneelLife', 2, 10, 10, 100, 0, 10, '11/13/2017', 0, '50 25','','80 90 95');
--  INSERT INTO `BigBudgets` (userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent, Frequency, Date, BigBudgetDaysLeft, PeriodNotification, PeriodNotificationChecked, LimitNotification) VALUES (1, 'Life', 2, 10, 10, 100, 40, 10, '11/13/2017', 0, '50 25','','80 90 95');
  
-- INSERT INTO `BigBudgets` (userID, BigBudgetName, BarGraphColor, Latitude, Longitude, BigBudgetAmount, TotalAmountSpent, Frequency, Date, BigBudgetDaysLeft, PeriodNotification, PeriodNotificationChecked, LimitNotification) VALUES (1, 'Annual Savings', 1, 0, 0, 0, 0, 365, '06/29/2018', 365, '50','','80 90 95');
-- INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName, TotalAmountSpent) VALUES (1, 100, 'Credit Cards', 60);
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 20, 1, '05/13/2017');
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 10, 2, '06/13/2017');
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 30, 3, '07/13/2017');
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 40, 4, '08/13/2017');
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 50, 5, '09/13/2017');
-- INSERT INTO `History` (budgetID, CategoryAmount, TotalAmountSpent, HistoryNum, StartDate) VALUES (1, 100, 60, 6, '10/13/2017');
 -- INSERT INTO `Budgets` (bigBudgetID, BudgetAmount, BudgetName, TotalAmountSpent) VALUES (1, 50000, 'Ultimate Succ', 0);
  -- INSERT INTO `Transactions`(transactionID, budgetID, Amount, Details, Latitude, Longitude, DateValue) VALUES(1, 1, 500.12, 'Eating Food', 33.0224,117.2851, '12/30/2016');
-- INSERT INTO `Transactions`(transactionID, budgetID, Amount, Details, Latitude, Longitude, DateValue) VALUES(2, 1, '-20.29', 'Tommy Trojan', 34.0224,118.2851, '11/20/2017');