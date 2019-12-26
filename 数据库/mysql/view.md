#### 视图
> 1. 物理上并不存在，本质是数据库服务器存储的sql
> 2. 大多数时候可以像常规表一样使用
> 3. 可以插入/删除数据（PS: 前提无聚会函数、子查询、去重等属于一对一关系时）
> 4. 可在视图上再创建视图
> 5. 视图算法
> * merge 效能好（但只有简单查询<字段一对一>可用）
> * temptable 执行时要先创建临时表，效能差
> * undefined 默认,会自动在merge和temptable间切换 


##### 创建视图
```sql
CREATE VIEW vps AS
    SELECT
        employeeNumber,
        lastName,
        firstName,
        jobTitle,
        extension,
        email,
        officeCode,
        reportsTo
    FROM
        employees
    WHERE
        jobTitle LIKE '%VP%'
WITH CHECK OPTION;  -- 添加 with check opition 保证视图只能修改自身可见（这里即 jobTitle 匹配vp）的数据 
```


##### 删除视图
```sql
DROP VIEW IF EXISTS customerPayments;
```


##### 重命名视图
```sql
RENAME TABLE parts TO new_parts;
```


##### 检查视图
```sql
CHECK TABLE customerPayments;
```


##### 查看视图创建
```sql
SHOW CREATE VIEW parts;
```
