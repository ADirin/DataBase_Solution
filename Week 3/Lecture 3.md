# Database Concurrency Learning Material

## Table of Contents
1. [Introduction to Concurrency](#introduction-to-concurrency)
2. [Concurrency Management](#concurrency-management)
3. [Concurrency Techniques](#concurrency-techniques)
4. [Importance of Handling Concurrency](#importance-of-handling-concurrency)
5. [Race Conditions](#race-conditions)
6. [Concept of View](#concept-of-view)

## Introduction to Concurrency

Concurrency in databases refers to the ability of the database to allow multiple transactions to access the same data concurrently, which helps in maximizing performance and ensuring that users can perform operations without significant delays.

## Concurrency Management

Concurrency management involves techniques and mechanisms to handle the simultaneous execution of transactions in a way that maintains the consistency and integrity of the database.

### Locking Mechanisms

MariaDB provides various types of locks to ensure data integrity. Here are some examples:

```sql

-- Perform operations
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;

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
Concurrency Techniques
Different techniques are used to manage concurrency in databases:

Pessimistic Locking
Involves locking the data when a transaction starts so that other transactions cannot access it until the lock is released.

Optimistic Locking
Allows multiple transactions to access the same data concurrently but checks for conflicts before committing changes.

Timestamp Ordering
Transactions are ordered based on timestamps to ensure that older transactions are given priority.

Importance of Handling Concurrency
Handling concurrency is crucial for several reasons:

Data Integrity: Ensures that data remains accurate and consistent even when accessed by multiple transactions simultaneously.
Performance: Improves the performance and responsiveness of the database system.
User Experience: Provides a smooth and seamless experience for users by allowing multiple operations to occur concurrently.


# Race Conditions
Race conditions occur when two or more transactions simultaneously access and modify the same data, leading to unexpected results and data inconsistencies.

## Example of Handling Race Conditions
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

# Concept of View
A view in a database is a virtual table created based on a SQL query. It can be used to simplify complex queries, provide a layer of security, and manage data more efficiently.

## Creating and Using Views
```sql
-- Creating a view to simplify a complex query
CREATE VIEW customer_orders AS
SELECT customers.name, orders.order_date, orders.amount
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id;

-- Using the view to fetch data
SELECT * FROM customer_orders WHERE name = 'John Doe';
```
By understanding and implementing these concepts, you can effectively manage concurrency in MariaDB, ensuring data integrity, improving performance, and providing a better user experience.

---------------------------------------------------------

# Understanding Concurrency Control in Databases

Concurrency control is crucial in databases to ensure the consistency and integrity of data when multiple transactions are executed simultaneously. This document explores three key mechanisms used to manage concurrency: locks, versioning, and views.

## 1. Locks

Locks are a fundamental mechanism used to manage concurrent access to database resources. They prevent multiple transactions from conflicting with each other when accessing the same data.

### Types of Locks

- **Shared Lock (S):** Allows multiple transactions to read (but not modify) the same data simultaneously.
- **Exclusive Lock (X):** Prevents other transactions from reading or modifying the data. Only one transaction can hold an exclusive lock on a piece of data.

### Example

Consider a scenario where two transactions, T1 and T2, need to update a bank account balance.

**Initial State:**
- Account balance: $1000

**Transaction T1:**
1. `BEGIN TRANSACTION`
2. `SELECT balance FROM accounts WHERE account_id = 1` — Acquires a Shared Lock.
3. `UPDATE accounts SET balance = balance - 100 WHERE account_id = 1` — Upgrades to an Exclusive Lock.
4. `COMMIT`

**Transaction T2:**
1. `BEGIN TRANSACTION`
2. `SELECT balance FROM accounts WHERE account_id = 1` — Must wait until T1 releases the lock.
3. `UPDATE accounts SET balance = balance + 50 WHERE account_id = 1` — Cannot proceed until T1 commits.

In this example, T2 has to wait until T1 completes, ensuring that the balance is updated correctly and no intermediate results are visible.


## Exclusive Lock (X)
Purpose: Prevents other transactions from reading or modifying the data. This lock is used when a transaction needs to modify data, ensuring that no other transactions can access the data concurrently.

Behavior:

- Only one transaction can hold an exclusive lock on a particular piece of data at a time.
- Other transactions are blocked from acquiring either shared or exclusive locks on the same data until the exclusive lock is released.

Example:
Transaction T1 acquires an exclusive lock on a specific employee record to update it. While T1 is holding the lock, Transaction T2 cannot read or modify the same employee record.

SQL Example:

```sql
BEGIN TRANSACTION;
UPDATE employees SET salary = salary + 5000 WHERE employee_id = 123; -- Exclusive lock acquired
COMMIT;
````

## Intent Locks
Purpose: Used to signal a transaction’s intention to acquire a shared or exclusive lock at a finer granularity (such as a row-level or page-level lock). Intent locks help manage hierarchical locking by coordinating lock requests at different levels.

Types:

- Intent Shared Lock (IS): Indicates that a transaction intends to acquire a shared lock on some lower-level data.
- Intent Exclusive Lock (IX): Indicates that a transaction intends to acquire an exclusive lock on some lower-level data.
  
Behavior:
- An intent lock at a higher level (e.g., table-level) prevents other transactions from acquiring conflicting locks at lower levels (e.g., row-level).

Example:
- Transaction T1 wants to acquire a shared lock on specific rows within a table. Before acquiring the row-level locks, it first acquires an intent shared lock at the table level.

SQL Example:

```sql
BEGIN TRANSACTION;
-- Intent locks are typically managed by the DBMS and not explicitly specified in SQL

````

## Lock Granularity
Locks can be applied at different levels of granularity, each affecting the concurrency and complexity of locking:

### 1. Row-Level Locking
Purpose: Locks individual rows within a table, allowing multiple transactions to access different rows of the same table concurrently.

Advantages:
- Higher concurrency as only specific rows are locked.
- Allows transactions to work with different parts of the data simultaneously.

Disadvantages:
- More complex management and overhead due to numerous locks.

Example:
- Transaction T1 locks rows where department = 'Sales' to update employee salaries, while Transaction T2 can still access other rows in the same table.

SQL Example:

```sql
BEGIN TRANSACTION;
UPDATE employees SET salary = salary + 5000 WHERE employee_id = 123; -- Row-level lock
COMMIT;
````

### 2. Page-Level Locking
Purpose: Locks a page, which is a block of rows, rather than individual rows. This strikes a balance between concurrency and management complexity.

Advantages:
- Reduces the number of locks needed compared to row-level locking.
- Simplifies management compared to locking each row individually.

Disadvantages:
- Can lead to reduced concurrency if multiple transactions need to access different rows within the same page.

Example:
- Transaction T1 locks a page containing several rows to update multiple employees, which might block Transaction T2 from accessing any row on that page.
SQL Example:

```sql
BEGIN TRANSACTION;
UPDATE employees SET salary = salary + 5000 WHERE department = 'Sales'; -- Page-level lock
COMMIT;

````

### 3. Table-Level Locking
Purpose: Locks the entire table, preventing any other transactions from accessing the table until the lock is released.

Advantages:
- Simplest form of locking with minimal management overhead.
- Guarantees no other transactions can access the table during the lock.

Disadvantages:
- Significantly reduces concurrency as the entire table is locked.

Example:
- Transaction T1 locks the entire employees table to perform batch updates, blocking Transaction T2 from accessing any part of the table.

SQL Example:

```sql
BEGIN TRANSACTION;
UPDATE employees SET salary = salary + 5000; -- Table-level lock
COMMIT;

````
# Lock Management and Deadlocks
Deadlocks
A deadlock occurs when two or more transactions are waiting indefinitely for each other to release locks. To manage deadlocks, databases employ strategies such as:
- Deadlock Detection: The DBMS periodically checks for deadlocks and resolves them by aborting one of the transactions.
- Deadlock Prevention: The DBMS may prevent deadlocks by ensuring that transactions acquire locks in a predefined order or by using timeouts.

Example:
- Transaction T1 holds a lock on A and waits for a lock on B.
- Transaction T2 holds a lock on B and waits for a lock on A.

The DBMS detects this circular wait and resolves the deadlock by aborting one of the transactions.

## 2. Versioning

Versioning allows multiple versions of data to exist simultaneously, providing a consistent view of data without locking. This approach is often implemented using Multiversion Concurrency Control (MVCC).

### Example

Consider a database that uses MVCC to handle concurrent transactions.

**Initial State:**
- Account balance: $1000

**Transaction T1:**
1. `BEGIN TRANSACTION`
2. `SELECT balance FROM accounts WHERE account_id = 1` — Views the balance as $1000.
3. `UPDATE accounts SET balance = balance - 100 WHERE account_id = 1` — Creates a new version of the row with the updated balance.
4. `COMMIT`

**Transaction T2:**
1. `BEGIN TRANSACTION`
2. `SELECT balance FROM accounts WHERE account_id = 1` — Views the original balance ($1000) because T2 started before T1 committed.
3. `UPDATE accounts SET balance = balance + 50 WHERE account_id = 1` — Creates a new version with the updated balance.
4. `COMMIT`

In this scenario, T2 sees the balance as it was before T1 started, ensuring a consistent view of the data.





## 3. Views

Views provide a way to simplify data access and control concurrency by presenting a virtual table based on the results of a query. Views can help manage how data is presented to users and ensure that changes are isolated from others.

### Example

Consider a database with an `employees` table. We want to create a view to show only active employees.

**Initial State:**
- `employees` table contains columns: `employee_id`, `name`, `status`.

**Create View:**

```sql
CREATE VIEW active_employees AS
SELECT employee_id, name
FROM employees
WHERE status = 'active';
