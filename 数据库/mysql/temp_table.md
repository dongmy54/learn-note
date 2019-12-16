#### 临时表
> 1. 相对于session,session断开、临时表失效
> 2. 创建临时表后，使用完记得删除


##### 用法
```sql
CREATE TEMPORARY TABLE top_customers
SELECT p.customerNumber,
       c.customerName,
       ROUND(SUM(p.amount),2) sales
FROM payments p
INNER JOIN customers c ON c.customerNumber = p.customerNumber
GROUP BY p.customerNumber
ORDER BY sales DESC
LIMIT 10;  -- 创建


SELECT
    customerNumber,
    customerName,
    sales
FROM
    top_customers
ORDER BY sales; -- 使用 

DROP TEMPORARY TABLE top_customers; -- 删除
```

