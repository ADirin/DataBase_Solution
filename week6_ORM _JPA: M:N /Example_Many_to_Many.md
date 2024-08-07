# JPA Many-to-Many Association Example
This guide provides step-by-step instructions on how to create a Many-to-Many relationship between two entities, Student and Course, using Java Persistence API (JPA) with Hibernate as the ORM provider.

## Project Overview
In this project, the Student and Course entities have a Many-to-Many relationship. This means that a student can enroll in multiple courses, and a course can have multiple students enrolled. The relationship is bidirectional, meaning that both entities are aware of the relationship.

## Step 1: Create the Student Entity
Create a class Student to represent the student entity.
