# DataBase_Solution (Lecture Example for the first four weeks)

# Database Learning Guide: Normalization, Temporal Databases, Indexing, Query Optimization, Concurrency, Transactions, Locks, Versioning, and Views

## 1. Database Creation and Normalization

### Step 1: Create a Database

First, create a new database:

```sql
CREATE DATABASE CompanyDB;
USE CompanyDB;
````
## Step 2: Define Unnormalized Table

Create a simple, unnormalized table that stores employee information along with their project details:

```sql
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    EmployeeName VARCHAR(255),
    Department VARCHAR(255),
    Project1 VARCHAR(255),
    Project2 VARCHAR(255),
    Project3 VARCHAR(255)
);

````
## Step 3: Normalize the Table to 1NF, 2NF, and 3NF
1NF (First Normal Form): Ensure that each column contains atomic values, and each entry is unique.
```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255),
    Department VARCHAR(255)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    ProjectName VARCHAR(255),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

````
2NF (Second Normal Form): Remove partial dependencies, ensuring that non-key attributes depend on the whole primary key.

- In this case, we already have it because EmployeeID is the whole primary key in Projects.
3NF (Third Normal Form): Remove transitive dependencies, ensuring non-key attributes depend only on the primary key.

- The tables are already in 3NF because all non-key attributes are dependent only on the primary key.

# 2. Temporal Database

## Step 4: Implement a Temporal Table
Temporal tables track changes to records over time. Let's extend the Employees table to a temporal table.

```sql
CREATE TABLE EmployeeHistory (
    EmployeeID INT,
    EmployeeName VARCHAR(255),
    Department VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    PRIMARY KEY (EmployeeID, StartDate)
);

````
Step 5: Insert Data 

```sql
INSERT INTO Employees (EmployeeID, EmployeeName, Department)
VALUES 
(1, 'John Doe', 'Sales'),
(2, 'Jane Smith', 'Marketing'),
(3, 'Robert Brown', 'IT'),
(4, 'Emily Davis', 'HR'),
(5, 'Michael Johnson', 'Finance');


````



```sql
INSERT INTO Projects (EmployeeID, ProjectName)
VALUES 
(1, 'Project Alpha'),
(1, 'Project Beta'),
(2, 'Project Gamma'),
(3, 'Project Delta'),
(4, 'Project Epsilon'),
(5, 'Project Zeta'),
(3, 'Project Theta'),
(2, 'Project Iota');

````
```sql
INSERT INTO Projects (EmployeeID, ProjectName)
VALUES 
(1, 'Project Alpha'),
(1, 'Project Beta'),
(2, 'Project Gamma'),
(3, 'Project Delta'),
(4, 'Project Epsilon'),
(5, 'Project Zeta'),
(3, 'Project Theta'),
(2, 'Project Iota');

````
```sql
INSERT INTO EmployeeHistory (EmployeeID, EmployeeName, Department, StartDate, EndDate)
VALUES 
(1, 'John Doe', 'Sales', '2020-01-01', '2021-01-01'),
(1, 'John Doe', 'Marketing', '2021-01-02', NULL),
(2, 'Jane Smith', 'Marketing', '2019-06-15', NULL),
(3, 'Robert Brown', 'IT', '2018-03-22', NULL),
(4, 'Emily Davis', 'HR', '2020-09-30', NULL),
(5, 'Michael Johnson', 'Finance', '2022-04-12', NULL);

````
```sql
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(255),
    Balance DECIMAL(10, 2)
);

INSERT INTO Accounts (AccountID, AccountHolder, Balance)
VALUES 
(1, 'John Doe', 1000.00),
(2, 'Jane Smith', 1500.00),
(3, 'Robert Brown', 2000.00),
(4, 'Emily Davis', 2500.00),
(5, 'Michael Johnson', 3000.00);

````
# 3. Indexing
## Step 6: Create Indexes for Performance
Indexes improve query performance by allowing the database to find rows faster.

```sql
CREATE INDEX idx_employee_name ON Employees (EmployeeName);
CREATE INDEX idx_department ON Employees (Department);

