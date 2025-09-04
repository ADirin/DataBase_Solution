# Exercise: Concurrency Challenges in MariaDB Databases
## You may do in pair, bu everybody must submit the assignment.

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
   
Your task is to create product ordering transaction when multiple users order the same time 
````
START TRANSACTION;

-- Lock specific product row for update
   SELECT ....... FOR UPDATE;

-- Update the inventory to deduct the purchased quantity.
UPDATE products
SET inventory = inventory -2
where .......
-- Insert the new order into the orders table.
INSERT INTO orders (user_id, product_id, quantity, total_amount) 
VALUES (5, 1, 2, 1999.98, 'pending');

-- make the transaction permanent


````

2. **Multi-Version Concurrency Control (MVCC)**  
```
-- ALTER TABLE products
ADD version INT NOT NULL DEFAULT 0;

START TRANSACTION;

-- Step 1: Read product data (no locks, just snapshot)
SELECT product_id, price, inventory, version
FROM ...
WHERE product_id = 1;

-- Assume user wants 2 units, and we read version = 5

-- Step 2: Try to update using optimistic check
UPDATE products
SET inventory = inventory - 2,
    version = ....
WHERE product_id = 1
  AND inventory >= 2
  AND version = 5;


INSERT INTO orders (user_id, product_id, quantity, total_amount, order_status)
VALUES (5, 1, 2, 1999.98, 'pending');

-- make the transaction permanent


```

3. **Timestamp-Based Concurrency Control**  
   - Write a query to assign timestamps for transactions and explain how this technique resolves conflicts.
```
ALTER TABLE products
ADD last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP;

START TRANSACTION;

-- Step 1: Read product info with its timestamp
SELECT product_id, price, inventory, last_updated
FROM products
WHERE product_id = 1;

-- Suppose we read last_updated = '2025-09-04 12:00:00'
-- Transaction timestamp = the moment this transaction started

-- Step 2: Attempt to update with timestamp check
UPDATE products
SET inventory = inventory - 2
WHERE product_id = 1
  AND inventory >= 2
  AND last_updated = '2025-09-04 12:00:00';

INSERT INTO orders (user_id, product_id, quantity, total_amount, order_status)
VALUES (5, 1, 2, 1999.98, 'pending');

COMMIT;

```

4. **Optimistic Concurrency Control**  
   - Demonstrate the implementation of a version column in a table to detect conflicts.  
```
START TRANSACTION;

-- Step 1: Read product info (no locks)
SELECT product_id, price, inventory, version
FROM products
WHERE product_id = 1;

-- Suppose: inventory = 10, version = 3
-- We want to buy 2 units

-- Step 2: Update with optimistic check
UPDATE products
SET inventory = inventory - 2,
    version = version + 1
WHERE product_id = 1
  AND inventory >= 2
  AND version = 3;


INSERT INTO orders (user_id, product_id, quantity, total_amount, order_status)
VALUES (5, 1, 2, 1999.98, 'pending');

COMMIT;


```

5. **Pessimistic Concurrency Control**  
   - Use `LOCK IN SHARE MODE` to demonstrate pessimistic locking in MariaDB.
  
```
START TRANSACTION;

-- Step 1: Lock the product row
SELECT price, inventory
FROM products
WHERE product_id = 1
;


-- Step 2: Deduct stock
UPDATE products
SET inventory = inventory - 2
WHERE product_id = 1;

-- Step 3: Insert the order
INSERT INTO orders (user_id, product_id, quantity, total_amount, order_status)
VALUES (5, 1, 2, 1999.98, 'pending');


```

### Questions:
- What are the advantages and disadvantages of each technique in high-concurrency systems?  
- Which technique would you recommend for the e-commerce platform described in Part 1? Why?

---

## Part 3: Extending the Scenario with Views

### Task:
Create a **view** to manage the inventory display for the e-commerce platform. 


---

## Deliverables:
- SQL scripts for implementing each technique.  
- Screen shots of the resulted transactions.
- Create a PDF file and submit the file in designated folder in Moodle


---
