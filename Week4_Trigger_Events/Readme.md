# MySQL Learning Material: Triggers, Stored Procedures, and Events

## Table of Contents
1. [Introduction](#introduction)
2. [Database Triggers](#database-triggers)
    - [What is a Trigger?](#what-is-a-trigger)
    - [Creating a Trigger](#creating-a-trigger)
    - [Example](#example-trigger)
3. [Stored Procedures](#stored-procedures)
    - [What is a Stored Procedure?](#what-is-a-stored-procedure)
    - [Creating a Stored Procedure](#creating-a-stored-procedure)
    - [Example](#example-stored-procedure)
4. [Events](#events)
    - [What is an Event?](#what-is-an-event)
    - [Creating an Event](#creating-an-event)
    - [Example](#example-event)
5. [Conclusion](#conclusion)

## Introduction
This guide covers the basics of database triggers, stored procedures, and events in MySQL. These concepts are essential for managing automated tasks and ensuring data integrity in your databases.

## Database Triggers

### What is a Trigger?
A trigger is a database object that is automatically executed or fired when certain events occur. Triggers can be defined to execute before or after an `INSERT`, `UPDATE`, or `DELETE` operation on a table.

### Creating a Trigger
To create a trigger in MySQL, you can use the `CREATE TRIGGER` statement. The syntax is:

```sql
CREATE TRIGGER trigger_name
{ BEFORE | AFTER } { INSERT | UPDATE | DELETE }
ON table_name FOR EACH ROW
trigger_body;
```
```sql
--starts the creation of a new trigger and assigns it as name, Trigger_Nameof 
CREATE TRIGGER Trigger_Name

--this line specifies when the TRIGGER will be executed about the EVENTS, for example BEFORE an insertion OR UPDATE OR AFTER the insertion...
(BEFORE | AFTER)

--this line defines the TYPE OF operation that TRIGGERS the execution of the TRIGGER, meaning that TRIGGER will be executed when an INSERT, UPDATE, or DELETE happens
[INSERT | UPDATE | DELETE]

--The TABLE IN which the TRIGGER will be defined
ON[TABLE_NAME]

--this line defines whether the TRIGGER should be executed FOR EACH ROW affected BY triggering EVENT  OR FOR EACH column
[for EACH ROW | FOR EACH COLUMN]

-- the following contains one or more SQL statements enclosed with BEGIN---END
[Trigger_body]

```



Example Trigger
Let's create a trigger that automatically updates the last_updated column to the current timestamp whenever a record is updated in the employees table.
```sql
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
SET NEW.last_updated = NOW();
```
Stored Procedures
What is a Stored Procedure?
A stored procedure is a set of SQL statements that can be stored in the database and executed repeatedly. Stored procedures allow for more complex operations than a single SQL statement and can include control structures such as loops and conditionals.

Creating a Stored Procedure
To create a stored procedure in MySQL, use the CREATE PROCEDURE statement. The syntax is:

```sql
CREATE PROCEDURE procedure_name (parameters)
BEGIN
    -- procedure body
END;

```

Example Stored Procedure
Let's create a stored procedure that inserts a new employee into the employees table.
```sql
CREATE PROCEDURE AddEmployee(
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN hire_date DATE
)
BEGIN
    INSERT INTO employees (first_name, last_name, hire_date)
    VALUES (first_name, last_name, hire_date);
END;


```

Events
What is an Event?
An event in MySQL is a scheduled task that runs automatically at specified intervals. Events are useful for tasks such as cleaning up old data, sending notifications, or generating reports.

Creating an Event
To create an event in MySQL, use the CREATE EVENT statement. The syntax is:

```sql
CREATE EVENT event_name
ON SCHEDULE schedule
DO
event_body;


```
Example Event
Let's create an event that deletes records older than one year from the logs table every day at midnight.

```sql
CREATE EVENT cleanup_old_logs
ON SCHEDULE EVERY 1 DAY
STARTS '2024-01-01 00:00:00'
DO
DELETE FROM logs WHERE log_date < NOW() - INTERVAL 1 YEAR;



```
Conclusion
Understanding and using triggers, stored procedures, and events in MySQL can significantly enhance the functionality and performance of your database applications. These tools allow you to automate tasks, enforce data integrity, and handle complex operations more efficiently.


