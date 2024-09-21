# JPA Associations Lecture Assignment

This lecture assignment will walk students through the process of implementing **one-to-one**, **one-to-many**, and **many-to-many** relationships using **Java Persistence API (JPA)**. We will work with a basic domain model consisting of two entities: **Car** and **Driver**.

---

## Domain Entities
- **Car**: `id`, `model`
- **Driver**: `id`, `name`, `experience`

---

## Assignment Instructions

### 1. **One-to-One Relationship**

#### Problem Statement
Each car is driven by only one driver, and each driver can drive only one car. This establishes a **one-to-one** relationship between **Car** and **Driver**.

#### Goal
Implement a one-to-one relationship between the `Car` and `Driver` entities.

#### Steps
- Define the `Car` entity, which includes a reference to the `Driver`.
- Define the `Driver` entity, which includes a reference to the `Car`.
- Annotate the relationship using `@OneToOne` annotation in JPA.

#### Example
```java
@Entity
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String model;

    @OneToOne
    @JoinColumn(name = "driver_id")
    private Driver driver;

    // Getters and Setters
}

@Entity
public class Driver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private int experience;

    @OneToOne(mappedBy = "driver")
    private Car car;

    // Getters and Setters
}
```
# Task
- Implement the Car and Driver classes with the above one-to-one relationship.
- Create a JPA repository for both Car and Driver.
- Write a service that persists both a Car and a Driver object into the database, ensuring the one-to-one relationship is enforced.
-------------------------------------

### 2. One-to-Many Relationship
**Problem Statement**
- A single driver may own multiple cars, but each car has only one owner. This establishes a one-to-many relationship between Driver and Car.

**Goal**
Implement a one-to-many relationship between the Driver and Car entities.

**Steps**
- Define the Driver entity, which includes a collection of Car objects.
- Define the Car entity to reference a single Driver.
- Annotate the relationship using @OneToMany and @ManyToOne.

  ```java
@Entity
public class Driver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private int experience;

    @OneToMany(mappedBy = "driver", cascade = CascadeType.ALL)
    private List<Car> cars = new ArrayList<>();

    // Getters and Setters
}

```
```java

@Entity
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String model;

    @ManyToOne
    @JoinColumn(name = "driver_id")
    private Driver driver;

    // Getters and Setters
}
```
## Task
- Update the Driver and Car classes with a one-to-many relationship.
- Ensure that when a Driver is persisted, the associated cars are also persisted.
- Write test cases to verify the one-to-many relationship.

--------------------------------------------

### 3. Many-to-Many Relationship
**Problem Statement**
A driver can have multiple cars, and a car can be shared by multiple drivers. This establishes a many-to-many relationship between Driver and Car.

**Goal**
Implement a many-to-many relationship between the Driver and Car entities.

**Steps**
- Define the Driver entity, which includes a collection of Car objects.
- Define the Car entity, which includes a collection of Driver objects.
- Use the @ManyToMany annotation to establish the many-to-many relationship.
- Use a join table to manage the relationship.

**Example**

```java
@Entity
public class Driver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private int experience;

    @ManyToMany
    @JoinTable(
        name = "driver_car",
        joinColumns = @JoinColumn(name = "driver_id"),
        inverseJoinColumns = @JoinColumn(name = "car_id")
    )
    private List<Car> cars = new ArrayList<>();

    // Getters and Setters
}

@Entity
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String model;

    @ManyToMany(mappedBy = "cars")
    private List<Driver> drivers = new ArrayList<>();

    // Getters and Setters
}



```
## Task
- Implement the Driver and Car classes with the many-to-many relationship.
- Use a JoinTable to manage the association.
- Write a service to demonstrate the many-to-many association by creating and assigning multiple drivers to multiple cars.

--------------------------------------
## Deliverables

### 1. One-to-One Relationship:

- JPA entities for Car and Driver.
- A service that demonstrates the one-to-one relationship.
- One-to-Many Relationship:

### 2. JPA entities for Car and Driver.
- A service that demonstrates the one-to-many relationship.
- Many-to-Many Relationship:

### 3. JPA entities for Car and Driver.
- A service that demonstrates the many-to-many relationship.

---------------------------------------------------------------

## Bonus Task (Optional)
Implement a REST API using Spring Boot to expose endpoints for each association, enabling the creation, retrieval, and management of cars and drivers through the API.

