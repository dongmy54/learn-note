#### 时间函数

##### DATE YEAR MONTH QUARTER DAY
> 日期 年月日季度转换

```sql
-- 其它还有 HOUR MINUTE SECOND
SELECT DATE(NOW()) date_time,
       DAY('2000-12-31') day,
       MONTH('2000-12-31') month,
       QUARTER('2000-12-31') quarter,
       YEAR('2000-12-31') year;
```


##### WEEKDAY、 WEEKOFYEAR
> 星期、日历周

```sql
SELECT
    WEEKDAY('2000-12-31') weekday,
    WEEK('2000-12-31') week,
    WEEKOFYEAR('2000-12-31') weekofyear;
```

##### NOW 当前详细时间
```sql
SELECT NOW();
```

##### CURRENT_TIME
> 当前时间

```sql
SELECT CURRENT_TIME();
```


##### CURRENT_DATE
```sql
-- 当前日期
SELECT CURRENT_DATE();
```


###### DATE_ADD 加减天

```sql
-- 加时间
SELECT
    '2015-01-01' start,
    DATE_ADD('2015-01-01', INTERVAL 1 DAY) 'one day later',
    DATE_ADD('2015-01-01', INTERVAL 1 WEEK) 'one week later',
    DATE_ADD('2015-01-01', INTERVAL 1 MONTH) 'one month later',
    DATE_ADD('2015-01-01', INTERVAL 1 YEAR) 'one year later';

-- 减时间
SELECT
    '2015-01-01' start,
    DATE_SUB('2015-01-01', INTERVAL 1 DAY) 'one day before',
    DATE_SUB('2015-01-01', INTERVAL 1 WEEK) 'one week before',
    DATE_SUB('2015-01-01', INTERVAL 1 MONTH) 'one month before',
    DATE_SUB('2015-01-01', INTERVAL 1 YEAR) 'one year before';
```


###### ADDTIME/SUBTIME 加减时间
```sql
SELECT
    CURRENT_TIME(),
    ADDTIME(CURRENT_TIME(), 023000),
    SUBTIME(CURRENT_TIME(), 023000);
```


###### DATEDIFF 时间间隔天
```sql
SELECT DATEDIFF('2015-11-04','2014-11-04') days;
```


###### TIME_FORMAT 格式化时间
> DATE_FORMATE同理
```sql
SELECT
    name,
    TIME_FORMAT(start_at, '%h:%i %p') start_at,
    TIME_FORMAT(end_at, '%h:%i %p') end_at
FROM
    tests;

-- %h 小时 0-12
-- %i 分
-- %p AM / PM

select DATE_FORMAT(NOW(),'_%Y_%m_%d_%H_%i_%s');
```


