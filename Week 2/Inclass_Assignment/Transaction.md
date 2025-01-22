# Database table query: Projections, Selection, Cartaisian Products
## Exercise: SQL Queries for Projections, Selections, and Cartesian Products
This exercise demonstrates how to apply Projections, Selections, and Cartesian Products using the Accounts and Transactions tables.

### Step 1: Insert Sample Data
Populate the tables with sample data:

**Accounts Table**

```sql
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolderName VARCHAR(100),
    Balance DECIMAL(10, 2)
); 

```
```sql

INSERT INTO Accounts (AccountID, AccountHolderName, Balance) VALUES
(1, 'Alice', 5000.00),
(2, 'Bob', 3000.50),
(3, 'Carol', 1500.75);


```
```sql
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    FromAccountID INT,
    ToAccountID INT,
    Amount DECIMAL(10, 2),
    Status VARCHAR(10)
);



```


**Transactions Table**

```sql
INSERT INTO Transactions (TransactionID, FromAccountID, ToAccountID, Amount, Status) VALUES
(101, 1, 2, 1000.00, 'Completed'),
(102, 2, 3, 500.50, 'Pending'),
(103, 1, 3, 2000.75, 'Completed');


```

## Step 2: Queries Demonstrating Projections, Selections, and Cartesian Products
**1. Projection**
Retrieve specific columns from one table.

*Exercise Question:*
Write a query to display the AccountHolderName and Balance of all accounts.

Expected Query:

```sql
SELECT AccountHolderName, Balance FROM Accounts;
```

**2. Selection**
Retrieve rows that meet a condition.

*Exercise Question:*
Write a query to find all transactions with a status of 'Completed'.

Expected Query:
```sql
SELECT * FROM Transactions WHERE Status = 'Completed';

```

**3. Cartesian Product**
Combine all rows from both tables (useful for exploration but usually requires a JOIN for meaningful results).

*Exercise Question:*
Write a query to produce a Cartesian product of Accounts and Transactions (all combinations of rows).

Expected Query:

```sql
SELECT * FROM Accounts, Transactions;

```


What is the output of the follwoing query?

```sql
explain SELECT * FROM Accounts, Transactions;

```



**4. Combining Projection and Selection**
*Exercise Question:*
Write a query to display the AccountHolderName and Balance of accounts with a balance greater than 2000.00.

Expected Query:
```sql
SELECT AccountHolderName, Balance FROM Accounts WHERE Balance > 2000.00;

```

**5. Joining for a Meaningful Result**
Cartesian products are often used with conditions to create meaningful results.

*Exercise Question:*
Write a query to display transaction details along with the AccountHolderName for the FromAccountID.

Expected Query:
```sql
SELECT 
    Transactions.TransactionID,
    Accounts.AccountHolderName AS FromAccountHolder,
    Transactions.Amount,
    Transactions.Status
FROM 
    Transactions
JOIN 
    Accounts
ON 
    Transactions.FromAccountID = Accounts.AccountID;


```

## Submission
**NOte:** Similar to the previous in-class assignment, you need to take screenshots and include the corresponding queries in a file and submit in a designated folder in moodle.


------------------------
# Database Transaction Example

## Tables

### Table 1: `Accounts`
This table stores information about users' bank accounts.

