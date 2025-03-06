## Exercise Aikido Training Session Tracker

## To complete the assignment, clone the following base code, fix any issues, and extend it to meet the requirements
[basecode](https://github.com/ADirin/dbs_week7_inclass.git)


### Objective
Students will develop a backend system for tracking Aikido training sessions, instructors, students, and performance progress. The focus is on utilizing Hibernate features such as entity events, converters, and object concurrency.

### Entities & Relationships
- **Student** `(id, name, email, rank, joinDate)`
- **Instructor** `(id, name, specialization, experienceYears)`
- **TrainingSession** `(id, date, location, duration)`
- **Attendance** `(id, status, notes)`
- **ProgressReport** `(id, reportDate, achievements, areasForImprovement)`

#### Relationships
- A **Student** can attend multiple **TrainingSessions**, and each session can have multiple students `(Many-to-Many via Attendance)`.
- An **Instructor** can conduct multiple **TrainingSessions**, but a **TrainingSession** is led by a single **Instructor** `(Many-to-One)`.
- Each **Student** can have multiple **ProgressReports**, but each report is linked to a single **Student** `(One-to-Many)`.

### JPQL Queries
- Retrieve all training sessions attended by a specific student.
- List all students who have a specific rank.
- Get all instructors specialized in a particular Aikido technique.
- Fetch students with progress reports in the last three months.

### Criteria API Queries
- Find all students who joined within the last six months.
- Search for training sessions held in a specific location.
- Retrieve all instructors with more than five years of experience.

### Add the following features
#### 1. Entity Events
- Implement `@PrePersist` and `@PreUpdate` to automatically set timestamps when entities are created or updated.
- Use `@PostLoad` to initialize computed fields.

#### 2. Converters
- Create a custom JPA attribute converter to store Aikido ranks as numerical values while exposing them as descriptive names.
- Convert attendance statuses between database values and enums.

#### 3. Object Concurrency
- Use `@Version` for optimistic locking to handle concurrent updates to student progress reports.
- Implement a mechanism to notify users of concurrent modification conflicts.



## Submission for All Exercises
### GitHub Repository:
- Push the entire project to a GitHub repository.
- Include a `README.md` file with setup instructions and project details.
