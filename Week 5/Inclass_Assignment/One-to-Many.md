# Introduction to JPA with IntelliJ: A Beginner's Guide (Class Demo)

This guide will walk you through creating a simple Java application using Java Persistence API (JPA) in IntelliJ IDEA. We'll use Hibernate as the JPA implementation and connect to HeidiDB database to demonstrate the basic concepts of Object-Relational Mapping (ORM) and JPA.
- The following figure illustrate the class and the

```mermaid
classDiagram
    direction LR

    %% Database and JPA EntityManager 
    class JPAPersistenceLayer {
        +EntityManagerFactory createEntityManagerFactory()
        +EntityManager createEntityManager()
        +beginTransaction()
        +commitTransaction()
        +close()
    }
    
    %% Student entity representation
    class Student {
        <<Entity>>
        +Long id
        +String name
        +String email
        +setId(Long id)
        +setName(String name)
        +setEmail(String email)
        +getId() Long
        +getName() String
        +getEmail() String
    }

    %% Persistence.xml representing connection to the MySQL Database
    class PersistenceXML {
        <<XML Config>>
        +Database_URL: "jdbc:mysql://localhost:3306/jpa_classdem_f24"
        +Database_User: "root"
        +Database_Password: "Test12"
        +Driver: "com.mysql.cj.jdbc.Driver"
        +Dialect: "org.hibernate.dialect.MySQLDialect"
        +hibernate.hbm2ddl.auto: "update"
    }

    %% ORM process steps
    class ORMProcess {
        <<Operations>>
        +Map_Java_Classes_to_DB_Tables()
        +Auto_generate_Primary_Keys()
        +Translate_SQL_Queries_to_JPQL()
    }

    %% Class relationships and interactions
    JPAPersistenceLayer --> "Handles" Student : Persist
    JPAPersistenceLayer --> PersistenceXML : Configuration
    Student --> "Maps to" StudentTable : ORMProcess
    PersistenceXML --> "Connects to" MySQLDatabase : Connection

```
1. JPAPersistenceLayer:

- Represents the Java Persistence API (JPA) interaction layer, which manages database operations.
- It uses the EntityManagerFactory to create an EntityManager, which is responsible for interacting with the persistence context.
- This class handles the lifecycle of transactions, beginning and committing them, and also closing the entity manager after operations.

2. Student:

- This class is a JPA Entity representing the Student table in the database.
- It has fields like id, name, and email, which map directly to columns in the corresponding database table.
- Provides getter and setter methods for these fields to manipulate the data.
- JPA uses this class to store and retrieve Student records from the database.

3. PersistenceXML:

- Represents the persistence.xml configuration file that defines the connection settings for the JPA persistence unit.
- Contains important database connection details like the URL, username, password, and JDBC driver.
- Also includes Hibernate-specific properties such as the dialect (MySQL) and schema update strategy (hibernate.hbm2ddl.auto).

4. ORMProcess:

- Illustrates the core steps of Object-Relational Mapping (ORM).
- This class conceptually maps the Student class to a corresponding database table, generates primary keys automatically, and translates Java-based queries (JPQL) into SQL that the database understands.
- Represents the abstraction layer that connects the object-oriented Java world with relational database tables.

5. MySQLDatabase (not explicitly shown):

- This is the actual database (e.g., MySQL) that stores the data.
- The persistence layer connects to this database using the details specified in the persistence.xml configuration.

## Relationships:
- JPAPersistenceLayer connects and manages the Student class for persistence and retrieval.
- PersistenceXML configures the connection between the JPA layer and the actual MySQLDatabase.
- ORMProcess shows how JPA automatically handles object-to-table mapping and SQL generation.

_________________________________________________________________________________________________________________________________________________________

# Class Demo

## Step 1: Set Up Your IntelliJ Project

### Create a New Java Project

Note: Make sure your directory structure should look something like this:

