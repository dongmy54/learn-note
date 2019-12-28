#### 存储过程
> 只能返回一个值，通常用于做一些特定的计算

##### 创建
```sql
DELIMITER $$
 
CREATE FUNCTION CustomerLevel(
    credit DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE customerLevel VARCHAR(20);
 
    IF credit > 50000 THEN
        SET customerLevel = 'PLATINUM';
    ELSEIF (credit >= 50000 AND
            credit <= 10000) THEN
        SET customerLevel = 'GOLD';
    ELSEIF credit < 10000 THEN
        SET customerLevel = 'SILVER';
    END IF;

    RETURN (customerLevel); -- 必须要有返回值
END$$
DELIMITER ;
```


##### 使用
```sql
SELECT
    customerName,
    CustomerLevel(creditLimit) -- 直接调用
FROM
    customers
ORDER BY
    customerName;
```
