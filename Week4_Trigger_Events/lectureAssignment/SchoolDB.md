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
Now, let's create triggers to demonstrate different operations.

Trigger 1: AFTER INSERT on enrollments
This trigger will increment the total_courses column in the students table after a student enrolls in a new course.

```sql
DELIMITER //
CREATE TRIGGER afterEnrollmentInsert
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    -- Increase the student's total courses by 1 after an enrollment
    UPDATE students SET total_courses = total_courses + 1
    WHERE student_id = NEW.student_id;
END;
//
DELIMITER ;

```
Trigger 2: AFTER DELETE on enrollments
This trigger will decrement the total_courses column in the students table after a student is unenrolled from a course.
```sql
DELIMITER //
CREATE TRIGGER afterEnrollmentDelete
AFTER DELETE ON enrollments
FOR EACH ROW
BEGIN
    -- Decrease the student's total courses by 1 after unenrollment
    UPDATE students SET total_courses = total_courses - 1
    WHERE student_id = OLD.student_id;
END;
//
DELIMITER ;




```
3. Test the Trigger
To see the trigger in action, we'll insert some data into the students, courses, and enrollments tables and observe the changes in the students.total_courses.

Insert Sample Data

```sql

-- Insert into students table
INSERT INTO students (student_name) VALUES ('Alice'), ('Bob');

-- Insert into courses table
INSERT INTO courses (course_name) VALUES ('Math'), ('Science');

-- Insert enrollments (this will trigger the afterEnrollmentInsert)
INSERT INTO enrollments (student_id, course_id, enrollment_date) 
VALUES (1, 1, CURDATE()), (1, 2, CURDATE()), (2, 1, CURDATE());



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
