#### IF
```sql
SELECT IF(orderYear > 2004, '大于2004年', orderYear) 
FROM sales;
```

#### CASE
> 情形展示
```sql
SELECT
  CASE
    when priceEach < 60 THEN '低价'
    when priceEach BETWEEN 60 AND 120 THEN '中价'
    WHEN priceEach > 120 THEN '高价'
  END
FROM
  orderDetails;
```


#### CAST
> 类型转换
```sql
SELECT CAST('2003-01-01' AS DATE);
```


#### CONCAT_WS
> 连接多个信息

```sql
SELECT CONCAT_WS('-', firstname, lastname)
FROM employees;
```


#### IFNULL
> 如果为null替换

```sql
SELECT
  firstName,
  IFNULL(reportsTo, '无上级')
FROM
  employees;
```


#### YEAR
> 转年份
```sql
SELECT
  YEAR(created_at) AS year
FROM
  users LIMIT 1;
```

#### FLOOR
> 取整（非四舍五入）
```sql
SELECT FLOOR(34.6); /* 输入34 */
```





