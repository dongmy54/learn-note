#### 视图
> 1. 视图物理上并不存在，执行时sql语句去相关表查询
> 2. 优点：
> * 简化复杂查询
> * 安全性更高


##### 创建视图
```sql
CREATE VIEW customerPayments
AS
SELECT
    customerName,
    checkNumber,
    paymentDate,
    amount
FROM
    customers
INNER JOIN
    payments USING (customerNumber);
```


##### 删除视图
```sql
DROP VIEW IF EXISTS customerPayments;
```


##### 检查视图
```sql
CHECK TABLE customerPayments;
```