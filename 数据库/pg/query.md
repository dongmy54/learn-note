#### json查询
```sql
# -> 返回json对象
select metadata -> 'purchased_gems' from iap_purchases limit 10;

# ->> 返回字符串
select metadata ->> 'purchased_gems' from iap_purchases limit 10;

# -> 与 ->> 联合 进入不同层级
select * from xx_tables where metadata -> 'top_layer' ->> 'sub_layer' = 'xx_string'
```

#### array 查询
```sql
# shop_ids中包含 1，2
select id from sales_invoices where shop_ids @> '{1,2}';

# && 交集只要有其中一个
select id from sales_invoices where shop_ids && '{1,2}';

# <@ 右边完全包含左边
# || 合并数组查询
```