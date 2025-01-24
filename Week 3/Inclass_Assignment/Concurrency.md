# In-Class Exercises on Concurrency  

These exercises are designed to give students hands-on experience with the following topics:  
- **Introduction to Concurrency**  
- **Concurrency Management**  
- **Concurrency Techniques**  
- **Importance of Handling Concurrency**  
- **Race Conditions**  
- **Concept of View**

---

## 1. Introduction to Concurrency  
**Objective**: Understand the concept of concurrency and its relevance in real-world applications.  

### Exercise:  
- **Discussion**: Provide a list of real-world examples where concurrency is applied (e.g., web servers, ticket booking systems, video streaming). Ask students to identify why concurrency is necessary in these examples.  
- **Quick Task**: Write a short Python program that uses `threading` to perform two tasks simultaneously (e.g., downloading a file and printing a progress bar).  

---

## 2. Concurrency Management  
**Objective**: Explore challenges in managing concurrent operations.  

### Exercise:  
- **Scenario Design**: Present a simple scenario (e.g., a shared counter being updated by multiple threads). Students should identify the issues that arise when threads access shared resources without synchronization.  
- **Coding Task**: Modify the provided Python code (using `threading.Lock`) to ensure that updates to the shared counter are thread-safe.  

```python
import threading

counter = 0

def increment_counter():
    global counter
    for _ in range(1000):
        counter += 1

threads = [threading.Thread(target=increment_counter) for _ in range(5)]
for thread in threads:
    thread.start()
for thread in threads:
    thread.join()

print("Final Counter Value:", counter)

```
### 3. Concurrency Techniques
**Objective**: Learn different techniques like locking, semaphores, and message-passing.

#### Exercise:
1. **Research Task**:  
   Divide the class into groups and assign each group a technique (e.g., mutex locks, semaphores, condition variables). Each group prepares a short explanation with an example.

2. **Practical Task**:  
   Write a program to implement producer-consumer using a queue and `threading.Condition`.

---

### 4. Importance of Handling Concurrency
**Objective**: Highlight the importance of proper concurrency handling.

#### Exercise:
1. **Real-World Case Study**:  
   Present a real-world failure caused by concurrency issues (e.g., race conditions in a banking system). Ask students to discuss how proper concurrency handling could have avoided the issue.

2. **Design Challenge**:  
   Given a ticket booking system, ask students to brainstorm ways to ensure no two users can book the same seat simultaneously.

---

### 5. Race Conditions
**Objective**: Identify and resolve race conditions.

#### Exercise:
1. **Debugging Task**:  
   Provide buggy code that suffers from a race condition. Ask students to run it and identify the issue. Then, they should fix the code using synchronization techniques like `threading.Lock` or atomic variables.

2. **Interactive Simulation**:  
   Create a simulation where multiple users try to withdraw money from the same bank account. Students should implement a solution to avoid overdrawing due to race conditions.

---

### 6. Concept of View
**Objective**: Understand how "views" of shared data can differ across threads and processes.

#### Exercise:
1. **Discussion**:  
   Explain how different threads might have stale or inconsistent views of shared data. Ask students to explain why this happens and suggest ways to mitigate it.

2. **Coding Task**:  
   Write a Python program demonstrating the concept of stale data by reading a variable updated in another thread without proper synchronization.

```python
import threading
import time

data = 0

def writer():
    global data
    for i in range(5):
        time.sleep(1)
        data = i
        print(f"Writer updated data to {i}")

def reader():
    while True:
        print(f"Reader sees data as {data}")
        time.sleep(1)

threading.Thread(target=writer).start()
threading.Thread(target=reader).start()
```

### Bonus Challenge Exercise  
**Integrating Concepts**:  

Build a simple concurrent library checkout system where:  
- Users can borrow and return books concurrently.  
- Ensure proper synchronization to prevent race conditions (e.g., borrowing an already borrowed book).  
- Use locks or semaphores to manage concurrency.  

This exercise combines the understanding of concurrency, its challenges, and techniques to manage it effectively.
