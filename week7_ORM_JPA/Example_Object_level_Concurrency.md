# Object-Level Concurrency in JPA

Object-Level Concurrency refers to the management of simultaneous access to the same data object in a database by multiple transactions. In a multi-user environment, it's common for different users or processes to try to modify the same data simultaneously. 
To prevent data inconsistency and ensure data integrity, JPA provides mechanisms like Optimistic Locking and Pessimistic Locking to handle concurrency.

In this guide, we'll focus on Optimistic Locking, which assumes that multiple transactions can complete without affecting each other. 
It checks for data conflicts only at the time of committing a transaction. If a conflict is detected, the transaction is rolled back, and an OptimisticLockException is thrown.



## Step-by-Step Instructions to Implement Object-Level Concurrency Using Optimistic Locking


![Object Level Concurrency](../images/objectlevelcon.jpg)


### Step 1: Set Up Your JPA Project
  1. Create a new Java project using your IDE (e.g., IntelliJ IDEA, Eclipse).
  2. Add the necessary JPA and Hibernate dependencies to your pom.xml (if using Maven) or include the required libraries in your classpath.




```xml
<!-- Example Maven dependencies -->
<dependencies>
    <dependency>
        <groupId>jakarta.persistence</groupId>
        <artifactId>jakarta.persistence-api</artifactId>
        <version>3.0.0</version>
    </dependency>
    <dependency>
        <groupId>org.hibernate.orm</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>6.2.5.Final</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.32</version>
    </dependency>
</dependencies>

```
### Step 2: Create Entity Classes with Optimistic Locking
Create your entity classes and add a @Version field to enable optimistic locking.

Student.java
```java
package com.example.jpa.entity;

import jakarta.persistence.*;

@Entity
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;

    @OneToOne(mappedBy = "student", cascade = CascadeType.ALL)
    private Course course;

    @Version
    private int version; // Version field for optimistic locking

    // Constructors, getters, and setters

    public Student() {}

    public Student(String name, String email) {
        this.name = name;
        this.email = email;
    }

    // Getters and setters...

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    @Override
    public String toString() {
        return "Student{id=" + id + ", name='" + name + '\'' + ", email='" + email + '\'' + ", course=" + course + ", version=" + version + '}';
    }
}


```
Course.java
```java
package com.example.jpa.entity;

import jakarta.persistence.*;

@Entity
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @OneToOne
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    private Student student;

    @Version
    private int version; // Version field for optimistic locking

    // Constructors, getters, and setters

    public Course() {}

    public Course(String title) {
        this.title = title;
    }

    // Getters and setters...

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    @Override
    public String toString() {
        return "Course{id=" + id + ", title='" + title + '\'' + ", student=" + student + ", version=" + version + '}';
    }
}


```
### Step 3: Set Up the Persistence Configuration
Create a persistence.xml file in the META-INF directory for your JPA configuration.

```xml

<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             version="3.0">
    <persistence-unit name="JPAExamplePU">
        <properties>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/StudentCourse"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.password" value="yourpassword"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>

```
### Step 4: Write the Main Class to Simulate Concurrency
Create a main class to simulate concurrent updates and demonstrate optimistic locking.

Main.java

```java
package com.example.jpa;

import com.example.jpa.entity.Course;
import com.example.jpa.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.OptimisticLockException;
import jakarta.persistence.Persistence;

public class Main {
    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAExamplePU");

        // Initial data setup
        setupInitialData(emf);

        // Simulate concurrent updates
        simulateConcurrentUpdates(emf);

        emf.close();
    }

    private static void setupInitialData(EntityManagerFactory emf) {
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();

        // Create Students and Courses
        Student student1 = new Student("John Doe", "john.doe@example.com");
        Course course1 = new Course("Mathematics");

        // Set the one-to-one relationship
        student1.setCourse(course1);
        course1.setStudent(student1);

        // Persist the entities
        em.persist(student1);
        em.persist(course1);

        em.getTransaction().commit();
        em.close();
    }

    private static void simulateConcurrentUpdates(EntityManagerFactory emf) {
        // Transaction 1
        EntityManager em1 = emf.createEntityManager();
        em1.getTransaction().begin();
        Student student1 = em1.find(Student.class, 1L);
        student1.setName("John Doe Updated");

        // Transaction 2
        EntityManager em2 = emf.createEntityManager();
        em2.getTransaction().begin();
        Student student2 = em2.find(Student.class, 1L);
        student2.setName("Jane Doe Updated");

        // Commit Transaction 1
        em1.getTransaction().commit();
        em1.close();

        try {
            // Commit Transaction 2
            em2.getTransaction().commit();
        } catch (OptimisticLockException e) {
            System.out.println("OptimisticLockException caught: " + e.getMessage());
            em2.getTransaction().rollback();
        } finally {
            em2.close();
        }
    }
}

```
### Step 5: Run the Project
  1.Compile and run your project.
  2.Observe the behavior when two transactions try to update the same Student entity concurrently.
    - The first transaction commits successfully.
    - The second transaction throws an OptimisticLockException due to the version mismatch.

## Explanation of the Example
  - Optimistic Locking: The @Version field is used by JPA to automatically manage the version of an entity. Before committing a transaction, JPA checks the version.
  - If it has changed since the entity was last read, an OptimisticLockException is thrown.

  - Concurrency Simulation: The example simulates two transactions attempting to modify the same entity.
  - The second transaction fails if the entity version has been updated by the first transaction.

This approach helps prevent data inconsistencies and ensures that only one transaction successfully modifies the entity at a time, maintaining data integrity in a concurrent environment.

``````
``````
``````
``````
``````
