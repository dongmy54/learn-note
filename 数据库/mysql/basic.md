#### 基本

##### SELECT
```sql
SELECT orderNumber, status FROM orders;
```

##### ORDER BY
```sql
SELECT
    contactLastname,
    contactFirstname
FROM
    customers
ORDER BY
    contactLastname DESC,
    contactFirstname ASC;
```

```sql
# FIELD函数按照 列表排序
SELECT
    orderNumber,
    status
FROM
    orders
ORDER BY
    FIELD(status,
        'In Process',
        'On Hold',
        'Cancelled',
        'Resolved',
        'Disputed',
        'Shipped');
```

##### WHERE
> 1. `LIKE`  模糊匹配 `%`（0个/多个任意字符）`_`（1个任意字符）
> 2. `IN (1,2,3)` 包含
> 3. `IS NULL` 为null
> 4. `!=`/`<>` 不等于

```sql
SELECT
    firstName,
    lastName
FROM
    employees
WHERE
    lastName LIKE '%son'
```