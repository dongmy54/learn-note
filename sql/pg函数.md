### postgresql 常用语法

#### 时间通识
> *  YYYY-MM-DD HH24:MI:SS  24小时制
> *  YYYY-MM-DD HH12:MI:SS  12小时制

#### to_char函数
> * 用途：按一定格式转换成字符串
> * 用法：to_char(时间戳/时间间隔/整数,字符串)
> * 返回：字符串

```
// 当前时间戳
select to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:30');
// 2018-06-28 18:01:30

// 时间戳
select to_char(timestamp '2018-3-6','YYYY-MM-DD');
// 2018-03-06

// 时间间隔
select to_char(interval '15h 2m 32s','HH24:MI:SS')
// 15:02:32

// 整数（定制一些数据样式）
select to_char(23,'100');
// 1 23
```

#### cast 函数
> * 用途：将数据转换成 某种类型
> *  用法：cast(转换对象,text/timestamp/date/integer/numeric)
> *  返回：返回指定类型
```
// 时间戳转 字符串
select cast(created_at as text) from accounts limit 1;
// 2016-03-31 14:22:50.126631

// 字符串转日期
select cast('2018-6-20 15:30:20' as date);
// 2016-03-31 14:22:50.126631

// 字符串转整数
select cast('23' as integer);
// 23

// 字符串转时间戳
select cast('2018-6-20' as timestamp);
// 2018-06-20 00:00:00

// 字符串转 numeric类型 
select cast('4.3' as numeric);
// 4.3
```

#### to_timestamp 函数
> *  用途：将字符串转换为特定的时间戳格式
> *  用法：to_timestamp(text,text时间格式)
> *  返回：时间戳
> *  PS: 第一个参数只能为字符串

```
// 字符串转 时间戳格式
select to_timestamp('2018-6-20', 'YYYY-MM-DD HH24:MI:SS');
// 2018-06-20 00:00:00+08

SELECT to_timestamp('2014/04/25 10:13:18.041.394820', 'YYYY/MM/DD HH:MI:SS.MS.US');
// 2014-04-25 10:13:18.43582+08

// 将第一个参数转成字符 后 改格式
select to_timestamp(cast (created_at as text),'YYYY-MM-DD') from accounts limit 1;
// 2016-03-31 00:00:00+08
```

#### date_trunc 函数
> * 用途：将时间戳 或 时间间隔 截取到指定精度（该精度以下忽略）
> * 用法：date_trunc(精度,时间戳/时间间隔)
> * 返回：对什么类型截取就返回什么

```
// 通用截取精度
select date_trunc('year', timestamp '2001-02-16 20:38:40');
// 2001-01-01 00:00:00          其它精度（month week day hour minute second)

// 时间戳字段
select date_trunc('day', created_at) from accounts limit 1;
// 2016-03-31 00:00:00

// 时间间隔截取
select date_trunc('day', interval '3years 5months 23days 6hours 5minutes');
// 3 years 5 mons 23 days
```

#### date_part 函数
> * 用途：从时间戳 或 时间间隔 中取出指定精度（小时、天...)
> * 用法：date_part(精度, 时间戳/时间间隔)
> * 返回：double类型
> * PS: 和date_trunc 区别在于 它只去除需要的精度单元

```
select date_part('hours',timestamp '2018-6-10 15:36:23');
// 15

select date_part('second',current_time);
// 43.956637

select date_part('day',created_at) from accounts limit 1;
// 31

select date_part('days',interval '3years 6months 5days ');
// 5
```

#### date 函数
> * 用途：将时间戳 或 字符串 转换为日期（年-月-日）
> * 用法：date(时间戳/字符串)
> * 返回：date类型

```
select date('2018-3-10 15:25:06');
// 2018-03-10

// 注意：以下两种写法等价
select date(created_at) from accounts limit 1;
select created_at::date from accounts limit 1;
// 2016-03-31
```

#### age 函数
> * 用途：计算两个时间戳的 间隔
> * 用法：age(减数时间戳, 被减数时间戳)
> * 返回：时间间隔

```
// 两个定义好的时间戳
select age(timestamp '2018-6-20', timestamp '2017-4-6');
// 1 year 2 mons 14 days

// 两个字段时间戳
select age(last_in,created_at) from accounts limit 1;
// 00:17:56.889344
```

#### current_date 当前时间
> * 用途：当前时间日期

```
select current_date;
// 2018-09-28

select current_date + interval '7' day;
// 2018-10-05 00:00:00
```

#### interval 加减时间间隔
> * 用途：在一个时间戳 或 日期 上加减获取一个新的 时间戳/日期
> * PS：加减对象: 时间戳 或日期

```
select timestamp '2018-6-20' + interval '1 day';
// 2018-06-21 00:00:00

select date('2018-3-10') + interval '1years 3months 5days'
// 2019-06-15 00:00:00

select created_at - interval '5days' from accounts limit 1;
// 2016-03-26 14:22:50.126631
```

#### coalesec 转换null为其它值
> * 用途：常用来将一个为空（null)的行替换为其它值
> * 用法：coalesec(value1,value2,value3...) 里面可以放许多个值
> * 返回：值的类型（返回其中第一个不为null的值，如果所有都为null,则返回null)

```
select coalesce(mobile,email,name) from accounts limit 10;
// 这里的含义是 如果表中，mobile为null,则去判断email是否为null，如果email不为null,则返回email,否则就去判断name；依次类推
```






