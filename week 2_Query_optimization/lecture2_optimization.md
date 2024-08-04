# MariaDB Learning Material

## Table of Contents
1. [Query Optimization](#query-optimization)
2. [Transactions](#transactions)
3. [Concurrency Management](#concurrency-management)

## Query Optimization

Query optimization in MariaDB involves improving the performance of SQL queries to ensure they run as efficiently as possible. Here are some techniques and examples:

### Indexing

Indexes improve query performance by allowing the database to find rows more quickly.

```sql
-- Creating an index on a column
CREATE INDEX idx_customer_name ON customers (name);

-- Using EXPLAIN to analyze query performance
EXPLAIN SELECT * FROM customers WHERE name = 'John Doe';

```

## Query Refactoring
Query refactoring involves modifying a database query to improve its performance, maintainability, readability, or to adapt to changes in the database schema, without changing the query's output or functionality. This process is essential in database optimization and management, especially in complex systems where performance and scalability are critical.

```sql
-- Original query
SELECT * FROM orders WHERE YEAR(order_date) = 2023;
 
-- Optimized query
SELECT * FROM orders WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01';
```
or

```sql
-- Original query using subquery
SELECT name FROM Employees WHERE department_id = 
    (SELECT id FROM Departments WHERE name = 'HR');

-- Refactored query using a join
SELECT e.name FROM Employees e
JOIN Departments d ON e.department_id = d.id
WHERE d.name = 'HR';
```



## Use of Appropriate SQL Functions
Defining an appropriate SQL function involves creating a reusable block of code that performs a specific task or calculation in your database. 
SQL functions can be categorized into scalar functions (which return a single value) and table-valued functions (which return a table). 
Functions are often used for encapsulating logic that you want to reuse across multiple queries.

Choose the right SQL functions for better performance.

```sql
-- Inefficient query
SELECT * FROM orders WHERE SUBSTRING(customer_id, 1, 3) = 'ABC';

-- Optimized query using LIKE
SELECT * FROM orders WHERE customer_id LIKE 'ABC%';

```
## Avoiding SELECT *
Avoiding the SELECT statement in SQL refer to situations where you need to optimize performance, avoid redundant data retrieval, or adhere to certain database constraints. 
Select only the columns you need.

```sql
-- Inefficient query
SELECT * FROM employees;

-- Optimized query
SELECT id, name, department FROM employees;
```

# Transactions
A transaction in a database context is a sequence of one or more SQL operations (such as `INSERT`, `UPDATE`, `DELETE`, or `SELECT` statements) that are executed as a single unit of work. Transactions ensure that a series of operations are completed successfully and consistently, even in the presence of system failures or other concurrent operations. If any part of the transaction fails, the entire transaction can be rolled back to ensure the database remains in a consistent state.

## Key Properties of Transactions: ACID

Transactions are defined by four key properties, commonly referred to as ACID:

### Atomicity
The transaction is indivisible; it is either fully completed or not at all. If any part of the transaction fails, the entire transaction is rolled back, and the database is left unchanged.

**Example:** If a bank transaction involves transferring money from one account to another, atomicity ensures that either both the debit and credit occur, or neither does.

### Consistency
A transaction brings the database from one consistent state to another. Consistency ensures that all database rules (such as integrity constraints) are maintained after the transaction completes.

**Example:** If a transaction violates a database constraint, such as a foreign key constraint, the transaction will be rolled back, preserving the database's consistent state.

### Isolation
Transactions are isolated from each other, meaning that the intermediate results of a transaction are not visible to other transactions until the transaction is completed. This prevents concurrent transactions from interfering with each other.

**Example:** If two users are making changes to the same data concurrently, isolation ensures that one user’s changes do not affect the other’s operations until the first transaction is committed.

### Durability
Once a transaction is committed, its results are permanently recorded in the database, even in the event of a system failure. This means the committed data will survive crashes, power loss, or other issues.

**Example:** After a financial transaction is committed, the changes are permanently saved, and the system can recover this information even after a crash.



## Starting and Committing a Transaction

-- Start a transaction

```sql
BEGIN TRANSACTION;
```
Transaction Execution:
```sql
-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Commit the transaction
COMMIT;
```

## Rolling Back a Transaction
If any operation within the transaction fails or if an error is detected, the transaction can be rolled back using the ROLLBACK statement. 
This undoes all changes made during the transaction, ensuring the database remains in a consistent state.

-- Start a transaction
START TRANSACTION;
```sql
-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Rollback the transaction if something goes wrong
ROLLBACK;
```

# Example Scenario
Imagine a simple banking system where money is transferred from one account to another:

```sql
BEGIN TRANSACTION;

UPDATE Accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE Accounts SET balance = balance + 100 WHERE account_id = 2;

IF @@ERROR = 0
   COMMIT;
ELSE
   ROLLBACK;


```
In this example:

- The transaction begins with `BEGIN TRANSACTION`.
- Two `UPDATE` operations transfer money between accounts.
- If both updates succeed (`IF @@ERROR = 0` checks for errors), the transaction is committed, making the changes permanent.
- If an error occurs, the transaction is rolled back, undoing all changes.

# Concurrency Management
Concurrency management involves handling the simultaneous execution of transactions in a multi-user database environment. 
MariaDB uses locking mechanisms and isolation levels to manage concurrency.


## Locking Mechanisms
MariaDB provides various types of locks to ensure data integrity.

```sql
-- Explicit locking
LOCK TABLES accounts WRITE;

-- Perform operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;

-- Unlock tables
UNLOCK TABLES;
```
## Isolation Levels
Isolation levels define the degree to which the operations in one transaction are isolated from those in other transactions.

```sql
-- Setting the isolation level to REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Start a transaction
START TRANSACTION;

-- Perform operations
SELECT * FROM accounts WHERE account_id = 1;

-- Commit the transaction
COMMIT;
```

# Example of Handling Deadlocks
Deadlocks occur when two or more transactions are waiting for each other to release locks.

```sql
-- Transaction 1
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
-- Waits for Transaction 2 to release the lock

-- Transaction 2
START TRANSACTION;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
-- Waits for Transaction 1 to release the lock

-- MariaDB will detect the deadlock and roll back one of the transactions
```
By understanding and implementing these concepts, you can optimize query performance, manage transactions effectively, and handle concurrency in MariaDB to ensure your database operations are efficient and reliable.

This single Markdown file can be used in a GitHub repository to provide comprehensive learning material on query optimization, transactions, and concurrency management in MariaDB.



