
-----NAME:    -------      SAMUEL WAIRIUKO----


--Banking SQL Project Phase 1

--Q1. Creating a database for a banking application called 'BankABC'. Uppercase keyword convention is used for clarity

CREATE DATABASE BankABC

--Using or activating the Bank database to create tables to hold banking transactions
USE BankABC;

----Q2 and Q3 are done together for bettr organization and clarity
--Q2. Create all the tables mentioned in the database diagram. 
--Q3. Create all the constraints based on the database diagram. 

/* Bank tables and their Constraints starting with tables with Primary keys*/

CREATE TABLE UserLogins
(
	UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
	UserLogin VARCHAR(50) NOT NULL,
	UserPassword VARCHAR(20) NOT NULL,
	CONSTRAINT pk_UL_UserLoginID PRIMARY KEY(UserLoginID)
);

CREATE TABLE UserSecurityQuestions
(
	UserSecurityQuestionID TINYINT NOT NULL IDENTITY(1,1),
	UserSecurityQuestion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_USQ_UserSecurityQuestionID PRIMARY KEY(UserSecurityQuestionID)
);

CREATE TABLE AccountType
(
	AccountTypeID TINYINT NOT NULL IDENTITY(1,1),
	AccountTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT pk_AT_AccountTypeID PRIMARY KEY(AccountTypeID)
);

CREATE TABLE SavingsInterestRates
(
	InterestSavingRatesID TINYINT NOT NULL IDENTITY(1,1),
	InterestRatesValue NUMERIC(9,9) NOT NULL, 
	InterestRatesDescription VARCHAR(20) NOT NULL,
	CONSTRAINT pk_SIR_InterestSavingRatesID PRIMARY KEY(InterestSavingRatesID)
);

CREATE TABLE AccountStatusType
(
	AccountStatusTypeID TINYINT NOT NULL IDENTITY(1,1),
	AccountStatusTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT pk_AST_AccountStatusTypeID PRIMARY KEY(AccountStatusTypeID)
);

CREATE TABLE FailedTransactionErrorType
(
	FailedTransactionErrorTypeID TINYINT NOT NULL IDENTITY(1,1),
	FailedTransactionErrorTypeDescription VARCHAR(50) NOT NULL,
	CONSTRAINT pk_FTET_FailedTransactionErrorTypeID PRIMARY KEY(FailedTransactionErrorTypeID)
);

CREATE TABLE LoginErrorLog
(
	ErrorLogID INT NOT NULL IDENTITY(1,1),
	ErrorTime DATETIME NOT NULL,
	FailedTransactionXML XML,
	CONSTRAINT pk_LEL_ErrorLogID PRIMARY KEY(ErrorLogID)
);

CREATE TABLE Employee
(
	EmployeeID INT NOT NULL IDENTITY(1,1),
	EmployeeFirstName VARCHAR(25) NOT NULL,
	EmployeeMiddleInitial CHAR(1),
	EmployeeLastName VARCHAR(25),
	EmployeeisManager BIT,
	CONSTRAINT pk_E_EmployeeID PRIMARY KEY(EmployeeID)
);

CREATE TABLE TransactionType
(
	TransactionTypeID TINYINT NOT NULL IDENTITY(1,1),
	TransactionTypeName CHAR(10) NOT NULL,
	TransactionTypeDescription VARCHAR(50),
	TransactionFeeAmount SMALLMONEY,
	CONSTRAINT pk_TT_TransactionTypeID PRIMARY KEY(TransactionTypeID)
);

/*Foreign key tables and their respective association with Primary and Foreign keys */

CREATE TABLE FailedTransactionLog
(
	FailedTransactionID INT NOT NULL IDENTITY(1,1),
	FailedTransactionErrorTypeID TINYINT NOT NULL,
	FailedTransactionErrorTime DATETIME,
	FailedTransactionErrorXML XML,
	CONSTRAINT pk_FTL_FailedTransactionID PRIMARY KEY(FailedTransactionID),
	CONSTRAINT fk_FTET_FailedTransactionErrorTypeID FOREIGN KEY(FailedTransactionErrorTypeID) REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID) 
);

CREATE TABLE UserSecurityAnswers
(
	UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
	UserSecurityAnswers VARCHAR(25) NOT NULL,
	UserSecurityQuestionID TINYINT NOT NULL,
	CONSTRAINT pk_USA_UserLoginID PRIMARY KEY(UserLoginID), 
	CONSTRAINT fk_UL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT fk_USQ_UserSecurityQuestionID FOREIGN KEY(UserSecurityQuestionID) REFERENCES UserSecurityQuestions(UserSecurityQuestionID)
);

