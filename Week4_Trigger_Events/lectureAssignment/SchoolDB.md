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
2. Trigger Examples
Create the Trigger:
Create a trigger that updates the total_courses field in the students table when a record is deleted from the enrollments table.
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
Trigger 2: AFTER DELETE on enrollments
This trigger will decrement the total_courses column in the students table after a student is unenrolled from a course.
```sql
-- Delete an enrollment record for Alice
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 2;

-- Check the students table to see if total_courses has been updated
SELECT * FROM students;


```
Test the Trigger:

Delete an enrollment record and verify that the total_courses field in the students table is updated correctly.
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
Now, check the students table to see if the total_courses has been updated correctly.

```sql

-- Check the total courses after enrollment
SELECT * FROM students;



```
This should show that:

Alice is enrolled in 2 courses (total_courses = 2).
Bob is enrolled in 1 course (total_courses = 1).
Test Trigger on DELETE
Now, let's delete one of Alice's enrollments and see how the total_courses changes.

```sql

-- Delete an enrollment for Alice
DELETE FROM enrollments WHERE student_id = 1 AND course_id = 1;

-- Check the total courses again
SELECT * FROM students;



```
