# Database Normalization

## Table of Contents
1. [Introduction](#introduction)
2. [Why Normalize?](#why-normalize)
3. [Normalization Forms](#normalization-forms)
    - [First Normal Form (1NF)](#first-normal-form-1nf)
    - [Second Normal Form (2NF)](#second-normal-form-2nf)
    - [Third Normal Form (3NF)](#third-normal-form-3nf)
    - [Boyce-Codd Normal Form (BCNF)](#boyce-codd-normal-form-bcnf)
4. [Examples](#examples)
5. [Conclusion](#conclusion)
6. [Further Reading](#further-reading)

## Introduction
Database normalization is a process used to organize a database into tables and columns. The main aim is to reduce data redundancy and improve data integrity. The process involves dividing large tables into smaller ones and defining relationships between them.

## Why Normalize?
- **Eliminate Redundant Data:** Avoid storing the same data in multiple places.
- **Ensure Data Dependencies Make Sense:** Store related data together.
- **Improve Data Integrity:** Maintain accuracy and consistency of data over its entire lifecycle.
- **Optimize Queries:** Simplify and speed up database queries.

## Normalization Forms
Normalization is typically divided into several steps, each building on the previous one. These steps are referred to as normal forms. The most common normal forms are 1NF, 2NF, 3NF, and BCNF.

### First Normal Form (1NF)
- **Definition:** A table is in 1NF if:
  - It contains only atomic (indivisible) values.
  - Each entry in a column is of the same data type.
  - Each column contains only a single value.
  - Each column has a unique name.
  - The order in which data is stored does not matter.

**Example:**

| StudentID | Name       | Courses           |
|-----------|------------|-------------------|
| 1         | Alice      | Math, Physics     |
| 2         | Bob        | Math, Chemistry   |

**Normalized to 1NF:**

| StudentID | Name  | Course    |
|-----------|-------|-----------|
| 1         | Alice | Math      |
| 1         | Alice | Physics   |
| 2         | Bob   | Math      |
| 2         | Bob   | Chemistry |

### Second Normal Form (2NF)
- **Definition:** A table is in 2NF if:
  - It is in 1NF.
  - It has no partial dependency; that is, no non-prime attribute is dependent on any proper subset of any candidate key of the table.

**Example:**

| StudentID | Course    | Instructor |
|-----------|-----------|------------|
| 1         | Math      | Prof. A    |
| 1         | Physics   | Prof. B    |
| 2         | Math      | Prof. A    |
| 2         | Chemistry | Prof. C    |

**Normalized to 2NF:**

**Students Table:**

| StudentID | Name  |
|-----------|-------|
| 1         | Alice |
| 2         | Bob   |

**Courses Table:**

| CourseID | Course    | Instructor |
|----------|-----------|------------|
| 101      | Math      | Prof. A    |
| 102      | Physics   | Prof. B    |
| 103      | Chemistry | Prof. C    |

**Enrollment Table:**

| StudentID | CourseID |
|-----------|----------|
| 1         | 101      |
| 1         | 102      |
| 2         | 101      |
| 2         | 103      |

### Third Normal Form (3NF)
- **Definition:** A table is in 3NF if:
  - It is in 2NF.
  - It has no transitive dependency; that is, no non-prime attribute depends on another non-prime attribute.

**Example:**

**Courses Table:**

| CourseID | Course    | InstructorID |
|----------|-----------|--------------|
| 101      | Math      | 1            |
| 102      | Physics   | 2            |
| 103      | Chemistry | 3            |

**Instructors Table:**

| InstructorID | InstructorName |
|--------------|----------------|
| 1            | Prof. A        |
| 2            | Prof. B        |
| 3            | Prof. C        |

### Boyce-Codd Normal Form (BCNF)
- **Definition:** A table is in BCNF if:
  - It is in 3NF.
  - For every one of its non-trivial functional dependencies `X -> Y`, `X` is a super key.

## Examples
### Example 1: Employee Database

**Unnormalized Table:**

| EmpID | EmpName | Dept     | DeptHead |
|-------|---------|----------|----------|
| 1     | John    | IT       | Alice    |
| 2     | Jane    | HR       | Bob      |
| 3     | Jake    | IT       | Alice    |

**1NF:**

| EmpID | EmpName | Dept     | DeptHead |
|-------|---------|----------|----------|
| 1     | John    | IT       | Alice    |
| 2     | Jane    | HR       | Bob      |
| 3     | Jake    | IT       | Alice    |

**2NF:**

**Employee Table:**

| EmpID | EmpName |
|-------|---------|
| 1     | John    |
| 2     | Jane    |
| 3     | Jake    |

**Department Table:**

| DeptID | DeptName | DeptHead |
|--------|----------|----------|
| 1      | IT       | Alice    |
| 2      | HR       | Bob      |

**EmployeeDepartment Table:**

| EmpID | DeptID |
|-------|--------|
| 1     | 1      |
| 2     | 2      |
| 3     | 1      |

**3NF and BCNF:**

No changes are needed as there are no transitive dependencies.

## Conclusion
Database normalization is crucial for designing efficient and reliable databases. By following the normalization forms, you can ensure your data is logically stored, reducing redundancy and improving data integrity.

## Further Reading
- [Database Normalization Basics](https://www.studytonight.com/dbms/database-normalization.php)
- [A Guide to Database Normalization](https://www.lifewire.com/database-normalization-1019735)
- [Normalization in DBMS: 1NF, 2NF, 3NF and BCNF](https://www.guru99.com/database-normalization.html)
