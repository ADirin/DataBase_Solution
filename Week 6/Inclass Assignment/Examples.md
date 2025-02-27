# JPA Library System Assignment

## Objective
The goal of this assignment is to help students understand and implement different JPA relationships: **Many-to-Many, One-to-One, and Inheritance** using a **Library System**.

## Requirements
1. **Entities & Relationships**:
   - Implement **Table-per-Class Inheritance** for `Book` (superclass), `EBook`, and `PrintedBook`.
   - Establish a **One-to-One** relationship between `Author` and `Biography`.
   - Implement a **Many-to-Many** relationship between `Student` and `Book` using an intermediate entity `BorrowedBook` that contains an extra field (`borrowDate`).

2. **JPA Configuration**:
   - Use **MariaDB** as the database.
   - Define the persistence configuration in `persistence.xml`.
   - Use **JPA's EntityManager** for database operations.

3. **DAO Class**:
   - Create a `LibraryDAO` class to handle CRUD operations for `Student`, `Book`, and `BorrowedBook`.

4. **Main Class**:
   - Insert sample data (students, books, authors, biographies, borrowed books) into the database.
   - Print confirmation messages to indicate successful insertion.

## Deliverables
- JPA entity classes with proper annotations.
- A fully functional `LibraryDAO` class using `EntityManager`.
- `persistence.xml` configured for MariaDB.
- A `Main` class to test data insertion.
- SQL schema and sample queries (optional but recommended).

## Evaluation Criteria
- Correct implementation of **JPA relationships**.
- Proper usage of **EntityManager** for CRUD operations.
- Well-structured and readable code.
- Successful execution of `Main` class without errors.

### Bonus
- Implement **query methods** to fetch books borrowed by a student.
- Add **logging** to track database transactions.

**Deadline:** [Specify due date]

**Submission Format:** Upload your project as a GitHub repository or a zip file containing all necessary files.

Happy Coding! 🚀
