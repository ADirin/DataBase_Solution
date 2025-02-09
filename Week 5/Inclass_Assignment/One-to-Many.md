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
