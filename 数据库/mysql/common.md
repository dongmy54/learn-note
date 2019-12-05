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
