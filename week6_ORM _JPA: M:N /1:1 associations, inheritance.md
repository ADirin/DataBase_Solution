# Learning Material: ORM with JPA - M:N and 1:1 Associations, Inheritance

## Table of Contents
1. [Introduction](#introduction)
2. [Object-Relational Mapping (ORM)](#object-relational-mapping-orm)
    - [What is ORM?](#what-is-orm)
    - [Associations in ORM](#associations-in-orm)
        - [M:N Associations](#mn-associations)
        - [1:1 Associations](#11-associations)
        - [Inheritance](#inheritance)
3. [Java Persistence API (JPA)](#java-persistence-api-jpa)
    - [Setting Up JPA](#setting-up-jpa)
4. [Examples](#examples)
    - [Entity Classes](#entity-classes)
        - [M:N Associations](#mn-associations-example)
        - [1:1 Associations](#11-associations-example)
        - [Inheritance](#inheritance-example)
    - [Persistence Configuration](#persistence-configuration)
    - [CRUD Operations](#crud-operations)
5. [Conclusion](#conclusion)

## Introduction
This guide covers the basics of handling Many-to-Many (M:N) and One-to-One (1:1) associations, and inheritance in Object-Relational Mapping (ORM) using Java Persistence API (JPA). These concepts are essential for managing relational data in Java applications using object-oriented principles.

## Object-Relational Mapping (ORM)

### What is ORM?
ORM is a programming technique that allows developers to interact with a relational database using an object-oriented paradigm. ORM frameworks map database tables to Java classes, and SQL queries to method calls, abstracting the database interactions.

### Associations in ORM
ORM supports various types of associations to model real-world relationships between entities.

#### M:N Associations
In an M:N association, multiple instances of one entity are associated with multiple instances of another entity. This typically involves a join table in the database.

#### 1:1 Associations
In a 1:1 association, one instance of an entity is associated with one instance of another entity. This can be modeled using shared primary keys or foreign keys.

#### Inheritance
Inheritance allows entities to inherit properties and relationships from a base entity, enabling polymorphic queries and shared behavior.

## Java Persistence API (JPA)

### Setting Up JPA
To use JPA, you'll need to include the necessary dependencies and configure a `persistence.xml` file. This setup is similar to any JPA project but focuses on defining relationships between entities.

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
M
Associations Example
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


### Employee Class (Updated)

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

    // Getters and Setters
}

```
## 1:1 Associations Example
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
### Employee Class (Updated)

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


```
## Inheritance Example
### Person Class

```java
import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public class Person {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;

    // Getters and Setters
}

```
### Customer Class

```java
import javax.persistence.Entity;

@Entity
public class Customer extends Person {
    private String customerType;

    // Getters and Setters
}

```
### Supplier Class
```java
import javax.persistence.Entity;

@Entity
public class Supplier extends Person {
    private String supplierType;

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
        <class>com.example.Project</class>
        <class>com.example.Employee</class>
        <class>com.example.Department</class>
        <class>com.example.EmployeeDetails</class>
        <class>com.example.Person</class>
        <class>com.example.Customer</class>
        <class>com.example.Supplier</class>
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

### ProjectDAO Class
```java
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.List;

public class ProjectDAO {
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("examplePU");

    public void createProject(Project project) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(project);
        em.getTransaction().commit();
        em.close();
    }

    public Project findProject(Long id) {
        EntityManager em = emf.createEntityManager();
        Project project = em.find(Project.class, id);
        em.close();
        return project;
    }

    public void updateProject(Project project) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(project);
        em.getTransaction().commit();
        em.close();
    }

    public void deleteProject(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Project project = em.find(Project.class, id);
        if (project != null) {
            em.remove(project);
        }
        em.getTransaction().commit();
        em.close();
    }

    public List<Project> findAllProjects() {
        EntityManager em = emf.createEntityManager();
        List<Project> projects = em.createQuery("SELECT p FROM Project p", Project.class).getResultList();
        em.close();
        return projects;
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
## Running the Application
To run the application, create a main class that uses the DAO classes to perform CRUD operations.

### Main Class
```java
public class Main {
    public static void main(String[] args) {
        EmployeeDAO employeeDAO = new EmployeeDAO();
        ProjectDAO projectDAO = new ProjectDAO();

        // Create new employee
        Employee employee = new Employee();
        employee.setFirstName("John");
        employee.setLastName("Doe");
        employee.setEmail("john.doe@example.com");

        EmployeeDetails details = new EmployeeDetails();
        details.setAddress("123 Main St");
        details.setPhoneNumber("555-1234");
        details.setEmployee(employee);
        employee.setEmployeeDetails(details);

        employeeDAO.createEmployee(employee);

        // Create new project
        Project project = new Project();
        project.setName("New Project");

        // Associate employee with project
        project.setEmployees(List.of(employee));
        employee.setProjects(List.of(project));

        projectDAO.createProject(project);

        // Update employee
        employee.setFirstName("Jane");
        employeeDAO.updateEmployee(employee);

        // Find and display project
        Project foundProject = projectDAO.findProject(project.getId());
        System.out.println("Project: " + foundProject.getName());

        // Delete employee
        employeeDAO.deleteEmployee(employee.getId());

        // Find all projects
        List<Project> projects = projectDAO.findAllProjects();
        projects.forEach(p -> System.out.println("Project: " + p.getName()));
    }
}



```
# Conclusion
This guide provided an overview of handling Many-to-Many (M) and One-to-One (1:1) associations, and inheritance in JPA. 
By leveraging these relationships, you can model complex data structures in a relational database using an object-oriented approach, facilitating better data management and retrieval in Java applications.

