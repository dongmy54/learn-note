#### 存储过程
> 类似于函数


##### 创建存储过程
```sql
DELIMITER //
 
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT *  FROM products;
END //
 
DELIMITER ;
```


##### 使用存储过程
```sql
CALL GetAllProducts();
```