CREATE TABLE Account
(
	AccountID INT NOT NULL IDENTITY(1,1),
	CurrentBalance INT NOT NULL,
	AccountTypeID TINYINT NOT NULL REFERENCES AccountType (AccountTypeID),
	AccountStatusTypeID TINYINT NOT NULL,
	InterestSavingRatesID TINYINT NOT NULL,
	CONSTRAINT pk_A_AccounID PRIMARY KEY(AccountID),
	CONSTRAINT fk_AST_AccountStatusTypeID FOREIGN KEY(AccountStatusTypeID) REFERENCES AccountStatusType(AccountStatusTypeID),
	CONSTRAINT fk_SIR_InterestSavingRatesID FOREIGN KEY(InterestSavingRatesID) REFERENCES SavingsInterestRates(InterestSavingRatesID)
);

CREATE TABLE LoginAccount
(
	UserLoginID SMALLINT NOT NULL,
	AccountID INT NOT NULL,
	CONSTRAINT fk_UL_UserLogins FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT fk_A_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Customer
(
	CustomerID INT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
	CustomerAddress1 VARCHAR(30) NOT NULL,
	CustomerAddress2  VARCHAR(30),
	CustomerFirstName  VARCHAR(30) NOT NULL,
	CustomerMiddleInitial CHAR(1),
	CustomerLastName  VARCHAR(30) NOT NULL,
	City  VARCHAR(20) NOT NULL,
	State CHAR(2) NOT NULL,
	ZipCode CHAR(10) NOT NULL,
	EmailAddress CHAR(40) NOT NULL,
	HomePhone VARCHAR(10) NOT NULL,
	CellPhone VARCHAR(10) NOT NULL,
	WorkPhone VARCHAR(10) NOT NULL,
	SSN VARCHAR(9),
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_C_CustomerID PRIMARY KEY(CustomerID),
	CONSTRAINT fk_A_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_UL_C_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)  
);

CREATE TABLE CustomerAccount
(
	AccountID INT NOT NULL ,
	CustomerID INT NOT NULL,
	CONSTRAINT fk_A_CA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_CA_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE TransactionLog
(
	TransactionID INT NOT NULL IDENTITY(1,1),
	TransactionDate DATETIME NOT NULL,
	TransactionTypeID TINYINT NOT NULL,
	TransactionAmount Money NOT NULL,
	NewBalance Money NOT NULL,
	AccountID INT NOT NULL,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT pk_TL_TransactionID PRIMARY KEY(TransactionID),
	CONSTRAINT fk_TT_TL_TransactionTypeID FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
	CONSTRAINT fk_A_TL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fk_C_TL_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_E_TL_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT fk_UL_TL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)    
);

CREATE TABLE OverDraftLog
(
	AccountID INT NOT NULL IDENTITY(1,1),
	OverDraftDate DATETIME NOT NULL,
	OverDraftAmount Money NOT NULL,
	OverDraftTransactionXML XML NOT NULL,
	CONSTRAINT Pk_ODL_AccountID PRIMARY KEY(AccountID),
	CONSTRAINT fk_A_ODL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);


/*Q4. Insert at least 5 rows in each table.*/
/*Data Insertion to the above created tables*/

insert into UserLogins values(1, 'Pass1');
insert into UserLogins values(2,'Pass2');
insert into UserLogins values(3, 'Pass3');
insert into UserLogins values(4, 'Pass4');
insert into UserLogins values(5, 'Pass5');


SELECT * FROM UserLogins

insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite food?');

SELECT * FROM UserSecurityQuestions

Insert into AccountType values('Savings');
Insert into AccountType values('Checking');

SELECT * FROM AccountType

insert into SavingsInterestRates values(0.5, 'Low');
insert into SavingsInterestRates values(2, 'Medium');
insert into SavingsInterestRates values(3, 'High');
insert into SavingsInterestRates values(4, 'Very high');
insert into SavingsInterestRates values(5, 'Super high');

SELECT * FROM SavingsInterestRates

insert into AccountStatusType values('Closed');
insert into AccountStatusType values('Active');
insert into AccountStatusType values('Dormant');
insert into AccountStatusType values('Passive');
insert into AccountStatusType values('Active');

SELECT * FROM AccountStatusType

insert into FailedTransactionErrorType values('Withdraw limit reached');
insert into FailedTransactionErrorType values('Daily limit reached');
insert into FailedTransactionErrorType values('No tenough balance');
insert into FailedTransactionErrorType values('Invalid denomination');
insert into FailedTransactionErrorType values('ATM machine down');

SELECT * FROM FailedTransactionErrorType

