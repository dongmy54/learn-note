#### 总述
- `preload` 无论何时都是单db（无join)查询
- `eager_load` 首先left join,其次左边会去重
- `includes` 建立在前两者之上（rails 动态决定

#### includes
1. 可以解决 n + 1 查询
2. 但,当用其它表字段做条件查询时，select失效
3. 前面查询结果，会对后面关联产生影响
```ruby
GameType.includes(:game_sublevels).where(game_sublevels: {active: true})                                     # where中关联查询 不用加 references
GameType.includes(:game_sublevels).references(:game_sublevels).where('game_sublevels.active = ?', true)      # where中字符串查询加 references


GameType.select(:name).includes(:game_sublevels)          # select 有效
#GameType Load (0.6ms)  SELECT "game_types"."name" FROM "game_types"
GameType.select(:name).includes(:game_sublevels).where(game_sublevels: {active: true})         # select 无效（返回所有字段）
#SELECT "game_types"."name", "game_types"."id" AS t0_r0, "game_types"."name" AS t0_r1, "game_types"."created_at" AS t0_r2, "game_types"."updated_at" AS t0_r3, "game_types"."is_room" AS t0_r4, "game_types"."scene" AS t0_r5, "game_types"."bundle" AS t0_r6, "game_types"."min_bet_level" AS t0_r7, "game_types"."metadata" AS t0_r8, "game_types"."bet_type" AS t0_r9, "game_sublevels"."id" AS t1_r0, "game_sublevels"."created_at" AS t1_r1, "game_sublevels"."updated_at" AS t1_r2, "game_sublevels"."game_type_id" AS t1_r3, "game_sublevels"."active" AS t1_r4, "game_sublevels"."bets" AS t1_r5, "game_sublevels"."level" AS t1_r6, "game_sublevels"."title" AS t1_r7 FROM "game_types" LEFT OUTER JOIN "game_sublevels" ON "game_sublevels"."game_type_id" = "game_types"."id" WHERE "game_sublevels"."active" = $1  [["active", true]]


GameType.includes(:game_sublevels).references(:game_sublevels).where('game_sublevels.active = ?', true).each do |gt|
  gt.game_sublevels       # 这里按照关联返回的game_sublevels active 都是 true
end
```

#### eager_load
1. 能解决 n + 1 查询
2. select 无效
3. where 条件筛选的是（右边所有满足的条件）
4. 与`includes` 加 references等价
```ruby
 GameType.select(:name).eager_load(:game_sublevels)     # 返回所有字段
 # SELECT "game_types"."name", "game_types"."id" AS t0_r0, "game_types"."name" AS t0_r1, "game_types"."created_at" AS t0_r2, "game_types"."updated_at" AS t0_r3, "game_types"."is_room" AS t0_r4, "game_types"."scene" AS t0_r5, "game_types"."bundle" AS t0_r6, "game_types"."min_bet_level" AS t0_r7, "game_types"."metadata" AS t0_r8, "game_types"."bet_type" AS t0_r9, "game_sublevels"."id" AS t1_r0, "game_sublevels"."created_at" AS t1_r1, "game_sublevels"."updated_at" AS t1_r2, "game_sublevels"."game_type_id" AS t1_r3, "game_sublevels"."active" AS t1_r4, "game_sublevels"."bets" AS t1_r5, "game_sublevels"."level" AS t1_r6, "game_sublevels"."title" AS t1_r7 FROM "game_types" LEFT OUTER JOIN "game_sublevels" ON "game_sublevels"."game_type_id" = "game_types"."id"
```

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

#### joins
1. 两种写法：a.直接接关联 `User.joins(:emall)` b. 接sql`User.joins('joins emalls on emalls.id = users.emall_id')`
2. `User.joins(xx)`默认返回User相关的字段
3. select 有效
4. 不能避免n + 1 查询，可用它取出其它表中有用字段
```ruby
# sum 只能放最后
IapPurchase.joins(user: :used_codes).where('redeem_codes.id = ?', RedeemCode.find(10).sum(:price)

# 等价
IapPurchase.joins(user: {redeemptions: :redeem_code}).where('redeem_codes.id = ?', RedeemCode.find(10)).sum(:price)

# 先找出符合条件user 再includes其所有iap_purchases
User.joins(:iap_purchases).where('iap_purchases.price > ?', 12).includes(:iap_purchases)
```














