#### 其它

##### 准备语句（PREPARED)
> 1. 将查询语句内置在服务器中
> 2. 从而减少多次查询发送过程中服务器解析字符所花费的时间
> 3. 由于采用占位符，还提高了安全性

```sql
-- 用法
--step1 准备语句
PREPARE stmt1 FROM
    'SELECT
           productCode,
            productName
    FROM products
        WHERE productCode = ?';

--step2 设置变量，执行语句
SET @pc = 'S10_1678';
EXECUTE stmt1 USING @pc;

-- 多次使用结束后 释放
DEALLOCATE PREPARE stmt1;
```






