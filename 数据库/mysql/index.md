#### 索引

##### 建立索引列
> 1. where =(equal)值
> 2. where range(>=< between 等)值
> 3. group by 所有值
> 4. order by 所有值

##### 原则
> 1. 一张表索引不要加太多，经验值5
> 2. 低基数（区分度较低的列，比如： true/false 0,1,2）用复合索引更好
> 3. 复合索引优于单列索引

##### 索引不生效情况
> 1. 使用函数/表达式
> 2. 查询时字段类型与索引列类型不同
> 3. 排序混合desc、asc
> 4. 复合索引不带首列


##### 索引相关操作
```sql
CREATE TABLE IF NOT EXISTS users1 (
    id INT AUTO_INCREMENT,
    city VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    age INT,
    PRIMARY KEY (id)
);

// 创建
Create index idx_city_age_name on users1(city,name,age);

// 展示
show index from users1;

INSERT INTO users1(city, name, age)
VALUES
    ('成都', '张三', 21),
    ('绵阳', '李四', 26),
    ('西安', '王五', 23),
    ('成都', '张六', 25);  # 这里DEFAULT 代表使用默认值

// 删除
drop index idx_city_age_name on users1;

create index idx_age on users1(age);
```