insert into LoginErrorLog values(TRY_CAST('2015/6/4 07:30:56' AS DATETIME), 'Bad Connection');
insert into LoginErrorLog values(TRY_CAST('2018/6/9 12:34:57' AS DATETIME), 'Invalid User');
insert into LoginErrorLog values(TRY_CAST('2016/4/5 02:14:00' AS DATETIME), 'Wrong Password');
insert into LoginErrorLog values(TRY_CAST('2014/7/5 05:56:59' AS DATETIME), 'Server issue');
insert into LoginErrorLog values(TRY_CAST('2009/10/12 08:34:15' AS DATETIME), 'Datacenter down');

SELECT * FROM LoginErrorLog

insert into Employee values('E3', 'K', 'E3', '0');
insert into Employee values('E5', 'B', 'E5', '1');
insert into Employee values('E7', 'P', 'E7', '0');
insert into Employee values('E9', 'R', 'E9', '1');
insert into Employee values('E11', 'K', 'E11', '1');

SELECT * FROM Employee

insert into TransactionType values('Balance', 'See money', '0');
insert into TransactionType values('Transfer', 'Send money', '450');
insert into TransactionType values('Receive', 'Get money', '300');
insert into TransactionType values('Paid', 'Paid to John', '45000');
insert into TransactionType values('Statement', 'Checked monthly transaction', '0');

SELECT * FROM TransactionType

insert into FailedTransactionLog values(1, TRY_CAST('2015/6/4 07:30:56' AS DATETIME), 'First');
insert into FailedTransactionLog values(2, TRY_CAST('2018/6/9 12:34:57' AS DATETIME), 'Second');
insert into FailedTransactionLog values(3, TRY_CAST('2016/4/5 02:14:00' AS DATETIME), 'Third');
insert into FailedTransactionLog values(4, TRY_CAST('2014/7/5 05:56:59' AS DATETIME), 'Fourth');
insert into FailedTransactionLog values(5, TRY_CAST('2009/10/12 08:34:15' AS DATETIME), 'Fifth');

SELECT * FROM FailedTransactionLog

insert into UserSecurityAnswers values('Apples', 1);
insert into UserSecurityAnswers values('Spiderman', 2);
insert into UserSecurityAnswers values('School1', 3);
insert into UserSecurityAnswers values('Ram', 4);
insert into UserSecurityAnswers values('Toyota', 5);

SELECT * FROM UserSecurityAnswers

insert into Account values(15000.7, 1, 1, 1);
insert into Account values(25000.5, 2, 2, 2);
insert into Account values(17000.2, 1, 1, 1);
insert into Account values(45000, 2, 2, 2);
insert into Account values(2320, 2, 2, 2);

SELECT * FROM Account

insert into LoginAccount values(1, 1);
insert into LoginAccount values(2, 2);
insert into LoginAccount values(3, 3);
insert into LoginAccount values(4, 4);
insert into LoginAccount values(5, 5);

SELECT * FROM LoginAccount

insert into Customer values(1, 'Address1', 'Address2', 'Customer1', 'U', 'CLastname1', 'Ottawa', 'ON', '3A5z9z', 'user5@user.com', '141655555', '453554464', '3462325', 'A12345', 1);
insert into Customer values(2, 'Address1', 'Address2', 'Customer2', 'K', 'CLastname2', 'Hamilton', 'ON', 'fe3453', 'user6@user.com', '141655555', '567435345', '6332423', 'D34353', 2);
insert into Customer values(3, 'Address1', 'Address2', 'Customer3', 'P', 'CLastname3', 'Vacouver', 'BC', 'fdf45', 'user7@user.com', '141655555', '681316226', '9202521', 'J56361', 3);
insert into Customer values(4, 'Address1', 'Address2', 'Customer4', 'B', 'CLastname4', 'London', 'ON', '23ffbfs', 'user8@user.com', '141655555', '795197107', '8674252', 'I78369', 4);
insert into Customer values(5, 'Address1', 'Address2', 'Customer5', 'K', 'CLastname5', 'Calgary', 'AB', 'hg4536', 'user9@user.com', '141655555', '909077988', '9209371', 'K10377', 5);

SELECT * FROM Customer

insert into CustomerAccount values(1, 1);
insert into CustomerAccount values(2, 2);
insert into CustomerAccount values(3, 3);
insert into CustomerAccount values(4, 4);
insert into CustomerAccount values(5, 5);

SELECT * FROM CustomerAccount
insert into TransactionLog values('2015/6/4 07:30:56', 1,15000.7, 7869878, 1, 1, 1, 1);
insert into TransactionLog values('2018/6/9 12:34:57', 2,435435, 675687, 2, 2, 2, 2);
insert into TransactionLog values('2016/4/5 02:14:00', 3,855869.3, 34512356, 3, 3, 3, 3);
insert into TransactionLog values('2014/7/5 05:56:59', 4,1276303.6, 4643234, 4, 4, 4, 4);
insert into TransactionLog values('2009/10/12 08:34:15', 5,1696737.9, 325344, 5, 5, 5, 5);

