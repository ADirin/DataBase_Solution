# Step-by-Step Guide to Creating a One-to-One Relationship in JPA
This guide will walk you through the process of setting up a one-to-one relationship between two entities using Java Persistence API (JPA). In this example, we'll create a Student entity and a Course entity, where each student is associated with one course, and each course is associated with one student.

## 1. Set Up Your Project Structure
1. Create a new Java project in your IDE (e.g., IntelliJ IDEA, Eclipse).
2. Set up Maven or Gradle for dependency management.

Your directory structure should look something like this:

```css
src/
└── main/
    └── java/
        └── com/
            └── example/
                └── jpa/
                    ├── Main.java
                    └── entity/
                        ├── Student.java
                        └── Course.java


```
