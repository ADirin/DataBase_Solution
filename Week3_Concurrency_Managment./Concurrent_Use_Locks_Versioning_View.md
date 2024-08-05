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

# 1. Row-Level Locking
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

# 2. Page-Level Locking
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

# 3. Table-Level Locking
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