````
## Step 7: Analyze Query Performance
You can compare the execution time of queries with and without using indexes:

```sql
EXPLAIN SELECT * FROM Employees WHERE EmployeeName = 'John Doe';

````
# 4. Query Optimization
# Step 8: Use Query Optimization Techniques
Optimize queries by selecting only the necessary columns, avoiding SELECT *, and using joins effectively.

Before Optimization:
```sql
SELECT * FROM Employees JOIN Projects ON Employees.EmployeeID = Projects.EmployeeID WHERE Department = 'Sales';

````
After Optimization:
```sql
SELECT Employees.EmployeeID, Employees.EmployeeName, Projects.ProjectName
FROM Employees
JOIN Projects ON Employees.EmployeeID = Projects.EmployeeID
WHERE Employees.Department = 'Sales';

````
## Step 9: Use Explain Plans
Use EXPLAIN to analyze and optimize query execution plans:
```sql
EXPLAIN SELECT Employees.EmployeeID, Employees.EmployeeName, Projects.ProjectName
FROM Employees
JOIN Projects ON Employees.EmployeeID = Projects.EmployeeID
WHERE Employees.Department = 'Sales';
````

# 5. Concurrency and Transactions

## Step 10: Implement Transactions
Transactions ensure data integrity. Let’s perform a money transfer between two accounts.
```sql
START TRANSACTION;

UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 2;

COMMIT;

````

If any statement fails, the ROLLBACK command would revert all changes.

## Step 11: Demonstrate Locks
Use locks to manage concurrent transactions.

Example of a Shared Lock:
```sql
START TRANSACTION;

-- Lock the row in share mode (for reading, prevents other transactions from acquiring exclusive locks)
SELECT * FROM Employees WHERE EmployeeID = 1 LOCK IN SHARE MODE;

-- You can read the data, but not update it in this transaction
-- Another transaction can still read the data but cannot modify it until this transaction ends

COMMIT;

````
Example of an Exclusive Lock:

```sql
START TRANSACTION;
-- Lock the row for updating
SELECT * FROM Employees WHERE EmployeeID = 1 FOR UPDATE;

-- Perform your updates or other operations
UPDATE Employees SET EmployeeName = 'John Doe Updated' WHERE EmployeeID = 1;

COMMIT;
````
# 6. Versioning
## Step 12: Implement Multiversion Concurrency Control (MVCC)
Many databases like PostgreSQL implement MVCC, allowing multiple versions of a record to exist.

```sql
START TRANSACTION;
UPDATE Employees SET EmployeeName = 'Jane Doe' WHERE EmployeeID = 1;
-- Version 1 is still visible to other transactions until this transaction commits
COMMIT;
````
# 7. Views
## Step 13: Create and Use Views
Views can present data in a specific format or subset.

