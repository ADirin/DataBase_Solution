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
Choose the right SQL functions for better performance.

```sql
-- Inefficient query
SELECT * FROM orders WHERE SUBSTRING(customer_id, 1, 3) = 'ABC';

-- Optimized query using LIKE
SELECT * FROM orders WHERE customer_id LIKE 'ABC%';

```
## Avoiding SELECT *
Select only the columns you need.

```sql
-- Inefficient query
SELECT * FROM employees;

-- Optimized query
SELECT id, name, department FROM employees;
```

# Transactions
Transactions ensure that a series of SQL operations are executed in a safe, reliable manner. Transactions have ACID properties: Atomicity, Consistency, Isolation, Durability.


## Starting and Committing a Transaction

-- Start a transaction
START TRANSACTION;

```sql
-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Commit the transaction
COMMIT;
```

## Rolling Back a Transaction

-- Start a transaction
START TRANSACTION;
```sql
-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Rollback the transaction if something goes wrong
ROLLBACK;
```

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



