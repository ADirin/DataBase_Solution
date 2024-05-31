# Learning Material: ORM and JPA

## Table of Contents
1. [Introduction](#introduction)
2. [Object-Relational Mapping (ORM)](#object-relational-mapping-orm)
    - [What is ORM?](#what-is-orm)
    - [Benefits of ORM](#benefits-of-orm)
    - [Popular ORM Frameworks](#popular-orm-frameworks)
3. [Java Persistence API (JPA)](#java-persistence-api-jpa)
    - [What is JPA?](#what-is-jpa)
    - [Core Concepts of JPA](#core-concepts-of-jpa)
    - [Setting Up JPA](#setting-up-jpa)
4. [Examples](#examples)
    - [Entity Class](#entity-class)
    - [Persistence Configuration](#persistence-configuration)
    - [CRUD Operations](#crud-operations)
5. [Conclusion](#conclusion)

## Introduction
This guide covers the basics of Object-Relational Mapping (ORM) and Java Persistence API (JPA). These concepts are essential for managing relational data in Java applications using object-oriented principles. ORM abstracts the database interactions by mapping database tables to Java classes, while JPA is a specification that standardizes ORM in Java.

## Object-Relational Mapping (ORM)

### What is ORM?
ORM is a programming technique that allows developers to interact with a relational database using an object-oriented paradigm. ORM frameworks map database tables to Java classes, and SQL queries to method calls, abstracting the database interactions.

### Benefits of ORM
- **Productivity:** Reduces boilerplate code and simplifies database interactions.
- **Maintainability:** Easier to maintain and understand due to its object-oriented nature.
- **Portability:** Abstracts the database layer, making the application database-independent.
- **Performance:** Offers caching mechanisms to improve performance.

### Popular ORM Frameworks
- **Hibernate:** The most popular ORM framework for Java.
- **EclipseLink:** The reference implementation of JPA.
- **Apache OpenJPA:** An open-source implementation of JPA.

## Java Persistence API (JPA)

### What is JPA?
JPA is a specification for accessing, persisting, and managing data between Java objects and relational databases. It provides a standard approach to ORM in Java.

### Core Concepts of JPA
- **Entity:** A lightweight, persistent domain object. Typically, each entity corresponds to a table in the database.
- **Entity Manager:** Manages the lifecycle of entities and provides operations to interact with the database.
- **Persistence Unit:** Defines the configuration for an entity manager.

### Setting Up JPA
To use JPA, you'll need to include the necessary dependencies and configure a `persistence.xml` file.

### Example `pom.xml` for Maven
```xml
<dependencies>
    <dependency>
        <groupId>javax.persistence</groupId>
        <artifactId>javax.persistence-api</artifactId>
        <version>2.2</version>
    </dependency>
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>5.4.30.Final</version>
    </dependency>
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-entitymanager</artifactId>
        <version>5.4.30.Final</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.7.30</version>
    </dependency>
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version>
    </dependency>
</dependencies>

# Examples
## Entity Class
An entity class represents a table in the database. Here is an example:

```java
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String firstName;
    private String lastName;
    private String email;

    // Getters and Setters
}

```
## Persistence Configuration
The persistence.xml file configures the persistence unit and specifies database connection properties.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence" version="2.2">
    <persistence-unit name="examplePU">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.example.Employee</class>
        <properties>
            <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/mydb"/>
            <property name="javax.persistence.jdbc.user" value="root"/>
            <property name="javax.persistence.jdbc.password" value="password"/>
            <property name="javax.persistence.jdbc.driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
        </properties>
    </persistence-unit>
</persistence>
```
## CRUD Operations
Performing CRUD operations using the EntityManager.

```java

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class EmployeeDAO {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("examplePU");

    public void createEmployee(Employee employee) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(employee);
        em.getTransaction().commit();
        em.close();
    }

    public Employee findEmployee(Long

```

