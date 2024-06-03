# Learning Material: ORM with JPA - JPQL and Criteria API

## Table of Contents
1. [Introduction](#introduction)
2. [Java Persistence Query Language (JPQL)](#java-persistence-query-language-jpql)
    - [What is JPQL?](#what-is-jpql)
    - [Basic JPQL Syntax](#basic-jpql-syntax)
    - [Examples of JPQL Queries](#examples-of-jpql-queries)
3. [Criteria API](#criteria-api)
    - [What is the Criteria API?](#what-is-the-criteria-api)
    - [Basic Criteria API Syntax](#basic-criteria-api-syntax)
    - [Examples of Criteria API Queries](#examples-of-criteria-api-queries)
4. [Entity Classes](#entity-classes)
5. [Persistence Configuration](#persistence-configuration)
6. [Conclusion](#conclusion)

## Introduction
This guide covers the basics of using Java Persistence Query Language (JPQL) and Criteria API for querying databases in Java applications using JPA. These query methods are essential for retrieving and manipulating data in a flexible and type-safe manner.

## Java Persistence Query Language (JPQL)

### What is JPQL?
JPQL is an object-oriented query language used in JPA. It allows you to write queries against entity objects rather than directly against database tables.

### Basic JPQL Syntax
- `SELECT e FROM Entity e` - Basic select query.
- `WHERE` clause - Filtering results.
- `JOIN` - Joining related entities.
- `ORDER BY` - Sorting results.

### Examples of JPQL Queries
#### Find All Employees
```java
EntityManager em = emf.createEntityManager();
List<Employee> employees = em.createQuery("SELECT e FROM Employee e", Employee.class).getResultList();
em.close();
```
### Find Employees by Department
```java
EntityManager em = emf.createEntityManager();
List<Employee> employees = em.createQuery("SELECT e FROM Employee e WHERE e.department.name = :deptName", Employee.class)
                             .setParameter("deptName", "Sales")
                             .getResultList();
em.close();


```
### Find Employees with Projects

```java
EntityManager em = emf.createEntityManager();
List<Employee> employees = em.createQuery("SELECT e FROM Employee e JOIN e.projects p WHERE p.name = :projectName", Employee.class)
                             .setParameter("projectName", "New Project")
                             .getResultList();
em.close();

```

# Criteria API
What is the Criteria API?
The Criteria API is a type-safe, programmatic way to create queries in JPA. It provides a way to build queries dynamically in Java.

## Basic Criteria API Syntax
Create a CriteriaBuilder from the EntityManager.
Create a CriteriaQuery object.
Define query roots and criteria.
Execute the query.
## Examples of Criteria API Queries
Find All Employees
``` java
EntityManager em = emf.createEntityManager();
CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> employee = cq.from(Employee.class);
cq.select(employee);
List<Employee> employees = em.createQuery(cq).getResultList();
em.close();
```

### Find Employees with Projects

```java
EntityManager em = emf.createEntityManager();
CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> employee = cq.from(Employee.class);
Join<Employee, Project> project = employee.join("projects");
cq.select(employee).where(cb.equal(project.get("name"), "New Project"));
List<Employee> employees = em.createQuery(cq).getResultList();
em.close();

```

## Entity Classes
The following entity classes will be used in the examples above.

### Employee Class

```java
import javax.persistence.*;
import java.util.List;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String firstName;
    private String lastName;
    private String email;

    @ManyToMany(mappedBy = "employees")
    private List<Project> projects;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;

    @OneToOne(mappedBy = "employee", cascade = CascadeType.ALL, orphanRemoval = true)
    private EmployeeDetails employeeDetails;

    // Getters and Setters
}



### Project Class
```java
import javax.persistence.*;
import java.util.List;

@Entity
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    @ManyToMany
    @JoinTable(
        name = "project_employee",
        joinColumns = @JoinColumn(name = "project_id"),
        inverseJoinColumns = @JoinColumn(name = "employee_id")
    )
    private List<Employee> employees;

    // Getters and Setters
}


```

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

    @OneToMany(mappedBy = "department")
    private List<Employee> employees;

    // Getters and Setters
}


```

### EmployeeDetails Class

```java
import javax.persistence.*;

@Entity
public class EmployeeDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String address;
    private String phoneNumber;

    @OneToOne
    @JoinColumn(name = "employee_id")
    private Employee employee;

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
        <class>com.example.Project</class>
        <class>com.example.Employee</class>
        <class>com.example.Department</class>
        <class>com.example.EmployeeDetails</class>
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

# Conclusion
This guide provided an overview of using JPQL and the Criteria API in JPA. 
By leveraging these query methods, you can perform complex database operations in a type-safe and flexible manner, 
enhancing the capabilities of your Java applications.
