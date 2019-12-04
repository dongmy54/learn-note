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

##### DISTINCT
> PS：与 `limit`搭配时,限制的是唯一值条数

```sql
# 组合去重
SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY state,city;
```

```sql
# 去重后聚合
SELECT
    COUNT(DISTINCT state)
FROM
    customers
WHERE
    country = 'USA';
```
