```css
Exampleone-one-db
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── example
│   │   │           └── jpa
│   │   │               ├── Main.java
│   │   │               ├── entity
│   │   │               │   ├── Student.java
│   │   │               │   └── Course.java
│   │   └── resources
│   │       └── META-INF
│   │           └── persistence.xml
└── target
    └── classes
        └── META-INF
            └── persistence.xml


```
1. Open IntelliJ IDEA and create a new Java project:
    - Go to **File > New > Project**.
    - Choose **Java** and click **Next**.
    - Name your project (e.g., `JPAExample`) and set the project location.

### Add Maven Support

2. Add Maven support:
    - Select the option to **Add Maven support** during project creation or add a `pom.xml` file manually later.
    - If not added automatically, right-click on the project, choose **Add Framework Support**, and select **Maven**.

### Update `pom.xml` with Dependencies

3. Open `pom.xml` and add the following dependencies:

    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>

        <groupId>com.example</groupId>
        <artifactId>JPAExample</artifactId>
        <version>1.0-SNAPSHOT</version>

        <properties>
            <maven.compiler.source>17</maven.compiler.source>
            <maven.compiler.target>17</maven.compiler.target>
        </properties>

        <dependencies>
            <!-- Hibernate and JPA API -->
            <dependency>
                <groupId>org.hibernate.orm</groupId>
                <artifactId>hibernate-core</artifactId>
                <version>6.2.5.Final</version>
            </dependency>
            <dependency>
                <groupId>jakarta.persistence</groupId>
                <artifactId>jakarta.persistence-api</artifactId>
                <version>3.1.0</version>
            </dependency>

            <!-- H2 Database -->
            <dependency>
                <groupId>com.h2database</groupId>
                <artifactId>h2</artifactId>
                <version>2.2.220</version>
                <scope>runtime</scope>
            </dependency>

            <!-- Logging dependencies (optional) -->
            <dependency>
                <groupId>org.slf4j</groupId>
                <artifactId>slf4j-api</artifactId>
                <version>2.0.9</version>
            </dependency>
            <dependency>
                <groupId>org.slf4j</groupId>
                <artifactId>slf4j-simple</artifactId>
                <version>2.0.9</version>
            </dependency>
        </dependencies>
    </project>
    ```

4. Refresh Maven:
    - Right-click on your project and choose **Maven > Reload Project** to ensure all dependencies are downloaded.

## Step 2: Create the JPA Entity

### Create a New Package

1. Create a new package named `com.example.jpa.entity`:
    - Right-click on `src/main/java`, select **New > Package**, and name it `com.example.jpa.entity`.

### Create the `Student` Entity

2. Create a new Java class inside this package named `Student`:

    ```java
    package com.example.jpa.entity;

    import jakarta.persistence.Entity;
    import jakarta.persistence.GeneratedValue;
    import jakarta.persistence.GenerationType;
    import jakarta.persistence.Id;

    @Entity
    public class Student {
        
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        
        private String name;
        private String email;

        public Student() {
        }

        public Student(String name, String email) {
            this.name = name;
            this.email = email;
        }

        // Getters and Setters
        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        @Override
        public String toString() {
            return "Student{" +
                    "id=" + id +
                    ", name='" + name + '\'' +
                    ", email='" + email + '\'' +
                    '}';
        }
    }
    ```

## Step 3: Configure Persistence

### Create `persistence.xml`

1. Create a `persistence.xml` file to configure the persistence unit:
    - Right-click on `src/main/resources` and create a new directory named `META-INF`.
    - Inside `META-INF`, create a new file named `persistence.xml` and add the following content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence" version="3.0">
    <persistence-unit name="JPAExamplePU" transaction-type="RESOURCE_LOCAL">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.example.jpa.entity.Student</class>
        <properties>
            <!-- JDBC connection properties for MySQL or MariaDB -->
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/testorm"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.password" value="Test12"/>

            <!-- Hibernate settings -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

## Step 4: Write JPA Code to Persist Data

### Create the `Main` Class

1. Create a new class named `Main` in the `com.example.jpa` package:

    ```java
    package com.example.jpa;

    import com.example.jpa.entity.Student;
    import jakarta.persistence.EntityManager;
    import jakarta.persistence.EntityManagerFactory;
    import jakarta.persistence.Persistence;

    public class Main {
        public static void main(String[] args) {
            // Create an EntityManagerFactory
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAExamplePU");

            // Create an EntityManager
            EntityManager em = emf.createEntityManager();

            // Begin transaction
            em.getTransaction().begin();

            // Create a new Student entity
            Student student = new Student("John Doe", "john.doe@example.com");

            // Persist the student entity
            em.persist(student);

            // Commit the transaction
            em.getTransaction().commit();

            // Retrieve and print all students from the database
            System.out.println("All students in the database:");
            em.createQuery("SELECT s FROM Student s", Student.class).getResultList().forEach(System.out::println);

            // Close the EntityManager and EntityManagerFactory
            em.close();
            emf.close();
        }
    }
    ```

## Step 5: Run the Application

1. Run the `Main` class:
    - Right-click on the `Main` class and select **Run Main.main()**.

2. Check the output:
    - The console should show the SQL statements executed by Hibernate, and you should see the student record printed to the console.

## Step 6: Understanding the Code

- **Entity Class**: The `Student` class is annotated with `@Entity`, making it a JPA entity. The `@Id` annotation marks the primary key, and `@GeneratedValue` indicates that the ID should be automatically generated.
- **Persistence Configuration**: The `persistence.xml` file configures the persistence unit, including the database connection settings and Hibernate-specific properties.
- **EntityManager**: The `EntityManager` is the core JPA interface used to interact with the persistence context, performing operations like persisting, finding, and removing entities.
- **Transactions**: JPA operations are enclosed in transactions, which are started with `em.getTransaction().begin()` and committed with `em.getTransaction().commit()`.

## Conclusion

This guide has demonstrated how to set up a simple JPA project in IntelliJ, create an entity, configure persistence, and run basic CRUD operations. With this foundation, you can explore more advanced JPA features like JPQL, criteria queries, and mapping relationships between entities.

Feel free to reach out if you have any more questions or need further assistance!

----------------------------------------------------------------------------------
To add a new table in the HeidiDB new table
1.  Create a new Database, e.g., "Student" in HeidiDB
2.  Add the local host and the port number in the persistance file
```xml
    <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/Student"/>
