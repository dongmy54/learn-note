#### postgresql

```
select date_trunc('hour', timestamp '2018-03-23 15:56:23');  
// 截取一个时间精度 可以是 year day hour 等

select to_timestamp('2018/3/6 14:36:14', 'YYYY-MM-DD HH24:MI:SS');
// 将一个时间字符串转换成 一个时间戳格式
```