#### 触发器
> 在某个动作触发的时候执行

##### 创建
```sql
-- 定义存储过程 供触发器使用
DELIMITER $
CREATE PROCEDURE `check_parts`(IN cost DECIMAL(10,2), IN price DECIMAL(10,2))
BEGIN
    IF cost < 0 THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'check constraint on parts.cost failed';
    END IF;
    
    IF price < 0 THEN
    SIGNAL SQLSTATE '45001'
       SET MESSAGE_TEXT = 'check constraint on parts.price failed';
    END IF;
    
    IF price < cost THEN
    SIGNAL SQLSTATE '45002'
           SET MESSAGE_TEXT = 'check constraint on parts.price & parts.cost failed';
    END IF;
END$
DELIMITER ;
```

```sql
-- 插入前
DELIMITER $
CREATE TRIGGER `parts_before_insert` BEFORE INSERT ON `parts`
FOR EACH ROW
BEGIN
    CALL check_parts(new.cost,new.price); -- check_partss是存储过程
END$  
DELIMITER ;

-- 更新前
DELIMITER $
CREATE TRIGGER `parts_before_update` BEFORE UPDATE ON `parts`
FOR EACH ROW
BEGIN
    CALL check_parts(new.cost,new.price);
END$  
DELIMITER ;
```