```
3. Add the proper database connectivity in POM.xml
- You can aslo add the JBDC in the project as follow:
    - Upload the JDBC driver from [JDBC] (https://downloads.mysql.com/archives/c-j/) based on your operating system 
    - file-->project structure--> module-->dependency--> select (+) search for the location in your machine where you have saved the JDBC driver        
 
 ```xml
 <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.30</version> <!-- Use the latest version available -->
        </dependency>
  ```
Here is the complete file persistance file
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence" version="3.0">
    <persistence-unit name="JPAExamplePU" transaction-type="RESOURCE_LOCAL">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.example.jpa.entity.Student</class>
        <properties>
            <!-- JDBC connection properties for MySQL or MariaDB -->
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/testorm"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.password" value="Test12"/>

            <!-- Hibernate settings -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>


```


 





-------------------------------------

# Setting Up a One-to-One Relationship in Hibernate: Student and Course Example
## Overview
This guide will demonstrate how to create a Hibernate application with a one-to-one relationship between Student and Course entities. Additionally, 
we will **programmatically** create the database schema if it doesn't already exist.

![one-to-one](/images/onetoone.jpg)
 
### Step 1: Create a New Maven Project
1. Open your IDE and create a new Maven project.


- The structure of the project must be implemented as shown below


```css
Exampleone-one-db
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── example
│   │   │           └── jpa
│   │   │               ├── Main.java
│   │   │               ├── DatabaseInitializer.java
│   │   │               └── entity
│   │   │                   ├── Student.java
│   │   │                   └── Course.java
│   │   └── resources
│   │       └── META-INF
│   │           └── persistence.xml
└── target
    └── classes
        └── META-INF
            └── persistence.xml



```


 
3. Add the following dependencies to your pom.xml:

 ```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>Exampleone-one-db</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <dependencies>
        <!-- Hibernate Core -->
        <dependency>
            <groupId>org.hibernate</groupId>
            <artifactId>hibernate-core</artifactId>
            <version>6.2.5.Final</version>
        </dependency>

        <!-- Jakarta Persistence -->
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.1.0</version>
        </dependency>

        <!-- MySQL Connector/J -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.32</version>
        </dependency>

        <!-- SLF4J Logging -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.9</version>
        </dependency>
    </dependencies>

</project>
```
## Step 2: Create Database Schema Programmatically
Create a Java class to programmatically create the database schema if it doesn’t exist.

  1. Create a file named DatabaseInitializer.java in your src/main/java directory.
   
