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
> 3. 自join的本质是，把自己也看作另外一张表

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


##### GROUP BY
> mysql支持对别名聚合

```sql
SELECT
    YEAR(orderDate) AS year,
    COUNT(orderNumber)
FROM
    orders
GROUP BY
    year; /* 对别名聚合 */
```


##### HAVING
> 对分组后结果再次过滤
```sql
SELECT
    ordernumber,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY
   ordernumber
HAVING
   total > 1000;
```


##### LIKE
> 1. `%` 0个或多个任意字符
> 2. `_` 任意一个字符
> 3. `\`转义


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


##### EXISTS
> 1. 大多数时候相比于`IN`性能更好
> PS: 只有一种情况`IN`性能更好,IN出结果很少
```sql
SELECT
    employeenumber,
    firstname,
    lastname
FROM
    employees
WHERE
    EXISTS (SELECT
            1
        FROM
            offices
        WHERE
            offices.city = 'San Francisco' AND offices.officeCode = employees.officeCode);
```


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


##### ROLLUP
> 1. 对`group up`后结果小计
> 2. 8.0以上版本可用 `GROUPING`标记求和列

```sql
SELECT
    orderYear,
    productLine,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY
    orderYear,
    productline
WITH ROLLUP;
```


##### UNION
> 1. 对结果集垂直拼接
> 2. `UNION`默认去重;`UNION ALL`不去重
```sql
SELECT id
FROM t1
UNION
SELECT id
FROM t2;
```


##### json相关查询
```sql
SELECT id, browser->'$.name' browser
FROM events; -- 查询browser列 name键值（返回值包含双引号）

SELECT id, browser->>'$.name' browser
FROM events; -- 查询browser列 name键值（返回值不含双引号）

SELECT visitor, SUM(properties->>'$.amount') revenue
FROM events
WHERE properties->>'$.amount' > 0
GROUP BY visitor; -- 聚会 拜访者金额大于0的
```










