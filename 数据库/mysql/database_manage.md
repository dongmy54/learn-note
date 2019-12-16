#### 数据库管理

##### CREATE
```sql
CREATE DATABASE IF NOT EXISTS empdb;
```


##### DROP
```sql
DROP DATABASE IF EXISTS temp_database;
```


##### show
```sql
show databases;               -- 展示数据库列表
show create database test1;   -- 展示test1数据库详细信息 
```


##### use
```sql
use classicmodels; -- 使用classicmodels数据库
```


##### database()
```sql
SELECT database();  -- 查看当前数据库
```