```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void main(String[] args) {
        String jdbcUrl = "jdbc:mysql://localhost:3306/";
        String jdbcUser = "root";
        String jdbcPassword = "Test12";
        String dbName = "university";

        try (Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword)) {
            Statement stmt = connection.createStatement();
            String createDatabaseSQL = "CREATE DATABASE IF NOT EXISTS " + dbName;
            stmt.executeUpdate(createDatabaseSQL);
            System.out.println("Database created or already exists.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

```
  2. Run the DatabaseInitializer class to create the database before starting your Hibernate application.


## Step 3: Define Entities with One-to-One Relationship
  1. Create the Student Entity

Create a file named Student.java:
```java

package com.example.jpa.entity;
import jakarta.persistence.*;

@Entity
@Table(name = "students")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToOne(mappedBy = "student", cascade = CascadeType.ALL, orphanRemoval = true)
    private Course course;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
}

```
  2.Create the Course Entity

Create a file named Course.java:

```java
package com.example.jpa.entity;
import jakarta.persistence.*;

@Entity
@Table(name = "courses")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @OneToOne
    @JoinColumn(name = "student_id")
    private Student student;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }
}

```
## Step 4: Configure Hibernate with persistence.xml
  1.Create the persistence.xml file in src/main/resources/META-INF:

```xml
<persistence xmlns="https://jakarta.ee/xml/ns/persistence" version="3.0">
    <persistence-unit name="JPAExamplePU">
        <properties>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/university"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.password" value="Test12"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/> <!-- Options: create, update, create-drop -->
            <property name="hibernate.show_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

## Step 5: Create and Run Main Class
  1.Create a Main class to bootstrap the application and create entities.

Create a file named Main.java:
```java
package com.example.jpa;


import com.example.jpa.entity.Course;
import com.example.jpa.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class Main {

    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAExamplePU");
        EntityManager em = emf.createEntityManager();

        em.getTransaction().begin();

        Student student = new Student();
        student.setName("Alice");

        Course course = new Course();
        course.setTitle("Introduction to Programming");
        course.setStudent(student);

        student.setCourse(course);

        em.persist(student);

        em.getTransaction().commit();

        em.close();
        emf.close();
    }
}

