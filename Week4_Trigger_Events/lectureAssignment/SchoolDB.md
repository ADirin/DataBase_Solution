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
-- Add a new enrollment for a student
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES (1, 3, '2024-09-07');

-- Check the students table to verify that total_courses has been incremented
SELECT * FROM students;

```
Expected Outcome: The total_courses for the student with student_id = 1 should be increased by 1.

3. Test the BEFORE DELETE Trigger
Scenario: Delete an existing enrollment and verify that the total_courses for the corresponding student is decremented.
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

Your task is to design and implement an event that will:

Run daily.
Calculate the total number of courses each student is enrolled in from the enrollments table.
Update the total_courses field in the students table with the new value.
Step-by-Step Instructions:
Setup the Database and Tables: First, run the provided SQL statements to create the database and the necessary tables.

2. Task: Create a MySQL Event Your main task is to create a MySQL Event that will automatically update the total_courses for each student daily, based on the number of courses they are enrolled in.

**Hints:**

- Use the COUNT() function to determine how many courses a student is enrolled in.
- Join the students table with the enrollments table.
- Schedule the event to run every day.
3. Create the Event: Write the SQL to create the event:
```sql
DELIMITER //

CREATE EVENT update_student_courses
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
COMMENT 'Update total courses for each student daily'
DO
BEGIN
    -- Update total_courses in the students table based on enrollments
    UPDATE students s
    SET s.total_courses = (
        SELECT COUNT(e.course_id)
        FROM enrollments e
        WHERE e.student_id = s.student_id
    );
END;

//

DELIMITER ;

```
5. Verify the Event:
- After creating the event, check if it’s listed in the information_schema:
```sql
SELECT * FROM information_schema.events WHERE event_name = 'update_student_courses';

```
- Manually trigger the event (for testing purposes) to ensure the total_courses field is correctly updated:
```sql
SET GLOBAL event_scheduler = ON;
CALL update_student_courses();

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
