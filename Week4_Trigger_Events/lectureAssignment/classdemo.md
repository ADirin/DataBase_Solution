# SQL Implementation Instructions in HeidiSQL


´´´mermaid
sequenceDiagram
    participant User
    participant Database
    participant SP as Stored Procedure
    participant Trigger
    participant Event as Scheduled Event

    User->>Database: Insert into enrollments
    Database->>Trigger: After Insert Trigger Fires
    Trigger->>Database: Update total_courses in students

    Event->>SP: Daily Scheduled Execution
    SP->>Database: Update total_courses in students

    Note over Trigger, SP: Both update the total_courses field


´´´

## 1. Create the `student` Table
**Description:** Create a table named `student` with the following columns:
- `Fname` (VARCHAR(50))
- `Lname` (VARCHAR(50))
- `Address` (VARCHAR(100))
- `City` (VARCHAR(50))
- `Marks` (INT)

**SQL Code:**
```sql
CREATE TABLE student (
    Fname VARCHAR(50),
    Lname VARCHAR(50),
    Address VARCHAR(100),
    City VARCHAR(50),
    Marks INT
);
```
```sql
INSERT INTO student (Fname, Lname, Address, City, Marks) 
VALUES ('Timo', 'S', 'Vaasa', 'xxkatu', 20);
```
## 2. Create the sample_trigger Trigger
Description: Create a BEFORE INSERT trigger named sample_trigger to add 100 to the Marks value of a new record before it is inserted into the student table.

SQL Code:
```sql
CREATE TRIGGER sample_trigger
BEFORE INSERT ON student
FOR EACH ROW
SET NEW.Marks = NEW.Marks + 100;
```
## 3. Insert a Record into the student Table
Description: Insert a record into the student table with the following values:

SQL Code:
```sql
INSERT INTO student (Fname, Lname, Address, City, Marks) 
VALUES ('Kirsi', 'S', 'Vaasa', 'xxkatu', 20);
```
## 4. Select Records to Check if 100 is Added
Description: Select all records from the student table to verify that 100 has been added to the Marks column for the inserted record.

SQL Code:
```sql
SELECT * FROM student;
```

## 5. Create the final_marks Table
Description: Create a table named final_marks with the following columns:
```sql
id (INT, AUTO_INCREMENT, PRIMARY KEY)
total_marks (INT)
SQL Code:
```
SQL
```sql
CREATE TABLE final_marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    total_marks INT
);
```
## 6. Create the total_mark Trigger
Description: Create an AFTER INSERT trigger named total_mark to insert the Marks value from a new record in the student table into the final_marks table.

SQL Code:
```sql
CREATE TRIGGER total_mark
AFTER INSERT ON student
FOR EACH ROW
INSERT INTO final_marks (total_marks) 
VALUES (NEW.Marks);
```
## 7. (Optional) Add total_marks to student Table
Description: This step is not needed as total_marks is handled in the final_marks table.

## 8. Create the cal Trigger
Description: (Only if necessary) Create an additional AFTER INSERT trigger named cal to insert the Marks value into the final_marks table. This is redundant if total_mark trigger is already present.

SQL Code:
```sql
CREATE TRIGGER cal
AFTER INSERT ON student
FOR EACH ROW
INSERT INTO final_marks (total_marks) 
VALUES (NEW.Marks);
AI-generated code. Review and use carefully. More info on FAQ.
## 9. Insert Another Record into the student Table
Description: Insert another record into the student table with the following values:
```
SQL Code:
```sql
INSERT INTO student (Fname, Lname, Address, City, Marks) 
VALUES ('Timo', 'S', 'Vaasa', 'xxkatu', 20);
```

## 10. Select Records from final_marks
SQL Code:

```sql
SELECT * FROM final_marks;

```

## Example: Creating an Event
Description: Create an event that runs every day and adds 10 marks to all students whose Marks are below 50.

SQL Code:
```sql
CREATE EVENT update_student_marks
ON SCHEDULE EVERY 1 DAY
DO
  UPDATE student
  SET Marks = Marks + 10
  WHERE Marks < 50;

```
## Example 2: Creating Another Event
Description: Create an event that runs daily and checks if any student’s marks in the student table are above 100. If so, it inserts those marks into the final_marks table.

SQL Code:
```sql
CREATE EVENT insert_high_marks
ON SCHEDULE EVERY 1 DAY
DO
  INSERT INTO final_marks (total_marks)
  SELECT Marks FROM student
  WHERE Marks > 100;
```
Stored Procedure for Manual Insertion
Description: The stored procedure will be used to manually insert the marks of students who have more than 100 marks into the final_marks table.

SQL Code:
```sql
DELIMITER //

CREATE PROCEDURE InsertHighMarks()
BEGIN
    -- Insert marks into final_marks if marks > 100
    INSERT INTO final_marks (total_marks)
    SELECT Marks FROM student
    WHERE Marks > 100;
END //

DELIMITER ;
```

- **CALL InsertHighMarks();**
- **SELECT * FROM final_marks;**
