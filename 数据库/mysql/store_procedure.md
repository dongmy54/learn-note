#### 存储过程
> 1. 类似于编程语言（有变量、判断、循环等等）
> 2. 与存储函数区别在于（存储函数只能返回单个值）


##### 创建存储过程
```sql
DDELIMITER // -- 定界符（目的区分于;)
 
CREATE PROCEDURE GetOfficeByCountry(
    IN countryName VARCHAR(255) --这里定义参数
)
BEGIN
    SELECT *
    FROM offices
    WHERE country = countryName;
END //
 
DELIMITER;
```


##### 使用存储过程
```sql
CALL GetAllProducts();
```


#####删除存储过程
```sql
DROP PROCEDURE IF EXISTS abc;
```
