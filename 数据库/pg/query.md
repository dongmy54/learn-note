#### json查询
```sql
# -> 返回json对象
select metadata -> 'purchased_gems' from iap_purchases limit 10;

# ->> 返回字符串
select metadata ->> 'purchased_gems' from iap_purchases limit 10;

# -> 与 ->> 联合 进入不同层级
select * from xx_tables where metadata -> 'top_layer' ->> 'sub_layer' = 'xx_string'
```