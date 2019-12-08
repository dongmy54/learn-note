#### 增删改sql

#### CREATE
```sql
# 从其它表中-取数据
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


#### DROP
```sql
# 删除表
DROP TABLE sales;

# 存在才删除
DROP TABLE IF EXISTS t1;
```

