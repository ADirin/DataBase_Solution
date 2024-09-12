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
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/testdb"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.password" value="your_password"/>

            <!-- Hibernate settings -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
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
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd"
             version="3.0">
    <persistence-unit name="JPAExamplePU">
        <class>com.example.jpa.entity.Student</class>
        <properties>
            <!-- MySQL Database connection settings -->
            <property name="jakarta.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/jpa_classdem_f24"/>
            <property name="jakarta.persistence.jdbc.user" value="root"/>
            <property name="jakarta.persistence.jdbc.password" value="Test12"/>

            <!-- Hibernate properties -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            <property name="hibernate.show_sql" value="true"/> <!-- Optional: Show SQL statements in the console -->
        </properties>
    </persistence-unit>
</persistence>


```


 
