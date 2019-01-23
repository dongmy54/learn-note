#### 总述
- `preload` 无论何时都是单db（无join)查询
- `eager_load` 首先left join,其次左边会去重
- `includes` 建立在前两者之上（rails 动态决定）,PS: join时需指明引用（references)

#### eager_load
> 1、where 条件筛选的是（右边所有满足的条件）
> 2、虽然与`includes` 加 references 等价, 但`eager_load` 更简洁点
```ruby
u = User.eager_load(:addresses).where('addresses.country = ?', 'Poland')
#SQL (0.2ms)  SELECT  DISTINCT "users"."id" FROM "users" LEFT OUTER JOIN "addresses" ON "addresses"."user_id" = "users"."id" WHERE (addresses.country = 'Poland') LIMIT ?  [["LIMIT", 11]]
#  SQL (0.2ms)  SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "users"."email" AS t0_r2, "users"."created_at" AS t0_r3, "users"."updated_at" AS t0_r4, "addresses"."id" AS t1_r0, "addresses"."country" AS t1_r1, "addresses"."city" AS t1_r2, "addresses"."postal_code" AS t1_r3, "addresses"."created_at" AS t1_r4, "addresses"."updated_at" AS t1_r5, "addresses"."street" AS t1_r6, "addresses"."user_id" AS t1_r7 FROM "users" LEFT OUTER JOIN "addresses" ON "addresses"."user_id" = "users"."id" WHERE (addresses.country = 'Poland') AND "users"."id" = ?  [["id", 7]]

# => #<ActiveRecord::Relation [#<User id: 7, name: "Robert Pankowecki", email: "robert@example.org", created_at: "2019-01-22 02:02:54", updated_at: "2019-01-22 02:02:54">]>

u[0]
#SQL (0.3ms)  SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, "users"."email" AS t0_r2, "users"."created_at" AS t0_r3, "users"."updated_at" AS t0_r4, "addresses"."id" AS t1_r0, "addresses"."country" AS t1_r1, "addresses"."city" AS t1_r2, "addresses"."postal_code" AS t1_r3, "addresses"."created_at" AS t1_r4, "addresses"."updated_at" AS t1_r5, "addresses"."street" AS t1_r6, "addresses"."user_id" AS t1_r7 FROM "users" LEFT OUTER JOIN "addresses" ON "addresses"."user_id" = "users"."id" WHERE (addresses.country = 'Poland')
 
#=> #<User id: 7, name: "Robert Pankowecki", email: "robert@example.org", created_at: "2019-01-22 02:02:54", updated_at: "2019-01-22 02:02:54">

u[0].addresses
#=> #<ActiveRecord::Associations::CollectionProxy [#<Address id: 4, country: "Poland", city: "Wrocław", postal_code: "55-555", created_at: "2019-01-22 02:03:04", updated_at: "2019-01-22 02:03:04", street: "Rynek", user_id: 7>, #<Address id: 7, country: "Poland", city: "Wrocła", postal_code: "56-555", created_at: "2019-01-23 01:35:59", updated_at: "2019-01-23 01:35:59", street: "Rynek", user_id: 7>]>

# 这里只返回 地址为 Poland 的地址

# includes 等价写法
# User.includes(:addresses).where('addresses.country = ?', 'Poland').references(:addresses)
```

#### 其中一个满足条件的所有
> 先找出地址中含有'Poland' 的 user id
> 再 includes addesses
```ruby
user_ids = User.joins(:addresses).where('addresses.country = ?', 'Poland').ids.uniq

users = User.where(id: user_ids).includes(:addresses)
```















