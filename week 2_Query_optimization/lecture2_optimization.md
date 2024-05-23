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

-- Original query
SELECT * FROM orders WHERE YEAR(order_date) = 2023;

-- Optimized query
SELECT * FROM orders WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01';

-- Inefficient query
SELECT * FROM orders WHERE SUBSTRING(customer_id, 1, 3) = 'ABC';

-- Optimized query using LIKE
SELECT * FROM orders WHERE customer_id LIKE 'ABC%';

-- Inefficient query
SELECT * FROM employees;

-- Optimized query
SELECT id, name, department FROM employees;


-- Start a transaction
START TRANSACTION;

-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Commit the transaction
COMMIT;


-- Start a transaction
START TRANSACTION;

-- Perform some SQL operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- Rollback the transaction if something goes wrong
ROLLBACK;

-- Explicit locking
LOCK TABLES accounts WRITE;

-- Perform operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;

-- Unlock tables
UNLOCK TABLES;
-- Setting the isolation level to REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Start a transaction
START TRANSACTION;

-- Perform operations
SELECT * FROM accounts WHERE account_id = 1;

-- Commit the transaction
COMMIT;
-- Transaction 1
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
-- Waits for Transaction 2 to release the lock

-- Transaction 2
START TRANSACTION;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
-- Waits for Transaction 1 to release the lock

-- MariaDB will detect the deadlock and roll back one of the transactions


