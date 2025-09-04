# Exercise: Concurrency Challenges in MariaDB Databases

## Objective:
Understand and analyze concurrency challenges in MariaDB databases and explore techniques to manage and overcome these challenges effectively. By the end of the exercise, students will also explore the concept of views in databases.

---

## Part 1: Understanding Concurrency Challenges

### Scenario:
Imagine you are working on a high-traffic e-commerce platform where multiple users simultaneously access and update product inventory.

1. **Concurrency Issues**:  
   - User A attempts to purchase a product, reducing its inventory count.
   - User B simultaneously views and attempts to purchase the same product.  
   - User C queries the current inventory to verify availability.

   **Questions:**
   - What potential issues can arise due to concurrent operations?  
   - How might these issues affect the database's consistency, integrity, and performance?  
   - Identify specific concurrency problems such as **dirty reads**, **non-repeatable reads**, and **phantom reads**.

---

## Part 2: Techniques for Managing Concurrency

### Task:
Match the following techniques with the issues they aim to solve and implement SQL-based examples to demonstrate their use in MariaDB.
#### Sample Tables if you want to try the syntax
````
-- Create products table first (since orders will reference it)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    inventory INT NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create orders table with proper foreign key syntax
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
   
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data into products table
INSERT INTO products (product_name, description, price, inventory) VALUES
('Laptop', 'High-performance gaming laptop', 999.99, 10),
('Smartphone', 'Latest smartphone model', 499.99, 25),
('Headphones', 'Wireless noise-cancelling headphones', 199.99, 50),
('Mouse', 'Wireless computer mouse', 29.99, 100),
('Keyboard', 'Mechanical gaming keyboard', 89.99, 30);

-- Sample data for orders
INSERT INTO orders (user_id, product_id, quantity, total_amount, order_status) VALUES
(1, 1, 1, 999.99, 'delivered'),
(1, 3, 2, 399.98, 'shipped'),
(2, 2, 1, 499.99, 'confirmed'),
(3, 4, 3, 89.97, 'pending');

````

### Techniques:
1. **Locks (Pessimistic Concurrency Control)**  
   - Write an example of using `LOCK TABLES` in MariaDB to prevent concurrent access to the same table.  

````
LOCK TABLES Products WRITE, orders Write;
START TRANSACTION;
_YOUR code here...
 



COMMIT:
UNLOCK TABLES

````

2. **Multi-Version Concurrency Control (MVCC)**  
   - Explain how MVCC helps resolve conflicts using snapshots of data.  
   - Use `SELECT ... FOR UPDATE` or `READ COMMITTED` isolation level to illustrate MVCC in action.  

3. **Timestamp-Based Concurrency Control**  
   - Write a query to assign timestamps for transactions and explain how this technique resolves conflicts.

4. **Optimistic Concurrency Control**  
   - Demonstrate the implementation of a version column in a table to detect conflicts.  
   - Write an SQL transaction that handles conflict resolution optimistically.

5. **Pessimistic Concurrency Control**  
   - Use `LOCK IN SHARE MODE` to demonstrate pessimistic locking in MariaDB.

### Questions:
- What are the advantages and disadvantages of each technique in high-concurrency systems?  
- Which technique would you recommend for the e-commerce platform described in Part 1? Why?

---

## Part 3: Extending the Scenario with Views

### Task:
Create a **view** to manage the inventory display for the e-commerce platform.

1. **Scenario Extension:**
   - Managers want a consistent view of all products' inventory for reporting purposes.  
   - Users should only see products available for sale, without being affected by uncommitted changes from other users.

2. **Steps:**
   - Write an SQL query to create a view that displays product names, available inventory, and last updated timestamps.  
   - Ensure the view reflects data consistency by choosing the appropriate concurrency technique (e.g., use MVCC for consistent snapshots).

3. **Questions:**
   - How does the use of views help in managing database concurrency?  
   - What are the potential limitations of views in this context?  
   - Discuss the impact of using views with different isolation levels.

---

## Deliverables:
- SQL scripts for implementing each technique.  
- SQL code to create and query the view.
- Create a PDF file and submit the file in designated folder in Moodle


---