```sql
-- Table: Accounts
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolderName VARCHAR(100),
    Balance DECIMAL(10, 2)
);
````
-- Initial Data in Accounts Table

````sql
INSERT INTO Accounts (AccountID, AccountHolderName, Balance)
VALUES (1, 'John Doe', 1000),
       (2, 'Jane Smith', 1500),
       (3, 'Alice Johnson', 2000);

````
       
| AccountID | AccountHolderName | Balance |
|-----------|-------------------|---------|
| 1         | John Doe          | 1000    |
| 2         | Jane Smith        | 1500    |
| 3         | Alice Johnson     | 2000    |




### Table 2: `Transactions`

````sql
-- Table: Transactions
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    FromAccountID INT,
    ToAccountID INT,
    Amount DECIMAL(10, 2),
    Status VARCHAR(10)
);

````
````sql
-- Initial Data in Transactions Table
INSERT INTO Transactions (TransactionID, FromAccountID, ToAccountID, Amount, Status)
VALUES (1, 1, 2, 200, 'Pending'),
       (2, 3, 1, 500, 'Pending');

````


This table records transactions between accounts.

| TransactionID | FromAccountID | ToAccountID | Amount | Status  |
|---------------|---------------|-------------|--------|---------|
| 1             | 1             | 2           | 200    | Pending |
| 2             | 3             | 1           | 500    | Pending |

## Example Transaction Scenario

Let's say John Doe (AccountID 1) wants to transfer $200 to Jane Smith (AccountID 2). This operation involves two steps:
1. Deduct $200 from John Doe's account.
2. Add $200 to Jane Smith's account.

### Before Transaction

**Accounts Table:**

-- Accounts Table Before Transaction
````sql
SELECT * FROM Accounts;
````


| AccountID | AccountHolderName | Balance |
|-----------|-------------------|---------|
| 1         | John Doe          | 1000    |
| 2         | Jane Smith        | 1500    |
| 3         | Alice Johnson     | 2000    |

**Transactions Table:**

````sql
SELECT * FROM Accounts;
````

| TransactionID | FromAccountID | ToAccountID | Amount | Status  |
|---------------|---------------|-------------|--------|---------|
| 1             | 1             | 2           | 200    | Pending |
| 2             | 3             | 1           | 500    | Pending |

### During Transaction (Atomicity in Action)

Suppose the transaction starts:

1. **Deduct $200 from John Doe's account:**

-- Deducting $200 from John Doe's account

````sql
UPDATE Accounts
SET Balance = Balance - 200
WHERE AccountID = 1;
````

-- New balance should be $800


-- New balance should be $1700
   - New balance: $1000 - $200 = $800
2. **Add $200 to Jane Smith's account:**
-- Adding $200 to Jane Smith's account

````sql
UPDATE Accounts
SET Balance = Balance + 200
WHERE AccountID = 2;
````
     - New balance: $1500 + $200 = $1700

However, imagine a system failure occurs between these two operations.

### After Successful Transaction (Commit)

If the transaction completes successfully, the tables would be updated as follows:
````sql

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 200
WHERE AccountID = 1;

-- Check for errors here; if none, continue
-- In a script, you would check for success of the above command

UPDATE Accounts
SET Balance = Balance + 200
WHERE AccountID = 2;

-- Check for errors again; if none, commit
COMMIT;

-- If any errors were detected, instead of committing, you would:
-- ROLLBACK;


````
Step 1 (Read Operation)
When the balance of John Doe's account is read, the transaction fetches the current value from the database. This read is consistent within the scope of the transaction.

Step 2 (Write Operation)
The balance of John Doe’s account is updated. This change is not visible to other transactions until this transaction is committed, depending on the isolation level.

Step 3 (Read Operation)
The balance of Jane Smith's account is read. It will reflect the value before the current transaction’s write operation.

Step 4 (Write Operation)
The balance of Jane Smith's account is updated. Like the previous write operation, this change is also not visible to other transactions until the transaction commits.

COMMIT
Once the transaction is committed, all the changes made (write operations) during the transaction become permanent and visible to other transactions.
**Accounts Table:**

| AccountID | AccountHolderName | Balance |
|-----------|-------------------|---------|
| 1         | John Doe          | 600     |
| 2         | Jane Smith        | 1900    |
| 3         | Alice Johnson     | 2000    |



### After Transaction Failure (Rollback)

Due to the failure, the database performs a rollback to maintain consistency:

````sql
-- Start the transaction
START TRANSACTION;

-- Step 1: Deduct $200 from John Doe's account
UPDATE Accounts
SET Balance = Balance - 200
WHERE AccountID = 1;

-- Simulate an error: try to update a non-existent account
-- This will cause an error because AccountID 999 doesn't exist
UPDATE Accounts
SET Balance = Balance + 200
WHERE AccountID = 999;

-- Since the above command fails, you should now rollback
ROLLBACK;

-- Check the results after rollback
SELECT * FROM Accounts;

-- Notice that no changes were made to the table, as the transaction was rolled back.


-- Accounts Table After Rollback
SELECT * FROM Accounts;

-- Output:

**Accounts Table:**

| AccountID | AccountHolderName | Balance |
|-----------|-------------------|---------|
| 1         | John Doe          | 600   |
| 2         | Jane Smith        | 1900    |
| 3         | Alice Johnson     | 2000    |
````


**Transactions Table:**

````sql
-- Transactions Table After Rollback
UPDATE Transactions
SET Status = 'Failed'
WHERE TransactionID = 1;

SELECT * FROM Transactions;

````



| TransactionID | FromAccountID | ToAccountID | Amount | Status  |
|---------------|---------------|-------------|--------|---------|
| 1             | 1             | 2           | 200    | Failed  |
| 2             | 3             | 1           | 500    | Pending |



**Transactions Table:**

````sql
-- Transactions Table After Commit
UPDATE Transactions
SET Status = 'Success'
WHERE TransactionID = 1;

SELECT * FROM Transactions;

-- Output:
````


| TransactionID | FromAccountID | ToAccountID | Amount | Status  |
|---------------|---------------|-------------|--------|---------|
| 1             | 1             | 2           | 200    | Success |
| 2             | 3             | 1           | 500    | Pending |

## Key Concepts Illustrated

1. **Atomicity**: The transaction either completes fully or not at all.
2. **Consistency**: The database remains in a consistent state before and after the transaction.
3. **Isolation**: Intermediate states are not visible to other transactions.
4. **Durability**: Once the transaction is committed, the changes persist even if there's a failure afterward.

----------------------------------