```
  2. Run the Main class to create the tables and insert data.

# Conclusion
By following these steps, you have set up a Hibernate application with a one-to-one relationship between Student and Course entities. Additionally, the database schema is created programmatically if it does not already exist. Hibernate will manage the schema and data according to your configuration.

Feel free to modify and extend these instructions based on your project’s requirements. For further customization or advanced configurations, refer to the Hibernate documentation or your database's specific settings.
   





-----------------------------------------------------------------------

# IntelliJ Assignment: Demonstrating One-to-Many Relationship using JPA and MySQL

## Assignment Title: One-to-Many Relationship: Students and Exam Grades

### Objective
In this assignment, you will implement a simple **One-to-Many relationship** using **JPA (Java Persistence API)** and **Hibernate** in a Java project without Spring. You will model the relationship between a `Student` entity and an `Exam` entity with a grade scale from 1-5, where each student can have multiple exam grades.

```mermaid
classDiagram
    class Student {
        Long id
        String name
        List~Exam~ exams
        +getId()
        +setId(Long id)
        +getName()
        +setName(String name)
        +getExams()
        +setExams(List~Exam~ exams)
    }

    class Exam {
        Long id
        String subject
        int grade
        Student student
        +getId()
        +setId(Long id)
        +getSubject()
        +setSubject(String subject)
        +getGrade()
        +setGrade(int grade)
        +getStudent()
        +setStudent(Student student)
    }

    Student "1" -- "0..*" Exam : "has exams"

```



You will use **IntelliJ IDEA** and **MySQL** (through HeidiSQL or another MySQL client) as your database for this assignment. The submission will include the project files and a screenshot of the list of students and their exam grades after querying the database.

---

### Part 1: Project Setup in IntelliJ

1. **Create a new Maven Project**:
   - Open IntelliJ IDEA and create a new **Maven** project named `StudentExamSystem`.
   - Configure the `pom.xml` with the necessary dependencies for **JPA**, **Hibernate**, and **MySQL**.

```xml
<dependencies>
    <!-- JPA and Hibernate -->
    <dependency>
        <groupId>org.hibernate.orm</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>6.1.5.Final</version>
    </dependency>

    <!-- MySQL Connector for Java -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>

    <!-- JUnit for testing -->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>


```
## Part 2: Database Setup

1. Create the Database:

- Create a database called student_exam_system in MySQL using HeidiSQL or from the MySQL CLI.
```sql
CREATE DATABASE student_exam_system;
```

2. Configure persistence.xml:

- In the src/main/resources/META-INF folder, create a persistence.xml file to configure JPA for MySQL.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence
    http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">

    <persistence-unit name="student_exam_system">
        <class>com.example.jpa.entity.Student</class>
        <class>com.example.jpa.entity.Exam</class>

        <!-- Database settings -->
        <properties>
            <!-- MySQL Database Connection Settings -->
            <property name="javax.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/student_exam_system"/>
            <property name="javax.persistence.jdbc.user" value="root"/>
            <property name="javax.persistence.jdbc.password" value="Test12"/>

            <!-- Hibernate settings -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>

```
- Make sure to replace your-username and your-password with your MySQL credentials.

## Part 3: Entity Creation
1. Create the Student Entity:
- Inside the src/main/java/com/example folder, create a Java class Student.
- Annotate it with @Entity and define fields such as id, name, and a One-to-Many relationship with the Exam entity.

```java
package com.example;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "students")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false)
    private String name;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Exam> exams;

    public Student() {}

    public Student(String name) {
        this.name = name;
    }

    // Getters and Setters
}


```
2. Create the Exam Entity:
- Create a Java class Exam to represent the Exam entity.
- Annotate it with @Entity and define fields such as id, grade, and a Many-to-One relationship to the Student entity.
```java

package com.example;

import jakarta.persistence.*;

@Entity
@Table(name = "exams")
public class Exam {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student student;

    @Column(name = "grade", nullable = false)
    private int grade; // Grades will be on a scale of 1-5

    public Exam() {}

    public Exam(Student student, int grade) {
        this.student = student;
        this.grade = grade;
    }

    // Getters and Setters
}

```
## Part 4: DAO Layer (Data Access Object)
1. Create DAO Classes for Student and Exam:
- Create DAO classes to manage database operations for Student and Exam entities using Hibernate.

