##### 说明
> mysql中无内置布尔型, 用 1 代表 `true` 0 代表 `false`


##### SELECT
```sql
SELECT orderNumber, status FROM orders;
```

##### WHERE
> 1. `IS NULL` 为null
> 2. `!=`/`<>` 不等于

```sql
SELECT
    firstName,
    lastName
FROM
    employees
WHERE
    lastName LIKE '%son'
```


##### JOIN
> 1. mysql中无 full join
> 2. 支持 `CROSS JOIN` 交叉join

```sql
SELECT
    m.member_id,
    m.name member
FROM
    members m
LEFT JOIN committees c USING(name)
WHERE c.committee_id IS NULL;
```

```sql
SELECT
    m.member_id,
    m.name member,
    c.committee_id,
    c.name committee
FROM
    members m
CROSS JOIN committees c;
```


##### IN
```sql
# 搭配子查询
SELECT    
    orderNumber,
    customerNumber,
    status,
    shippedDate
FROM    
    orders
WHERE orderNumber IN
(
     SELECT
         orderNumber
     FROM
         orderDetails
     GROUP BY
         orderNumber
     HAVING SUM(quantityOrdered * priceEach) > 60000
);
```

##### LIKE
> 1. `%` 0个或多个任意字符
> 2. `_` 任意一个字符
> 3. `\`转义


##### LIMIT
> 其与postgresql稍微不同 `LIMIT 偏移值, 条数`

```sql
SELECT
    customerNumber,
    customerName
FROM
    customers
ORDER BY customerName    
LIMIT 10, 10;
```
```sql
# 兼容postgresql写法
SELECT
    customerNumber,
    customerName
FROM
    customers
ORDER BY customerName    
LIMIT 10 OFFSET 10;
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


##### BETWEEN
> 默认包含等于临界值

```sql
SELECT
    productCode,
    productName,
    buyPrice
FROM
    products
WHERE
    buyPrice NOT BETWEEN 20 AND 100;
```

##### IS NULL
```sql
# 设置不为空时 默认值
SET @@sql_auto_is_null = 0;
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











