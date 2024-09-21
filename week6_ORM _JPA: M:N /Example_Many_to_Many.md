# JPA Many-to-Many Association Example
This guide provides step-by-step instructions on how to create a Many-to-Many relationship between two entities, Student and Course, using Java Persistence API (JPA) with Hibernate as the ORM provider.

## Project Overview
In this project, the Student and Course entities have a Many-to-Many relationship. This means that a student can enroll in multiple courses, and a course can have multiple students enrolled. The relationship is bidirectional, meaning that both entities are aware of the relationship.
- In this example Each `Student` can enroll in multiple `Course` entities, and each `Course` can have multiple student. 


![many to many association](../images/manytomany.jpg)

Your directory structure should look something like this:

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

## Step 1: Create the Student Entity
Create a class Student to represent the student entity.

```jave
package com.example.jpa.entity;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity //The Student entity is the owning side of the relationship because it defines the @ManyToMany annotation with a @JoinTable. 
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String email;

    @ManyToMany 
    @JoinTable(
            name = "student_course",
            joinColumns = @JoinColumn(name = "student_id"),
            inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private Set<Course> courses = new HashSet<>();

    // Constructors, Getters, Setters

    public Student() {}

    public Student(String name, String email) {
        this.name = name;
        this.email = email;
    }

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

    public Set<Course> getCourses() {
        return courses;
    }

    public void setCourses(Set<Course> courses) {
        this.courses = courses;
    }
}

```
## Step 2: Create the Course Entity
Create a class Course to represent the course entity.

```jave
package com.example.jpa.entity;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity //The Course entity has a bidirectional relationship with Student.
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @ManyToMany(mappedBy = "courses") //The @ManyToMany(mappedBy = "courses") on the Course side indicates that Course is the inverse side of the     
    // relationship, and Student is the owner.
    private Set<Student> students = new HashSet<>();

    // Constructors, Getters, Setters

    public Course() {}

    public Course(String title) {
        this.title = title;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Set<Student> getStudents() {
        return students;
    }

    public void setStudents(Set<Student> students) {
        this.students = students;
    }
}

```
## Step 3: Define the Relationship

In a bidirectional many-to-many relationship using JPA, both entities (in this case, `Course` and `Student`) reference each other, allowing navigation from either entity to the other. One entity is considered the **owning side**, and the other is the **inverse side** (non-owning).
- The **owning side** is responsible for managing the relationship and determining how it is persisted in the database. In this example, the Student entity is the owning side because it directly defines the @ManyToMany relationship along with the @JoinTable annotation.
- The **inverse side** (or non-owning side) refers to the entity that simply reflects the relationship, but does not directly manage the persistence of the relationship data. The Course entity is the inverse side, as indicated by the @ManyToMany(mappedBy = "courses") annotation. This tells JPA that the Course entity’s relationship with Student is controlled by the Student entity, and thus JPA will look at the Student side to determine how to persist the relationship.

- Annotation Overview:

  - @ManyToMany: Indicates a many-to-many relationship between the Student and Course entities.
  - @JoinTable: Specifies the join table that holds the foreign keys from both tables to represent the many-to-many relationship.
  - @JoinColumn: Specifies the foreign key columns in the join table.

- Bidirectional Relationship:

  - In Student, the @ManyToMany annotation is used to define the relationship and the @JoinTable annotation specifies the join table (student_course).
  - In Course, the @ManyToMany(mappedBy = "courses") annotation indicates that the relationship is mapped by the courses field in the Student class.
## Step 4: Create the Main Class
Create a Main class to set up and test the relationship.

```jave
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

        try {
            em.getTransaction().begin();

            // Create Students
            Student student1 = new Student("John Doe", "john.doe@example.com");
            Student student2 = new Student("Jane Smith", "jane.smith@example.com");

            // Create Courses
            Course course1 = new Course("Mathematics");
            Course course2 = new Course("Computer Science");

            // Add courses to students
            student1.getCourses().add(course1);
            student1.getCourses().add(course2);
            student2.getCourses().add(course1);

            // Persist students and courses
            em.persist(student1);
            em.persist(student2);
            em.persist(course1);
            em.persist(course2);

            // Commit the transaction
            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }
    }
}

```
## Step 5: Create the persistence.xml File
Ensure you have a persistence.xml configuration file in the META-INF directory.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence" version="3.0">
    <persistence-unit name="JPAExamplePU" transaction-type="RESOURCE_LOCAL">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.example.jpa.entity.Student</class>
        <class>com.example.jpa.entity.Course</class>
        <properties>
            <!-- JDBC connection properties -->
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/StudentCourseMN"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.password" value="Test12"/>

            <!-- Hibernate settings -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <!-- <property name="hibernate.hbm2ddl.auto" value="create-drop"/>-->


            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```
## Step 6. POM.XML
No additional change to POM.XML
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>manytomany</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
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

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.30</version> <!-- Use the latest version available -->
        </dependency>

    </dependencies>

</project>
```
## Step 7: Run the Application
1. Compile and run the Main class.
2. The application will create a many-to-many relationship between Student and Course.
3. The relationship data will be stored in a join table (student_course).
4. The program will print out the students and the courses they are enrolled in.
