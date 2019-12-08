#### 子查询
> 1. 查询的嵌套
> 2. 解决表间无关联，不好查询问题


##### 独立子查询
> 不依赖于外部查询
```sql
SELECT
    customerNumber,
    checkNumber,
    amount
FROM
    payments
WHERE
    amount > (SELECT
               AVG(amount)
             FROM
             payments);
```


##### 关联子查询
> 依赖于外部查询
```sql
SELECT
    productname,
    buyprice
FROM
    products p1
WHERE
    buyprice > (SELECT
            AVG(buyprice)
        FROM
            products
        WHERE
            productline = p1.productline);
```


##### 派生表
> 1. 独立子查询做为表，跟在`FROM`后面
> 2. 必须给别名
```sql
SELECT
    productName, sales
FROM
    (SELECT
        productCode,
        ROUND(SUM(quantityOrdered * priceEach)) sales
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY productCode
    ORDER BY sales DESC
    LIMIT 5) top5products2003
INNER JOIN
    products USING (productCode);
```