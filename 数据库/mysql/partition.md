#### 一、什么是分区
分区不同于分表，它在应用层看起来是一张表，在底层是一个个分区，在查询、插入的时候，根据分区规则，数据库自动决定到哪个分区去操作。

分区一般有：
1. 水平分区：行分区，将不同的行归到一个分区中（PS: mysql 当前只支持水平分区）
2. 垂直分区：列分区，将不同的列归到一个分区中

#### 二、分区适用场景
1. 数据量较大，常规索引已经不太好使
2. 数据量虽然大，但是常查询的数据一般都是最后部分的热点数据（比如：日志等）

#### 三、分区使用
说明：这里以mysql中的使用展示

##### 1. 分区类型
mysql中支持分分区类型有:
- range(PS: 最为常用,一般配合函数使用)
- hash
- list
- key

##### 2. 分区创建/删除/更新
```sql
--  创建分区
create table lock_events(
  id int(11),
  content varchar(255),
  created_at datetime not null
) partition by range (year(created_at))(
  partition lock_events_2019 values less than (2020),
  partition lock_events_2020 values less than (2021),
  partition lock_events_2021 values less than (2022),
  partition lock_events_2022 values less than (2023),
  partition lock_events_up_2023 values less than maxvalue
);

insert into lock_events(id, content, created_at)
values (1, '测试1', '2022-1-2'),
       (2, '测试2', '2021-1-2'),
       (3, '测试3', '2020-3-8'),
       (4, '测试四', '2019-6-9'),
       (5, '测试6', '2026-8-9');

# 删除分区
alter table lock_events drop partition lock_events_up_2023;
# 新增分区
alter table lock_events add partition(partition lock_events_2023 values less than (2024));
```
##### 3.分区创建约束
mysql主要约束有两个：
```sql
-- 1. 分区字段必须是主键/唯一索引中的一部分
CREATE TABLE userslogs (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL,
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL,
    PRIMARY KEY(id, created),
    UNIQUE KEY (username)
)
PARTITION BY HASH( TO_DAYS(created) )
PARTITIONS 10;

-- 这里由于created_at 不在unique key中所以会失败
-- ERROR 1503 (HY000): A UNIQUE INDEX must include all columns in the table's partitioning function

-- 2. 不支持外键
CREATE TABLE orders (
    order_id int NOT NULL,
    order_number int NOT NULL,
    user_id int,
    created DATETIME NOT NULL,
    PRIMARY KEY (order_id,created),
    FOREIGN KEY (user_id) REFERENCES users(id)
) PARTITION BY HASH( TO_DAYS(created) )
PARTITIONS 10;

-- ERROR 1506 (HY000): Foreign keys are not yet supported in conjunction with partitioning
```

#### 四、分区原理
分区的原理：一般是通过分区字段，定位属于哪个分区再去操作；所以：
1. 操作分区表一般要带上分区字段的过滤，否则会查所有分区
2. 对于跨分区的操作，比如统计，建议一个分区一个分区的统计，然后汇总

#### 五、分区索引
一般而言，在表上建立好索引后，会自动在各个分区上建立相应索引；但是对于psql而言，10以下版本，不支持分区全局索引，只能在单个分区上一一创建

