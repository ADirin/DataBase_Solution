# JPA Exercise: Tracking Student Time Spent in DBS Class

## Objective
Create a JPA-based application to manage student data and track the time they spend on:
- Homework  
- In-class activities  
- Theory  

Use **entity classes**, **relationships**, and "DAO" to perform CRUD operations.

---

## Requirements

### **1. Entity Classes**
Create the following entity classes:  

#### **Student**
Represents a student in the DBS class.  

#### **TimeSpent**
Represents the time a student spends on:  
- Homework  
- In-class activities  
- Theory  

---

### **2. Attributes**

#### **Student Entity**
| Attribute      | Type        | Description                              |
|---------------|------------|------------------------------------------|
| `id`         | `Long`      | Primary key (auto-generated)            |
| `name`       | `String`    | Student name                            |
| `email`      | `String`    | Student email                           |
| `timeSpentList` | `List<TimeSpent>` | List of time spent by the student |

#### **TimeSpent Entity**
| Attribute      | Type        | Description                              |
|---------------|------------|------------------------------------------|
| `id`         | `Long`      | Primary key (auto-generated)            |
| `homeworkHours` | `int`     | Time spent on homework                  |
| `inClassHours` | `int`     | Time spent in class                     |
| `theoryHours` | `int`     | Time spent on theory                    |
| `student`    | `Student`   | Many-to-one relationship with `Student` |

---

### **3. Relationships**
- A **Student** can have **multiple** `TimeSpent` records (**one-to-many** relationship).  
- Each **TimeSpent** record belongs to **one** `Student` (**many-to-one** relationship).  

--

### **Apply DAOclass**
1. **Find a student.**  
3. **Add new students.**  
4. **update a student**  

