# Indexing in Databases

## Table of Contents
1. [Introduction](#introduction)
2. [Why Use Indexes?](#why-use-indexes)
3. [Types of Indexes](#types-of-indexes)
    - [Primary Index](#primary-index)
    - [Secondary Index](#secondary-index)
    - [Unique Index](#unique-index)
    - [Bitmap Index](#bitmap-index)
    - [Full-Text Index](#full-text-index)
4. [Index Structures](#index-structures)
    - [B-Tree Index](#b-tree-index)
    - [Hash Index](#hash-index)
    - [Bitmap Index Structure](#bitmap-index-structure)
5. [Design Considerations](#design-considerations)
    - [Choosing Columns to Index](#choosing-columns-to-index)
    - [Index Maintenance](#index-maintenance)
    - [Indexing and Performance](#indexing-and-performance)
6. [Examples](#examples)
7. [Best Practices](#best-practices)
8. [Conclusion](#conclusion)
9. [Further Reading](#further-reading)

## Introduction
Indexing is a technique used in databases to improve the speed of data retrieval operations. An index is a data structure that allows for fast access to the rows in a table based on the values of one or more columns.

## Why Use Indexes?
- **Improve Query Performance:** Indexes significantly reduce the amount of data that needs to be scanned for query execution.
- **Enhance Search Speed:** They make data retrieval operations faster.
- **Efficient Sorting:** Indexes can be used to speed up sorting and ordering of query results.
- **Enforce Uniqueness:** Unique indexes ensure that no duplicate values are entered in specific columns.

## Types of Indexes
### Primary Index
- **Definition:** An index on a set of fields that includes the unique primary key.
- **Example:** Index on the `EmployeeID` column in an `Employees` table.

### Secondary Index
- **Definition:** An index that is not a primary index and can be on any field or combination of fields.
- **Example:** Index on the `LastName` column in an `Employees` table.

### Unique Index
- **Definition:** An index that ensures all the values in the indexed column are unique.
- **Example:** Unique index on the `Email` column in a `Users` table.

### Bitmap Index
- **Definition:** An index that uses bitmaps and is efficient for columns with a low cardinality.
- **Example:** Bitmap index on the `Gender` column in a `Customers` table.

### Full-Text Index
- **Definition:** An index that allows for efficient searching of text within large text columns.
- **Example:** Full-text index on the `Description` column in a `Products` table.
-------------------------------------------------------------------------------------------------------------------------------------------
### Dense Indexing
- **Definition:** is a type of indexing in databases where an index entry is created for every single record in the table
_ **Example:**
# Dense Indexing

Dense indexing is a type of indexing in databases where an index entry is created for every single record in the table. This contrasts with sparse indexing, where index entries are created for only some records, usually those at certain intervals.

## Key Concepts of Dense Indexing

1. **Every Record Indexed**: In dense indexing, each record in the table has a corresponding entry in the index. This ensures that every value of the indexed column is directly associated with a specific index entry.
2. **Index Size**: Dense indexes can be larger than sparse indexes because they contain entries for every row in the table. However, they provide faster access to data because every index entry points directly to a record.
3. **Use Case**: Dense indexing is useful when queries frequently access specific records and require quick lookups, such as when searching by a unique identifier.

## Example of Dense Indexing

Let’s illustrate dense indexing with a practical example using a `students` table.

### Table Structure

Imagine a simple table `students` with the following structure:

| student_id | name         | age | major            |
|------------|--------------|-----|------------------|
| 1          | Alice Smith  | 20  | Computer Science |
| 2          | Bob Johnson  | 22  | Mathematics      |
| 3          | Carol White  | 19  | Physics          |
| 4          | David Brown  | 21  | Chemistry        |

### Dense Index on `student_id`

To create a dense index on the `student_id` column, where each `student_id` is unique, you would have:

**Index Structure:**

| student_id | Row Pointer      |
|------------|------------------|
| 1          | Pointer to Row 1 |
| 2          | Pointer to Row 2 |
| 3          | Pointer to Row 3 |
| 4          | Pointer to Row 4 |

**SQL to Create Dense Index:**

```sql
CREATE INDEX idx_student_id ON students (student_id);
```


### How Dense Indexing Works
- Insert Operation: When you insert a new student record into the students table, the dense index automatically includes a new entry for this student_id.
- Search Operation: To find a student by student_id, the index provides a direct pointer to the exact record, making the retrieval operation very efficient.

Example Query:
To find the record for student_id = 3, the database would use the dense index to directly access Row 3:



```sql
SELECT * FROM students WHERE student_id = 3;

```
The index entry for student_id = 3 provides the exact location of the record in the table, resulting in quick retrieval.

### Advantages of Dense Indexing
  - Efficient Lookups: Each query for an indexed value is very efficient because the index provides a direct reference to the record.
  - Consistency: Useful for unique or near-unique columns where every row needs to be quickly accessible.
  - Simplified Index Management: Since every record is indexed, there's no need to manage gaps in the index.
### Disadvantages of Dense Indexing
  - Storage Overhead: The index can become large, especially for tables with many rows, consuming additional storage.
  - Update Overhead: Every insert, update, or delete operation requires updating the index, which can impact performance in write-heavy scenarios.


## thin(Sparse) Indexing
- **Definition:** is a type of indexing in databases where index entries are created for only some records, usually those at certain intervals.
_ **Example:**

# Thin Indexing Example

**Thin indexing**, also known as **sparse indexing**, involves creating index entries for only a subset of the records in a table rather than every record. This approach can save space and improve performance when dealing with large tables or infrequent query patterns. Unlike **dense indexing**, where every record has an index entry, thin indexing creates entries for only some records, often at regular intervals.

## Example of Thin Indexing

Consider a `products` table in a database where you want to create a sparse index on the `product_id` column. Instead of indexing every record, you might choose to index every 100th record.

### Table Structure

Let’s assume the `products` table has the following columns:

| product_id | name          | price | category_id |
|------------|---------------|-------|-------------|
| 1          | Widget A       | 10.99 | 1           |
| 2          | Widget B       | 12.99 | 1           |
| 3          | Widget C       | 8.99  | 2           |
| 4          | Widget D       | 15.99 | 2           |
| ...        | ...           | ...   | ...         |
| 1000       | Widget Z       | 9.99  | 3           |

### Creating a Thin Index

**Objective**: Create an index on `product_id`, but only for every 100th record.

**Index Structure:**

In a thin index, entries are not created for every record but at intervals. For instance:

| product_id | Row Pointer   |
|------------|---------------|
| 100        | Pointer to Row 100 |
| 200        | Pointer to Row 200 |
| 300        | Pointer to Row 300 |
| ...        | ...               |

**SQL to Create a Sparse Index:**

Thin indexing usually involves a custom approach because standard SQL indexing mechanisms don’t support this directly. However, you can create a standard index and then selectively manage it to simulate thin indexing.

1. **Create a Full Index:**

   Create a full index first for all records.
   ```sql
   CREATE INDEX idx_product_id ON products (product_id);

   ```

2. Implement Custom Indexing Logic:
    To simulate thin indexing, you would manually manage the index entries based on your requirements. For instance, if you're using a custom application or script, you could only query and     maintain index entries at certain intervals.

3. Use a Secondary Table (Example):
    Create a secondary table to store index entries at desired intervals:

```sql

CREATE TABLE sparse_index (
    product_id INT PRIMARY KEY,
    row_pointer INT
);

-- Populate the sparse index manually or via a script
INSERT INTO sparse_index (product_id, row_pointer)
SELECT product_id, ROW_NUMBER() OVER (ORDER BY product_id)
FROM products
WHERE MOD(product_id, 100) = 0;
```
In this example, only every 100th record is indexed. This is a simplified representation, and in practice, you would use a more automated approach to maintain and query such sparse indexes.

Querying with Thin Index
When querying the products table, you would look up the sparse_index table first to find a pointer or record efficiently.

Example Query:
```sql
SELECT * FROM products
WHERE product_id IN (SELECT product_id FROM sparse_index WHERE product_id = 200);


```
### Advantages of Thin Indexing
1. Space Efficiency: Consumes less space compared to dense indexing as it only includes a subset of the records.
2. Reduced Overhead: Decreases the overhead associated with maintaining the index, especially in write-heavy scenarios.

### Disadvantages of Thin Indexing
1. Potential Performance Trade-Off: Accessing records that are not directly indexed might be slower, as additional lookups or scans are required.
2. Complexity in Management: Requires custom logic to maintain and query the sparse index effectively.
---------------------------------------------------------------------------------------------------------------------------------------------------------
## Index Structures
### B-Tree Index
- **Definition:** A balanced tree data structure that maintains sorted data and allows for efficient insertion, deletion, and search operations.
- **Usage:** General-purpose indexing, especially for range queries.

- > [Watch this youtube video]([[https://www.youtube.com/watch?v=VIDEO_ID](https://www.youtube.com/watch?v=aZjYr87r1b8&t=2232s)



### Hash Index
- **Definition:** An index that uses a hash table to map keys to their corresponding values.
- **Usage:** Exact match queries, not suitable for range queries.

### Bitmap Index Structure
- **Definition:** An index that uses bitmaps to represent the presence or absence of a value.
- **Usage:** Columns with low cardinality, such as gender or boolean fields.

## Design Considerations
### Choosing Columns to Index
- **Frequency of Use:** Index columns that are frequently used in WHERE clauses, JOIN conditions, and ORDER BY clauses.
- **Selectivity:** Choose columns with high selectivity, where the indexed column values are unique or have few duplicates.
- **Update Frequency:** Be cautious with indexing columns that are frequently updated, as this can degrade performance.

### Index Maintenance
- **Rebuilding Indexes:** Regularly rebuild indexes to defragment and optimize them.
- **Monitoring:** Continuously monitor index usage and performance to ensure they are beneficial.

### Indexing and Performance
- **Trade-offs:** While indexes improve read performance, they can slow down write operations.
- **Size Considerations:** Indexes take up additional disk space, so balance the number and size of indexes.

## Examples
### Example 1: Employee Database

**Creating an Index on `LastName`:**
```sql
CREATE INDEX idx_lastname ON Employees (LastName);
````
Creating a Unique Index on Email:
```sql

CREATE UNIQUE INDEX idx_email ON Users (Email);
````
### Example 2: E-commerce Database
Creating a Full-Text Index on ProductDescription:

```sql
CREATE FULLTEXT INDEX ft_idx_description ON Products (Description);
````
Creating a Bitmap Index on Category:

```sql
CREATE BITMAP INDEX idx_category ON Products (Category);
````


# Best Practices
Use Indexes Sparingly: Index only those columns that will benefit the most from indexing.
Composite Indexes: Use composite indexes for queries that filter on multiple columns.
Analyze Query Patterns: Regularly analyze and optimize query patterns to determine the need for indexes.
Monitor Performance: Continuously monitor the performance impact of indexes and adjust as necessary.
Conclusion
Indexing is a powerful tool for improving database performance, but it must be used judiciously. 
By understanding the different types of indexes and their use cases, you can design an efficient indexing strategy that balances the benefits and trade-offs.


# [Further study at](https://favtutor.com/blogs/index-sql)
Further Reading
Database Indexing Basics
Index Types in SQL Server
Oracle Indexing Techniques