SELECT * FROM TransactionLog

insert into OverDraftLog values('2015/6/4 07:30:56', 0, 'Clear');
insert into OverDraftLog values('2018/6/9 12:34:57', 5, 'Pending');
insert into OverDraftLog values('2016/4/5 02:14:00', 10, 'Clear');
insert into OverDraftLog values('2014/7/5 05:56:59', 15, 'Pending');
insert into OverDraftLog values('2009/10/12 08:34:15', 20, 'Clear');

SELECT * FROM OverDraftLog

/* Banking SQL Project Phase 2 */

--Q1. Create a view to get all customers with checking account from ON province. 

DROP VIEW VW_Customer_ON;
GO

CREATE VIEW VW_Customer_ON AS
SELECT DISTINCT c.* FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
WHERE at.AccountTypeDescription = 'Checking' and c.State = 'ON';
GO

--Q2. Create a view to get all customers with total account balance (including interest rate) greater than 5000. 

DROP VIEW VW_Customer_AMT;
GO

CREATE VIEW VW_Customer_ON AS
SELECT c.CustomerFirstName, SUM(a.CurrentBalance) AS Ac_Balance, SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestSavingRatesID)/100) AS Total_Ac_Balance 
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN SavingsInterestRates s
ON a.InterestSavingRatesID = s.InterestSavingRatesID 
GROUP BY c.CustomerFirstName
HAVING SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestRatesValue)/100) > 5000;
GO

--Q3. Create a view to get counts of checking and savings accounts by customer. 

DROP VIEW VW_Customer_ACC;
GO

CREATE VIEW VW_Customer_ACC 
AS
SELECT c.CustomerFirstName, at.AccountTypeDescription, COUNT(*) AS Total_AC_Types FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
GROUP BY c.CustomerFirstName, at.AccountTypeDescription;
GO

--Q4. Create a view to get any particular user?s login and password using AccountId. 

DROP VIEW VW_Account_UL;
GO

CREATE VIEW VW_Account_UL 
AS
SELECT DISTINCT ul.UserLogin, ul.UserPassword
FROM UserLogins ul
JOIN LoginAccount la
ON ul.UserLoginID = la.UserLoginID
--JOIN Account a
--ON la.AccountID = a.AccountID;
WHERE la.AccountID = '1'
GO;

--Q5. Create a view to get all customers? overdraft amount. 

DROP VIEW VW_Customer_OD;
GO

CREATE VIEW VW_Customer_OD 
AS
SELECT DISTINCT c.CustomerFirstName, o.OverDraftAmount
FROM OverDraftLog o
JOIN Customer c
ON o.AccountID = c.AccountID;
GO

--Q6. Create a stored procedure to add "User_" as a prefix to everyone's login (username). 

DROP PROCEDURE sp_Update_Login;
GO

CREATE PROCEDURE sp_Update_Login
AS
UPDATE UserLogins
SET UserLogin = Concat('User_', UserLogin);
GO
EXEC sp_Update_Login;
GO

--Q7. Create a stored procedure that accepts AccountId as a parameter and returns customer's full name. 

DROP PROCEDURE sp_Customer_Details;
GO

CREATE PROCEDURE sp_Customer_Details @AccountID INT
AS
SELECT c.CustomerFirstName + ' ' + c.CustomerMIddleInitial + ' ' + c.CustomerLastName AS Customer_Full_Name
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
WHERE a.AccountID = @AccountID;
GO

EXEC sp_Costumer_Details 2;
GO






--Q8. Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account.  

DROP PROCEDURE sp_Update_cBalance_After_Deposit;
GO

CREATE PROCEDURE sp_Update_cBalance_After_Deposit @AccountID INT, @Deposit INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance + @Deposit
where AccountID = @AccountID;
GO

EXEC sp_Update_cBalance_After_Deposit 3, 300;
GO

--Q9. Create a stored procedure that takes a withdrawal amount as a parameter and updates CurrentBalance value for that particular account. 

DROP PROCEDURE sp_Update_cBalance_After_Withdraw;
GO

CREATE PROCEDURE sp_Update_cBalance_After_Withdraw @AccountID INT, @Withdraw INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance - @Withdraw
WHERE AccountID = @AccountID;
GO

EXEC sp_Update_cBalance_After_Withdraw 3, 300;
GO


--Q10. Write a query to remove SSN column from Customer table. 

DROP PROCEDURE sp_Remove_Column;
GO

CREATE PROCEDURE sp_Remove_Column
AS
ALTER TABLE CUSTOMER
DROP COLUMN CustomerAddress1;
GO