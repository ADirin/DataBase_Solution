# ORM with JPA: Converters, Events, and Object-Level Concurrency Control

## Table of Contents
1. [Introduction to JPA](#introduction-to-jpa)
2. [Converters](#converters)
    - [Example: Converting LocalDate to String](#example-converting-localdate-to-string)
3. [Events](#events)
    - [Example: Logging Entity Changes](#example-logging-entity-changes)
4. [Object-Level Concurrency Control](#object-level-concurrency-control)
    - [Example: Optimistic Locking with Versioning](#example-optimistic-locking-with-versioning)

## Introduction to JPA

Java Persistence API (JPA) is a specification for accessing, persisting, and managing data between Java objects and a relational database. JPA is a part of the Java EE platform and can be used with frameworks like Hibernate, EclipseLink, and others.

## Converters

JPA Converters are used to customize how Java objects are mapped to database columns and vice versa. They allow developers to define conversions between entity attribute types and database column types. This is useful when your Java objects and the database columns use different data types or formats.

For example, if you have an enumeration, a custom class, or a non-standard type that needs to be stored in a standard format in the database (like String or Integer), JPA converters handle the transformation.

## How Do Conveters Work?

To implement a JPA Converter:

    1. Define a class that implements the javax.persistence.AttributeConverter<X, Y> interface, where X is the entity attribute type and Y is the database column type.
    2. Use annotations like @Converter and @Convert to apply the converter in the entity class.To implement a JPA Converter:


### Example: Converting LocalDate to String

Let’s use Student and Course entities to demonstrate how JPA Converters work. In this example, the CourseStatus enumeration is used for course statuses, which are stored as integers in the database.

```mermaid

classDiagram
    direction LR
    class Student {
        +Long id
        +String name
        +Course course
        +getId() Long
        +getName() String
        +setName(String name)
        +getCourse() Course
        +setCourse(Course course)
    }

    class Course {
        +Long id
        +String courseName
        +CourseStatus status
        +Student student
        +getId() Long
        +getCourseName() String
        +setCourseName(String name)
        +getStatus() CourseStatus
        +setStatus(CourseStatus status)
        +getStudent() Student
        +setStudent(Student student)
    }

    class CourseStatus {
        <<enum>>
        ACTIVE
        INACTIVE
    }

    class CourseStatusConverter {
        +convertToDatabaseColumn(CourseStatus) Integer
        +convertToEntityAttribute(Integer) CourseStatus
    }

    Student "1" -- "1" Course : has
    CourseStatusConverter --> CourseStatus : converts




```

#### Step-by-Step Example

1. Course
 ```java
    package com.example.jpa.entity;

import jakarta.persistence.*;

@Entity
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String courseName;

    @Convert(converter = CourseStatusConverter.class)
    private CourseStatus status;

    @OneToOne
    @JoinColumn(name = "student_id")
    private Student student;

    public Course() {}

    public Course(String courseName, CourseStatus status) {
        this.courseName = courseName;
        this.status = status;
    }

    // Getters and setters...
}

  ```

2. Student.java

```java
package com.example.jpa.entity;

import jakarta.persistence.*;

@Entity
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToOne(mappedBy = "student", cascade = CascadeType.ALL)
    private Course course;

    public Student() {}

    public Student(String name) {
        this.name = name;
    }

    // Getters and setters...
}


```
3. 
```java
package com.example.jpa.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class CourseStatusConverter implements AttributeConverter<CourseStatus, Integer> {

    @Override
    public Integer convertToDatabaseColumn(CourseStatus status) {
        if (status == null) return null;
        return (status == CourseStatus.ACTIVE) ? 1 : 0;
    }

    @Override
    public CourseStatus convertToEntityAttribute(Integer dbData) {
        if (dbData == null) return null;
        return (dbData == 1) ? CourseStatus.ACTIVE : CourseStatus.INACTIVE;
    }
}



```
```java
package com.example.jpa.entity;

public enum CourseStatus {
    ACTIVE,
    INACTIVE
}

```
3.  Main
```java
import com.example.jpa.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class Application {
    public static void main(String[] args) {
        EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("examplePU");
        EntityManager entityManager = entityManagerFactory.createEntityManager();

        // Start a transaction
        entityManager.getTransaction().begin();

        // Create a new Student
        Student student = new Student("John Doe");
        entityManager.persist(student);

        // Commit the transaction
        entityManager.getTransaction().commit();

        // Close EntityManager
        entityManager.close();
        entityManagerFactory.close();
    }
}


```
4.  persistence.xml: persistence.xml is used to define the configuration for JPA. It typically resides in the src/main/resources/META-INF/ directory.

Here’s an example of how your persistence.xml would look:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             version="2.1">
    <persistence-unit name="examplePU" transaction-type="RESOURCE_LOCAL">
        <!-- Specify the entity classes -->
        <class>com.example.jpa.entity.Student</class>
        <class>com.example.jpa.entity.Course</class>
        <class>com.example.jpa.entity.CourseStatusConverter</class>

        <!-- JPA properties -->
        <properties>
            <!-- JDBC Database Connection properties -->
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver" />
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/mydbconv" />
            <property name="jakarta.persistence.jdbc.user" value="root" />
            <property name="jakarta.persistence.jdbc.password" value="Test12" />

            <!-- Hibernate as JPA provider -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect" />
            <property name="hibernate.hbm2ddl.auto" value="update" />
            <property name="hibernate.show_sql" value="true" />
            <property name="hibernate.format_sql" value="true" />
        </properties>
    </persistence-unit>
</persistence>
```
5. POM.xml: 
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>jpa-example</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source> <!-- Java version -->
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- JPA Dependency (Jakarta Persistence API) -->
        <dependency>
            <groupId>jakarta.persistence</groupId>
            <artifactId>jakarta.persistence-api</artifactId>
            <version>3.1.0</version>
        </dependency>

        <!-- Hibernate as the JPA implementation -->
        <dependency>
            <groupId>org.hibernate.orm</groupId>
            <artifactId>hibernate-core</artifactId>
            <version>6.2.5.Final</version> <!-- Ensure it matches your Java/JPA version -->
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>

        <!-- Logging (SLF4J + Logback) -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.13</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.5.6</version>
        </dependency>

        <!-- JUnit for Testing -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Compiler Plugin -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.10.1</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>

            <!-- Surefire Plugin for running unit tests -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
            </plugin>
        </plugins>
    </build>

</project>



```

# Events
# Events in Java Persistence API (JPA)

Events in Java Persistence API (JPA) are mechanisms that allow developers to react to changes in the state of persistent entities. They serve as the object-level counterpart of database triggers, enabling developers to execute custom logic when specific operations occur on entity objects.

## Key Concepts

### Idea of Events:
- An event listener class is attached to the target entity class. This listener class is responsible for reacting to state changes of the target entity objects.
- When an entity object's state changes in a manner defined by the developer, a callback method in the listener class is automatically invoked.

### Event Types:
JPA provides several types of events that correspond to different lifecycle points of an entity object:

- `@PrePersist` and `@PostPersist`: These events occur **before** and **after** an entity is saved to the database, respectively.
- `@PreUpdate` and `@PostUpdate`: These events occur **before** and **after** an entity is updated in the database, respectively.
- `@PreRemove` and `@PostRemove`: These events occur **before** and **after** an entity is deleted from the database, respectively.
- `@PostLoad`: This event occurs **after** an entity is loaded from the database.

## Example Use Case:
Consider a scenario where you want to perform certain actions every time an entity is saved or updated in the database:

- You can utilize events to achieve this by defining event listener methods annotated with `@PrePersist` and `@PreUpdate`.
- For example, you might want to automatically update a modification timestamp whenever an entity is persisted or updated. You can achieve this by defining `@PrePersist` and `@PreUpdate` event listener methods that set the modification timestamp before saving or updating the entity.

```java
@Entity
public class MyEntity {

    private Date lastModified;

    @PrePersist
    @PreUpdate
    public void updateTimestamp() {
        lastModified = new Date();
    }

    // Other fields, getters, and setters
}

```
# Object-level-concurrency-control
