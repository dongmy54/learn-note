#### 表级增删改

##### CREATE
```sql
# 标准创建
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
);
```
```sql
# SELECT 取数
CREATE TABLE test_cs
SELECT productLine
FROM 
  products;
```
```sql
# 按其它表-结构创建
CREATE TABLE customers_archive
LIKE customers;
```


##### INSERT
> 1. `ON DUPLICATE KEY UPDATE`处理插入重复
> 2. `INSERT IGNORE INTO` 有效才插入（不中断）
```sql
# 标准
INSERT INTO tasks(title, priority)
VALUES
    ('My first task', 1),
    ('It is the second task',2),
    ('This is the third task of the week',3),
    ('my taks', DEFAULT);  # 这里DEFAULT 代表使用默认值
```
```sql
# SELECT 取数
INSERT INTO suppliers (
    supplierName, 
    phone, 
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT 
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state ,
    postalCode,
    country,
    customerNumber
FROM 
    customers
WHERE 
    country = 'USA' AND 
    state = 'CA';
```


##### UPDATE
> `UPDATE IGNORE`有效才更新
```sql
# 标准
UPDATE employees 
SET 
    lastname = 'Hill',
    email = 'mary.hill@classicmodelcars.com'
WHERE
    employeeNumber = 1056;
```
```sql
-- join 跨表更新
UPDATE employees
        INNER JOIN
    merits ON employees.performance = merits.performance
SET
    salary = salary + salary * percentage;
```


##### DELETE
> 如果表创建时指定了`ON DELETE CASCADE`(外键关联删除),则引用表数据会自动删除
```sql
# 标准
DELETE FROM employees
WHERE
    officeCode = 4;
```
```sql
-- join 跨表删除
DELETE T1
FROM T1
        LEFT JOIN
    T2 ON T1.key = T2.key
WHERE
    T2.key IS NULL;
```


##### DROP
```sql
# 删除表
DROP TABLE sales;

# 存在才删除
DROP TABLE IF EXISTS t1;
```



