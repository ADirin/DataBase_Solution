# SQL Implementation Instructions in HeidiSQL

````mermaid
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
````

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
---------------------------------------------------------------------

# Second Example

Create the Database and Tables:

Use the provided SQL statements to set up the database and tables.

````mermaid
erDiagram
    students {
        INT student_id PK
        VARCHAR student_name
        INT total_courses
    }
    courses {
        INT course_id PK
        VARCHAR course_name
    }
    enrollments {
        INT enrollment_id PK
        INT student_id FK
        INT course_id FK
        DATE enrollment_date
    }

    students ||--o{ enrollments : ""
    courses ||--o{ enrollments : ""

````


```sql
-- Create the database
CREATE DATABASE SchoolDB;

-- Use the database
USE SchoolDB;

-- Create the students table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100),
    total_courses INT DEFAULT 0
);

-- Create the courses table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100)
);

-- Create the enrollments table (join table for students and courses)
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


```
First, check the initial state of the students table to see the starting values for total_courses.
```sql

SELECT * FROM students;

```
2. Test the BEFORE INSERT Trigger
Scenario: Add a new enrollment and verify that the total_courses for the corresponding student is incremented.
```sql
DELIMITER //

-- Trigger to update total_courses before a new enrollment is added
CREATE TRIGGER update_total_courses_before_insert
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    UPDATE students
    SET total_courses = total_courses + 1
    WHERE student_id = NEW.student_id;
END;
//

-- Trigger to update total_courses before an enrollment is deleted
CREATE TRIGGER update_total_courses_before_delete
BEFORE DELETE ON enrollments
FOR EACH ROW
BEGIN
    UPDATE students
    SET total_courses = total_courses - 1
    WHERE student_id = OLD.student_id;
END;
//

DELIMITER ;



```


```sql
-- Add a new enrollment for a student
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (1, 3, '2024-09-07');

-- Check the students table to verify that total_courses has been incremented
SELECT * FROM students;

```
Expected Outcome: The total_courses for the student with student_id = 1 should be increased by 1.

3. Test the After DELETE Trigger
Scenario: Create a trigger that updates the total_courses field in the students table when a record is deleted from the enrollments table.
```sql
DELIMITER //

CREATE TRIGGER update_total_courses_after_delete
AFTER DELETE ON enrollments
FOR EACH ROW
BEGIN
    UPDATE students
    SET total_courses = total_courses - 1
    WHERE student_id = OLD.student_id;
END;

DELIMITER ;
```
4. Test the Trigger

Delete an enrollment record and verify that the total_courses field in the students table is updated correctly.

```sql

-- Delete an enrollment for a student
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 3;

-- Check the students table to verify that total_courses has been decremented
SELECT * FROM students;


```
Expected Outcome: The total_courses for the student with student_id = 1 should be decreased by 1.

4. Additional Tests
Test 1: Insert and Delete Multiple Enrollments


```sql
-- Insert multiple enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (2, 3, '2024-09-07');
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (2, 4, '2024-09-08');

-- Check the students table
SELECT * FROM students;

-- Delete multiple enrollments
DELETE FROM enrollments WHERE student_id = 2 AND course_id = 3;
DELETE FROM enrollments WHERE student_id = 2 AND course_id = 4;

-- Check the students table
SELECT * FROM students;

```
Test 2: Edge Case - Deleting Non-Existent Enrollment
```sql
-- Try deleting an enrollment that does not exist
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 99;

-- Check the students table
SELECT * FROM students;

```
Test 3: Insert and Delete for Multiple Students
```sql
-- Insert enrollments for multiple students
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (1, 5, '2024-09-09');
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (2, 6, '2024-09-10');

-- Check the students table
SELECT * FROM students;

-- Delete enrollments for multiple students
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 5;
DELETE FROM enrollments WHERE student_id = 2 AND course_id = 6;

-- Check the students table
SELECT * FROM students;


```

Notes:
Verify Trigger Actions: Ensure that the changes in total_courses match the expected values after each operation.
Error Handling: If you encounter any issues, review the trigger definitions for errors or unintended logic. Also, check if there are any constraints or data integrity issues that might affect the triggers.
By performing these tests, you can confirm that your triggers are functioning as expected and handling various scenarios correctly.

_______________________________________________________________________________________________________________________________

# EVENT EXAMPLE
## Exercise: Automating Course Enrollment Counting Using MySQL Events
**Scenario:**

You are working with a school database, SchoolDB, which contains tables for students, courses, and enrollments. You need to create an automated system using MySQL events to update the total_courses field for each student daily. This field represents the total number of courses a student is currently enrolled in.

### Your task is to design and implement an event that will:

1. Run daily.
2. Calculate the total number of courses each student is enrolled in from the enrollments table.
3. Update the total_courses field in the students table with the new value.

### Step-by-Step Instructions:
1. USE THE SchoolDB

2. Task: Create a MySQL Event Your main task is to create a MySQL Event that will automatically update the total_courses for each student daily, based on the number of courses they are enrolled in.

**Hints:**

- Use the COUNT() function to determine how many courses a student is enrolled in.
- Join the students table with the enrollments table.
- Schedule the event to run every day.
3. Create the Event: Write the SQL to create the event:
```sql
-- Drop the existing event if it exists
DROP EVENT IF EXISTS update_student_courses;

-- Create the event
DELIMITER //

CREATE EVENT update_student_courses
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
COMMENT 'Update total courses for each student daily'
DO
BEGIN
    -- Update total_courses in the students table based on enrollments
    UPDATE students s
    JOIN (
        SELECT student_id, COUNT(course_id) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) e ON s.student_id = e.student_id
    SET s.total_courses = e.course_count;
END //

DELIMITER ;


```
```SQL
ERROR:
/* Varoitus: (1105) Event scheduler is switched off, use SET GLOBAL event_scheduler=ON to enable it. */
-- You Have to set the event scheduler
SET GLOBAL event_scheduler = ON;

```
5. Verify the Event:
- After creating the event, check if it’s listed in the information_schema:
```sql
SELECT * FROM information_schema.events WHERE event_name = 'update_student_courses';

```
- Manually trigger the event (for testing purposes) to ensure the total_courses field is correctly updated:
```sql
SET GLOBAL event_scheduler = ON;


```
6. Test the Result: Run a query to check if the total_courses field in the students table is updated with the correct values:
````sql
SELECT * FROM students;

`````
You should see the total_courses field reflect the number of courses each student is enrolled in, e.g., Alice should have 2, Bob should have 1, and Charlie should have 2.

## Student Questions:
1. What would happen if the event was scheduled to run every hour instead of every day?
2. How could you modify the event to only update students who have new enrollments (added today)?
3. What are some potential pitfalls of using events to update tables, and how can you mitigate them?
_____________________________________________________________________________________________________________________________
Here’s an example of how you can create a stored procedure for your SchoolDB database. In this case, we will create a procedure called enroll_student_in_course to automate the process of enrolling a student in a course and updating their total courses.
# 1. Stored Procedure Example:

This procedure will:

- Take a student ID, a course ID, and an enrollment date as input parameters.
- Insert a new record into the enrollments table.
- Update the total_courses for the student.
Here’s the SQL code for the stored procedure:
```sql
DELIMITER //

CREATE PROCEDURE enroll_student_in_course(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN
    -- Insert a new enrollment record
    INSERT INTO enrollments (student_id, course_id, enrollment_date)
    VALUES (p_student_id, p_course_id, p_enrollment_date);

    -- Update the total_courses field for the student
    UPDATE students
    SET total_courses = (
        SELECT COUNT(*)
        FROM enrollments
        WHERE student_id = p_student_id
    )
    WHERE student_id = p_student_id;
END //

DELIMITER ;


```
## Explanation:
- Parameters:

  - p_student_id: The ID of the student to be enrolled.
  - p_course_id: The ID of the course the student is enrolling in.
  - p_enrollment_date: The date of enrollment.
- Procedure Logic:

  - First, a new record is inserted into the enrollments table with the provided student ID, course ID, and enrollment date.
  - Then, it updates the total_courses field in the students table by counting the number of enrollments the student currently has.
 
3. How to Call the Procedure:
To enroll a student in a course using this stored procedure, you can call it like this:
```sql
CALL enroll_student_in_course(1, 2, CURDATE());
```
In this example:

- Student with student_id = 1 is being enrolled in the course with course_id = 2.
- The enrollment_date is set to the current date (CURDATE()).

4. Test the Procedure:
1. Check Before Enrollment: Query the students table to see the current total_courses for the student.

```sql
SELECT student_name, total_courses FROM students WHERE student_id = 1;

```
2. Enroll the Student: Call the procedure as shown earlier:
   
```sql
CALL enroll_student_in_course(1, 2, CURDATE());

```
3. Check After Enrollment: Query the students table again to see if the total_courses has been updated:

```sql
SELECT student_name, total_courses FROM students WHERE student_id = 1;

```
The total_courses should now reflect the updated value.

This procedure automates the process of enrolling a student in a course and updating their course count, making database management simpler and more efficient.


