##### group_concat()
> 转成字符串

```sql
select plan_id,group_concat(id) from fixed_projects group by plan_id;
select group_concat(distinct plan_id order by plan_id separator ';' ) from fixed_projects; 
```



