#####  joins
> 1. inner主要用于做关联表数据的过滤
> 2. 会覆盖掉，其它（preload/includes/eager_load等joins方式


##### includes
> 用于：避免n+1查询
> 底层采用：
> 1. preload 生成分开的查询语句，没有where、order带关联表时
> 2. eager_load 生成一条left join语句，如where、order带关联表时候触发
> PS：大多数时候使用到includes就够用了，由rails去决定查询方式


##### preload
> 1. 显示指明生成多条查询语句（不用join)；如果我们事先知道，join会导致性能较差，可用preload
```ruby
User.preload(:roles).where(id: 3)
#大致生成：
select * from users where xxxx;
select * from roles where roles.user_id = [];
```
> 2. preload配合joins会返回，关联数据的所有记录，比如
```ruby
# 这里我们过滤的是 包含reservation roled的用户，返回了这个user的所有role
User.preload(:roles).joins(:roles).where(id: 1, roles: {role: :reservation}).map{|user| user.roles.map(&:role)}
# => [["employer", "employer", "employee", "employer", "reservation"]]

# 这里只返回 过滤出的role
User.includes(:roles).joins(:roles).where(id: 1, roles: {role: :reservation}).map{|user| user.roles.map(&:role)}
# => [["reservation"]]
```

##### eager_load
> 显示指明生成一条left join语句；如果我们事先知道，left join性能更高的话

##### references
> 一般搭配includes一起使用，显示指明采用引用关系表；此时与eager_load等价
> 用的极少