```java
package com.example;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class StudentDAO {
    private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = Persistence.createEntityManagerFactory("student_exam_system");

    public void saveStudent(Student student) {
        EntityManager entityManager = ENTITY_MANAGER_FACTORY.createEntityManager();
        entityManager.getTransaction().begin();
        entityManager.persist(student);
        entityManager.getTransaction().commit();
        entityManager.close();
    }

    public List<Student> getAllStudents() {
        EntityManager entityManager = ENTITY_MANAGER_FACTORY.createEntityManager();
        List<Student> students = entityManager.createQuery("from Student", Student.class).getResultList();
        entityManager.close();
        return students;
    }
}

```


```java
package com.example;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class ExamDAO {
    private static final EntityManagerFactory ENTITY_MANAGER_FACTORY = Persistence.createEntityManagerFactory("student_exam_system");

    public void saveExam(Exam exam) {
        EntityManager entityManager = ENTITY_MANAGER_FACTORY.createEntityManager();
        entityManager.getTransaction().begin();
        entityManager.persist(exam);
        entityManager.getTransaction().commit();
        entityManager.close();
    }
}



```
## Part 5: Main Class (Application Runner)
1. Create Application Logic to Test:
- Create a Main class to add sample data and test the relationship.
```java
package com.example;

import java.util.List;

public class Main {

    public static void main(String[] args) {
        StudentDAO studentDAO = new StudentDAO();
        ExamDAO examDAO = new ExamDAO();

        // Add sample students
        Student john = new Student("John Doe");
        Student jane = new Student("Jane Smith");

        studentDAO.saveStudent(john);
        studentDAO.saveStudent(jane);

        // Add exams for students
        examDAO.saveExam(new Exam(john, 4));
        examDAO.saveExam(new Exam(john, 5));
        examDAO.saveExam(new Exam(jane, 3));

        // Retrieve and display all students and their exam grades
        List<Student> students = studentDAO.getAllStudents();
        for (Student student : students) {
            System.out.println("Student: " + student.getName());
            student.getExams().forEach(exam -> System.out.println(" - Exam Grade: " + exam.getGrade()));
        }
    }
}


```

## Sequence Diagram (The role of each classes)
```mermaid
sequenceDiagram
    participant Main
    participant StudentDAO
    participant ExamDAO
    participant Student
    participant Exam

    Main->>StudentDAO: saveStudent(john)
    StudentDAO->>Student: new Student("John Doe")
    StudentDAO-->>Main: student saved

    Main->>StudentDAO: saveStudent(jane)
    StudentDAO->>Student: new Student("Jane Smith")
    StudentDAO-->>Main: student saved

    Main->>ExamDAO: saveExam(new Exam(john, 4))
    ExamDAO->>Exam: new Exam(john, 4)
    ExamDAO-->>Main: exam saved

    Main->>ExamDAO: saveExam(new Exam(john, 5))
    ExamDAO->>Exam: new Exam(john, 5)
    ExamDAO-->>Main: exam saved

    Main->>ExamDAO: saveExam(new Exam(jane, 3))
    ExamDAO->>Exam: new Exam(jane, 3)
    ExamDAO-->>Main: exam saved

    Main->>StudentDAO: getAllStudents()
    StudentDAO-->>Main: List of Students

    Main->>Student: getExams()
    Student-->>Main: List of Exams for each student


```
## Additional tasks:
Extend the code above with additional filds
- Add grade saving date
- Add also the temporality feature in Exam

## Part 6: Generate Output and Submit
1. Run the Project:

- Run the project to verify that the One-to-Many relationship works as expected. You should see students along with their exam grades printed in the console.

2. Take a Screenshot:

After running the program, take a screenshot of the console output showing the list of students and their exam grades.

3. Submit the Following:

- Upload the Java project files to GitHub.
- Include a screenshot of the console output displaying the list of students and their exam grades.
- Submit the GitHub repository link and screenshot through OMA

# Submission Deadline
The assignment must be submitted by [insert deadline].


## Evaluation Criteria
- Correct implementation of the One-to-Many relationship between Student and Exam.
- Ability to query students and their associated exam grades.
- Clean and readable code following best practices.
- A functional application with correct output in the console.