```sql
CREATE VIEW ActiveEmployees AS
SELECT EmployeeID, EmployeeName FROM Employees WHERE Department = 'Sales';

SELECT * FROM ActiveEmployees;

````
# 8. Triggers
Creating a Trigger
Triggers automatically execute specified SQL code when certain events occur in the database, such as an INSERT, UPDATE, or DELETE operation.

Example: Log Changes to the Accounts Table
We'll create a trigger that logs every update to the Accounts table into an AccountChanges log table.

```sql
-- Create a log table
CREATE TABLE AccountChanges (
    ChangeID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT,
    OldBalance DECIMAL(10, 2),
    NewBalance DECIMAL(10, 2),
    ChangeTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the trigger
DELIMITER //

CREATE TRIGGER after_account_update
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO AccountChanges (AccountID, OldBalance, NewBalance)
    VALUES (OLD.AccountID, OLD.Balance, NEW.Balance);
END //

DELIMITER ;


````
Explanation:
AFTER UPDATE: The trigger fires after an update operation on the Accounts table.
OLD and NEW: These keywords allow access to the row's data before and after the update.
INSERT INTO AccountChanges: This records the change in the AccountChanges log table.


# 9. Stored Procedures
Creating a Stored Procedure
Stored procedures are reusable SQL code blocks that can be called with parameters. They are useful for encapsulating business logic in the database.

Example: Transfer Money Between Accounts
We'll create a stored procedure that handles transferring money between two accounts, incorporating error handling and transaction management.

```sql
DELIMITER //

CREATE PROCEDURE TransferMoney(IN fromAccountID INT, IN toAccountID INT, IN amount DECIMAL(10, 2))
BEGIN
    DECLARE insufficient_funds CONDITION FOR SQLSTATE '45000';
    DECLARE EXIT HANDLER FOR insufficient_funds
    BEGIN
        ROLLBACK;
        SELECT 'Insufficient funds, transaction rolled back.' AS message;
    END;

    START TRANSACTION;

    -- Deduct from the sender's account
    UPDATE Accounts SET Balance = Balance - amount WHERE AccountID = fromAccountID;

    -- Check if the balance is negative
    IF (SELECT Balance FROM Accounts WHERE AccountID = fromAccountID) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    -- Add to the recipient's account
    UPDATE Accounts SET Balance = Balance + amount WHERE AccountID = toAccountID;

    COMMIT;
    SELECT 'Transaction successful.' AS message;
END //

DELIMITER ;

````
Explanation:
IN parameters: Define the input parameters for the stored procedure.
Transaction Management: The procedure uses START TRANSACTION, COMMIT, and error handling to ensure atomicity.
Error Handling: SIGNAL SQLSTATE is used to trigger a rollback if there are insufficient funds.
Calling the Stored Procedure
```sql

CALL TransferMoney(1, 2, 100.00);

````
# 10. Events
Creating an Event
Events are scheduled database tasks that run automatically at specified intervals. They are useful for automating routine tasks.

Example: Daily Interest Update
We’ll create an event that adds interest to all accounts at midnight every day.
```sql
DELIMITER //

CREATE EVENT DailyInterestUpdate
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
BEGIN
    UPDATE Accounts SET Balance = Balance * 1.001; -- Assuming 0.1% daily interest
END //

DELIMITER ;


````
Explanation:
ON SCHEDULE EVERY 1 DAY: The event runs once a day.
STARTS: Defines when the event should start.
UPDATE statement: Increases the balance of each account by 0.1%.
Managing Events
Enable or disable the event using:

```sql

ALTER EVENT DailyInterestUpdate ENABLE;
ALTER EVENT DailyInterestUpdate DISABLE;

````
# 11. User Accounts and Security
Creating User Accounts
In MySQL/MariaDB, you can create user accounts and assign specific privileges to ensure security.

Example: Creating a New User
```sql
CREATE USER 'bank_admin'@'localhost' IDENTIFIED BY 'secure_password';
CREATE USER 'bank_user'@'localhost' IDENTIFIED BY 'user_password';


````
Granting Privileges
You can grant specific privileges to users based on their roles.

```sql
-- Grant all privileges to bank_admin
GRANT ALL PRIVILEGES ON CompanyDB.* TO 'bank_admin'@'localhost';

-- Grant limited privileges to bank_user
GRANT SELECT, INSERT, UPDATE ON CompanyDB.Accounts TO 'bank_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;


````
Security Considerations
Use strong passwords and enforce password policies.
Grant the minimum necessary privileges to each user based on their role.
Regularly review and audit user privileges to ensure security.

# 12. Backups
Creating a Backup
Backups are essential for data protection and recovery in case of failures.

Example: Full Database Backup
```sql
mysqldump -u root -p CompanyDB > CompanyDB_backup.sql
````
Restoring a Backup
You can restore a database from a backup file:


```sql
mysql -u root -p CompanyDB < CompanyDB_backup.sql
````
Automating Backups with a Script
You can automate backups using a cron job on Unix-based systems:

Create a backup script (backup.sh):
```sql
#!/bin/bash
mysqldump -u root -pYOURPASSWORD CompanyDB > /path/to/backup/CompanyDB_$(date +\%F).sql


````
Make the script executable:

```sql
chmod +x backup.sh


````
Schedule the backup script using cron:

```sql
crontab -e


````


Add a line to run the script daily at midnight:

```sql
0 0 * * * /path/to/backup.sh


````
