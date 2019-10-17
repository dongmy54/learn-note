##### from 后两个表名
> 为其命名(PS: 此时select只能用新名)

```sql
select e.id, e.name from emalls e;
```

##### join 筛选后的新表
```sql
select orders.id from orders
join (select * from plans where plans.status = 1) new_plans on new_plans.id = orders.plan_id
```
