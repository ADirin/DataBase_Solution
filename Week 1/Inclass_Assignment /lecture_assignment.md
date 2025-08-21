# Lecture Exercise week 1:
## Aim of the Exercise
The aim of this exercise is to provide a demonstration on the concepts and practical applications of temporal databases. Specifically, the exercise focuses on the implementation and understanding of key temporal elements such as transaction time, valid time, and system versioning using a simple Students and Courses database schema. 
By the end of this project, participants will be able to:

    1. Understand the importance and the application of temporal data in database management system.
    2. Create and manage temporal tables that track historical data and changes over time.
    3. Implement and query temporal data using SQL to view historical states and manage data integrity.
    4. Apply system versioning techniques to automatically manage historical data in relational databases.


## Project Steps

### 1. Database Schema Creation

Design and create tables for Students, Courses, and Enrollments, incorporating fields for temporal data management (e.g., `ValidFrom`, `ValidTo`, `TransactionStartTime`, `TransactionEndTime`).

![Assignment1](/images/asgn.JPG)

### 2. Temporal Concepts Understanding

Explain and demonstrate the use of transaction time, valid time, and system versioning in the context of the Students and Courses database.

### 3. Data Insertion and Temporal Management

Insert records into the database while considering temporal attributes, such as the enrollment and drop dates of students in courses. Address common issues related to temporal data types (e.g., handling large future dates in `TIMESTAMP` columns).

### 4. Temporal Queries and System Versioning

Execute SQL queries to retrieve historical data at specific points in time. Illustrate the use of system versioning to automatically manage and track changes in data.



## Sample solutions
    - Make sure your solutions follows the diagram, e.g., add the DATTIME; etc.

### Step 1: Database Schema Creation

1. **Create the Students Table:**
    ```sql
    CREATE TABLE Students (
       ...
    );
    ```

2. **Create the Courses Table:**
    ```sql
    CREATE TABLE Courses (
    ....
    );
    ```

3. **Create the Enrollments Table:**
    ```sql
    CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    DropDate DATE,
    ValidFrom DATE,
    ValidTo DATE,
    TransactionStartTime TIMESTAMP(6),
    TransactionEndTime TIMESTAMP(6),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);



    ```

### Step 3: Data Insertion and Temporal Management


```sql

-- First, insert into Students (if not already done)
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, EnrollmentDate)
VALUES
(101, 'John', 'Smith', '2000-05-15', '2023-08-20'),
(102, 'Emily', 'Johnson', '2001-02-28', '2023-08-22'),
(103, 'Michael', 'Brown', '2000-11-10', '2023-08-18'),
(104, 'Sarah', 'Davis', '2001-07-03', '2023-08-25');

-- Insert into Courses (if not already done)
INSERT INTO Courses (CourseID, CourseName, CourseCode, Credits, Department)
VALUES
(1, 'Introduction to Programming', 'CS101', 3, 'Computer Science'),
(2, 'Database Systems', 'CS201', 4, 'Computer Science'),
(3, 'Calculus I', 'MATH101', 4, 'Mathematics');

-- Now insert into Enrollments
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate, DropDate, ValidFrom, ValidTo, TransactionStartTime, TransactionEndTime)
VALUES
(1, 101, 1, '2024-01-15', NULL, '2024-01-15', '2030-12-31', '2024-01-15 09:30:00', '2030-12-31 23:59:59'),
(2, 101, 2, '2024-01-20', '2024-03-15', '2024-01-20', '2024-03-15', '2024-01-20 13:10:00', '2024-03-15 16:30:00'),
(3, 102, 1, '2024-02-01', NULL, '2024-02-01', '2030-12-31', '2024-02-01 14:20:00', '2030-12-31 23:59:59'),
(4, 103, 3, '2024-02-10', NULL, '2024-02-10', '2030-12-31', '2024-02-10 09:00:00', '2030-12-31 23:59:59'),
(5, 104, 2, '2024-02-15', '2024-04-01', '2024-02-15', '2024-04-01', '2024-02-15 15:30:00', '2024-04-01 14:15:00');
```

## Exercise 1. Current vs Historical Enrollment Status
- Show all the students who were enrooled in CourseID 1 (introduction to programming) of march 1,2024 including those who may have dropped the course later

**Add you statement and the output in your report**

## Exercise 2.  Student Enrollment Timeline

- For student ID 101, show their complete enrollment history with all courses, including when they started and ended each enrollment.

**Add you statement and the output in your report**

## Exercise 3. Active Enrollments with Temporal Integrity

- Find all currently active enrollments (not dropped) and verify that their temporal validity periods are correctly set.

**Add you statement and the output in your report**
------------------------

# In-Class Assignment for INDEX

## Step 2: Dense Index
A dense index is one that includes an index entry for every *search key value*, even if those values are not unique. Typically, dense indexes are more effective for columns with many unique values.

**Use Case for Dense Index:** The column DateOfBirth in the Students table is likely to have many unique values (students with different birthdates), so it makes sense to create a dense index here.
**SQL for Creating Dense Index on** DateOfBirth

```sql
-- Create a dense index on DateOfBirth column (many unique values)
CREATE INDEX idx_dob_dense ON Students (DateOfBirth);

```
Explanation:

    - The DateOfBirth column in the Students table is chosen for a dense index because birthdates will most likely be unique across students.
    - The idx_dob_dense index will be created to allow for efficient queries filtering on DateOfBirth.


## Step 3: Thin Index
A **thin index** is one that includes only a few distinct values (low cardinality) for a column. For example, creating an index on a column that stores categorical or repeated values.

**Use Case for Thin Index:** The CourseName column in the Courses table is a good candidate for a thin index, as there might be fewer unique course names (e.g., multiple students can enroll in the same course).
**SQL for Creating Thin Index on** CourseName

```sql
 -- Create a thin index on CourseName column (low cardinality)
CREATE INDEX idx_course_name_thin ON Courses (CourseName);

```
Explanation:

    - The CourseName column is a good example of low cardinality. Even though there may be many students, the number of unique course names will likely be fewer.
    - The idx_course_name_thin index will improve the performance of queries filtering by CourseName.


## Step 4: Querying with the Indexes
Once the indexes are created, learners can run queries that benefit from these indexes.

**Query for Dense Index (DateOfBirth)**

```sql
-- Query using the dense index on DateOfBirth
SELECT * FROM Students
WHERE DateOfBirth = '2000-11-10';


```
This query will use the dense index on the DateOfBirth column, speeding up searches by birthdate.

**Query for Thin Index (CourseName)**

```sql

-- Query using the thin index on CourseName
SELECT * FROM Courses
WHERE CourseName = 'Database Systems';


```
This query will use the thin index on the CourseName column to efficiently find courses with the name 'Mathematics 101'.


## Step 6: Check Index Usage with EXPLAIN
You can use the EXPLAIN command to see if MySQL is using the indexes for your queries.

For example:
```sql

EXPLAIN SELECT * FROM Students WHERE DateOfBirth = '2000-11-10';

```
## Step 7: Clean Up the Environment
After performing the practice, learners should clean up the environment by dropping the indexes.

**SQL to Drop Indexes**

```sql

-- Drop the indexes after practice
DROP INDEX idx_dob_dense ON Students;
DROP INDEX idx_course_name_thin ON Courses;
DROP INDEX idx_has_dropped ON Enrollments;

```
## Submission
Create a PDF document that includes *only* the question number and your answer. Make sure you have added your name to the report. If you do not answer any question, please write "NOT DONE" in capital letters. 
