# Learning Material: 1:M Associations in ORM and JPA

## Table of Contents
1. [Introduction](#introduction)
2. [Object-Relational Mapping (ORM)](#object-relational-mapping-orm)
    - [What is ORM?](#what-is-orm)
    - [1:M Associations](#1m-associations)
3. [Java Persistence API (JPA)](#java-persistence-api-jpa)
    - [Setting Up JPA](#setting-up-jpa)
4. [Examples](#examples)
    - [Entity Classes](#entity-classes)
    - [Persistence Configuration](#persistence-configuration)
    - [CRUD Operations](#crud-operations)
5. [Conclusion](#conclusion)

## Introduction
This guide covers the basics of handling One-to-Many (1:M) associations in Object-Relational Mapping (ORM) using Java Persistence API (JPA). These concepts are essential for managing relational data in Java applications using object-oriented principles.

## Object-Relational Mapping (ORM)

### What is ORM?
ORM is a programming technique that allows developers to interact with a relational database using an object-oriented paradigm. ORM frameworks map database tables to Java classes, and SQL queries to method calls, abstracting the database interactions.

### 1:M Associations
In a 1:M association, one entity (parent) is associated with multiple instances of another entity (child). This is a common relationship in databases where, for example, one department has many employees.

## Java Persistence API (JPA)

### Setting Up JPA
To use JPA, you'll need to include the necessary dependencies and configure a `persistence.xml` file. 
This setup is similar to any JPA project but focuses on defining relationships between entities.

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
```
# Examples
## Entity Classes
Define the entities and their relationships.

### Department Class
```java
import javax.persistence.*;
import java.util.List;

@Entity
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Employee> employees;

    // Getters and Setters
}


```
### Employee Class

```java
import javax.persistence.*;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String firstName;
    private String lastName;
    private String email;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    // Getters and Setters
}

```
### Persistence Configuration
The persistence.xml file configures the persistence unit and specifies database connection properties.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence" version="2.2">
    <persistence-unit name="examplePU">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <class>com.example.Department</class>
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

### DepartmentDAO Class
```java
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.List;

public class DepartmentDAO {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("examplePU");

    public void createDepartment(Department department) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(department);
        em.getTransaction().commit();
        em.close();
    }

    public Department findDepartment(Long id) {
        EntityManager em = emf.createEntityManager();
        Department department = em.find(Department.class, id);
        em.close();
        return department;
    }

    public void updateDepartment(Department department) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(department);
        em.getTransaction().commit();
        em.close();
    }

    public void deleteDepartment(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Department department = em.find(Department.class, id);
        if (department != null) {
            em.remove(department);
        }
        em.getTransaction().commit();
        em.close();
    }

    public List<Department> findAllDepartments() {
        EntityManager em = emf.createEntityManager();
        List<Department> departments = em.createQuery("SELECT d FROM Department d", Department.class).getResultList();
        em.close();
        return departments;
    }
}

```
### EmployeeDAO Class
```java
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.List;

public class EmployeeDAO {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("examplePU");

    public void createEmployee(Employee employee) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(employee);
        em.getTransaction().commit();
        em.close();
    }

    public Employee findEmployee(Long id) {
        EntityManager em = emf.createEntityManager();
        Employee employee = em.find(Employee.class, id);
        em.close();
        return employee;
    }

    public void updateEmployee(Employee employee) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(employee);
        em.getTransaction().commit();
        em.close();
    }

    public void deleteEmployee(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Employee employee = em.find(Employee.class, id);
        if (employee != null) {
            em.remove(employee);
        }
        em.getTransaction().commit();
        em.close();
    }

    public List<Employee> findAllEmployees() {
        EntityManager em = emf.createEntityManager();
        List<Employee> employees = em.createQuery("SELECT e FROM Employee e", Employee.class).getResultList();
        em.close();
        return employees;
    }
}
```
# Conclusion
## Understanding 1
associations in ORM and JPA is crucial for managing relational data in Java applications. 
By defining these relationships, you can model real-world scenarios more accurately and perform complex database operations with ease. 
This guide provides a comprehensive overview and practical examples to help you get started with 1
associations in ORM and JPA.
