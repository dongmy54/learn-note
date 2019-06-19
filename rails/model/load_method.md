#### 总述
- `preload` 无论何时都是单db（无join)查询
- `eager_load` 首先left join,其次左边会去重
- `includes` 建立在前两者之上（rails 动态决定

#### includes
1. 可以解决 n + 1 查询
2. 但,当用其它表字段做条件查询时，select失效
3. joins多个关联,然后遍历使用关联,会造成n +1;
> PS: a. 解决办法`includes` + `references`;另外测试出 references只需写任何一个关联进去就行
      b. 这个n +1 只对读数据有效；如果更新是没有用的哈

```ruby
GameType.includes(:game_sublevels).where(game_sublevels: {active: true})                                     # where中关联查询 不用加 references
GameType.includes(:game_sublevels).references(:game_sublevels).where('game_sublevels.active = ?', true)      # where中字符串查询加 references


GameType.select(:name).includes(:game_sublevels)          # select 有效
#GameType Load (0.6ms)  SELECT "game_types"."name" FROM "game_types"
GameType.select(:name).includes(:game_sublevels).where(game_sublevels: {active: true})         # select 无效（返回所有字段）
#SELECT "game_types"."name", "game_types"."id" AS t0_r0, "game_types"."name" AS t0_r1, "game_types"."created_at" AS t0_r2, "game_types"."updated_at" AS t0_r3, "game_types"."is_room" AS t0_r4, "game_types"."scene" AS t0_r5, "game_types"."bundle" AS t0_r6, "game_types"."min_bet_level" AS t0_r7, "game_types"."metadata" AS t0_r8, "game_types"."bet_type" AS t0_r9, "game_sublevels"."id" AS t1_r0, "game_sublevels"."created_at" AS t1_r1, "game_sublevels"."updated_at" AS t1_r2, "game_sublevels"."game_type_id" AS t1_r3, "game_sublevels"."active" AS t1_r4, "game_sublevels"."bets" AS t1_r5, "game_sublevels"."level" AS t1_r6, "game_sublevels"."title" AS t1_r7 FROM "game_types" LEFT OUTER JOIN "game_sublevels" ON "game_sublevels"."game_type_id" = "game_types"."id" WHERE "game_sublevels"."active" = $1  [["active", true]]
```

```ruby
# n + 1
BrandCatalogStore.joins(:emall, brand_catalog: :catalog).where('catalogs.dingdian_type = ?', "A0609").where(state: 2).each do |store|
	puts store.brand_catalog.brand_name
	puts store.emall.id
end

#BrandCatalogStore Load (9.7ms)  SELECT `brand_catalog_stores`.* FROM `brand_catalog_stores` INNER JOIN `emalls` ON `emalls`.`id` = `brand_catalog_stores`.`emall_id` INNER JOIN `brand_catalogs` ON `brand_catalogs`.`id` = `brand_catalog_stores`.`brand_catalog_id` INNER JOIN `catalogs` ON `catalogs`.`id` = `brand_catalogs`.`catalog_id` AND (year = 2019) WHERE (catalogs.dingdian_type = 'A0609') AND `brand_catalog_stores`.`state` = 2
#   BrandCatalog Load (6.9ms)  SELECT  `brand_catalogs`.* FROM `brand_catalogs`  WHERE `brand_catalogs`.`id` = 861 LIMIT 1
# 金正
#   Emall Load (7.1ms)  SELECT  `emalls`.* FROM `emalls`  WHERE `emalls`.`id` = 2414 LIMIT 1
# 2414
#   BrandCatalog Load (7.1ms)  SELECT  `brand_catalogs`.* FROM `brand_catalogs`  WHERE `brand_catalogs`.`id` = 875 LIMIT 1
# wer
#   Emall Load (6.6ms)  SELECT  `emalls`.* FROM `emalls`  WHERE `emalls`.`id` = 4805 LIMIT 1
# 4805
#   BrandCatalog Load (6.3ms)  SELECT  `brand_catalogs`.* FROM `brand_catalogs`  WHERE `brand_catalogs`.`id` = 877 LIMIT 1
# vc
#   Emall Load (6.4ms)  SELECT  `emalls`.* FROM `emalls`  WHERE `emalls`.`id` = 15985 LIMIT 1
# 15985
#   BrandCatalog Load (6.9ms)  SELECT  `brand_catalogs`.* FROM `brand_catalogs`  WHERE `brand_catalogs`.`id` = 882 LIMIT 1
# hubar
#   Emall Load (10.2ms)  SELECT  `emalls`.* FROM `emalls`  WHERE `emalls`.`id` = 4 LIMIT 1
# 4


# includes + reference
BrandCatalogStore.includes(:emall, brand_catalog: :catalog).references(:catalogs).where('catalogs.dingdian_type = ?', "A0609").where(state: 2).each do |store|
	puts store.brand_catalog.brand_name
	puts store.emall.id
end

# SQL (17.3ms)  SELECT `brand_catalog_stores`.`id` AS t0_r0, `brand_catalog_stores`.`brand_catalog_id` AS t0_r1, `brand_catalog_stores`.`user_id` AS t0_r2, `brand_catalog_stores`.`emall_id` AS t0_r3, `brand_catalog_stores`.`qq` AS t0_r4, `brand_catalog_stores`.`state` AS t0_r5, `brand_catalog_stores`.`created_at` AS t0_r6, `brand_catalog_stores`.`updated_at` AS t0_r7, `brand_catalog_stores`.`contact` AS t0_r8, `brand_catalog_stores`.`phone` AS t0_r9, `brand_catalog_stores`.`email` AS t0_r10, `brand_catalog_stores`.`is_need_file` AS t0_r11, `brand_catalog_stores`.`company_web` AS t0_r12, `brand_catalog_stores`.`good_url` AS t0_r13, `brand_catalog_stores`.`delay_year` AS t0_r14, `brand_catalog_stores`.`valid_end_time` AS t0_r15, `brand_catalog_stores`.`submit_audit_at` AS t0_r16, `brand_catalog_stores`.`trademark_registration_certificate` AS t0_r17, `brand_catalog_stores`.`certificate_expired_at` AS t0_r18, `emalls`.`id` AS t1_r0, `emalls`.`name` AS t1_r1, `emalls`.`url` AS t1_r2, `emalls`.`emall_code` AS t1_r3, `emalls`.`third_id` AS t1_r4, `emalls`.`created_at` AS t1_r5, `emalls`.`updated_at` AS t1_r6, `emalls`.`emall_label_id` AS t1_r7, `emalls`.`service_tel` AS t1_r8, `emalls`.`icon_url` AS t1_r9, `emalls`.`pay_tip` AS t1_r10, `emalls`.`price_name` AS t1_r11, `emalls`.`full_name` AS t1_r12, `emalls`.`dep_code` AS t1_r13, `emalls`.`main_dep_id` AS t1_r14, `emalls`.`contact` AS t1_r15, `emalls`.`tel` AS t1_r16, `emalls`.`address` AS t1_r17, `emalls`.`bank` AS t1_r18, `emalls`.`bank_code` AS t1_r19, `emalls`.`msm_tel` AS t1_r20, `emalls`.`org_code` AS t1_r21, `emalls`.`nature` AS t1_r22, `emalls`.`phone` AS t1_r23, `emalls`.`fax` AS t1_r24, `emalls`.`contactor` AS t1_r25, `emalls`.`contactorPhone` AS t1_r26, `emalls`.`contactorMobile` AS t1_r27, `emalls`.`area_id` AS t1_r28, `emalls`.`pregion_name` AS t1_r29, `emalls`.`status` AS t1_r30, `emalls`.`comment` AS t1_r31, `emalls`.`small_emall_flag` AS t1_r32, `emalls`.`small_emall_file` AS t1_r33, `emalls`.`approved_time` AS t1_r34, `emalls`.`zykt_flag` AS t1_r35, `emalls`.`zykt_file` AS t1_r36, `emalls`.`change_name` AS t1_r37, `emalls`.`is_stop` AS t1_r38, `emalls`.`stop_end_at` AS t1_r39, `emalls`.`duration` AS t1_r40, `emalls`.`stop_begin_at` AS t1_r41, `emalls`.`auction_pause_state` AS t1_r42, `emalls`.`fixed_pause_state` AS t1_r43, `emalls`.`pause_reason` AS t1_r44, `emalls`.`principal` AS t1_r45, `emalls`.`principal_phone` AS t1_r46, `emalls`.`principal_mobile` AS t1_r47, `emalls`.`email` AS t1_r48, `emalls`.`credit_log` AS t1_r49, `emalls`.`is_automatic` AS t1_r50, `emalls`.`secure_valid_end_at` AS t1_r51, `emalls`.`adviser_submit_count` AS t1_r52, `emalls`.`qualification_submit_count` AS t1_r53, `emalls`.`basic_submit_counts` AS t1_r54, `emalls`.`emall_emall_type_submit_counts` AS t1_r55, `emalls`.`service_areas_submit_counts` AS t1_r56, `emalls`.`emall_status_submit_counts` AS t1_r57, `emalls`.`apply_return_counts` AS t1_r58, `emalls`.`submit_audit_at` AS t1_r59, `brand_catalogs`.`id` AS t2_r0, `brand_catalogs`.`catalog_id` AS t2_r1, `brand_catalogs`.`catalog_code` AS t2_r2, `brand_catalogs`.`catalog_name` AS t2_r3, `brand_catalogs`.`brand_id` AS t2_r4, `brand_catalogs`.`brand_name` AS t2_r5, `brand_catalogs`.`state` AS t2_r6, `brand_catalogs`.`created_at` AS t2_r7, `brand_catalogs`.`updated_at` AS t2_r8, `brand_catalogs`.`status` AS t2_r9, `brand_catalogs`.`comment` AS t2_r10, `brand_catalogs`.`is_store` AS t2_r11, `brand_catalogs`.`realname` AS t2_r12, `brand_catalogs`.`is_stop` AS t2_r13, `catalogs`.`id` AS t3_r0, `catalogs`.`name` AS t3_r1, `catalogs`.`code` AS t3_r2, `catalogs`.`ancestry` AS t3_r3, `catalogs`.`ancestry_depth` AS t3_r4, `catalogs`.`position` AS t3_r5, `catalogs`.`desc` AS t3_r6, `catalogs`.`price_tags` AS t3_r7, `catalogs`.`usable` AS t3_r8, `catalogs`.`created_at` AS t3_r9, `catalogs`.`updated_at` AS t3_r10, `catalogs`.`log` AS t3_r11, `catalogs`.`way_ids` AS t3_r12, `catalogs`.`way_names` AS t3_r13, `catalogs`.`gid` AS t3_r14, `catalogs`.`pic` AS t3_r15, `catalogs`.`priority` AS t3_r16, `catalogs`.`stand_catalog_id` AS t3_r17, `catalogs`.`commodities_count` AS t3_r18, `catalogs`.`is_saving` AS t3_r19, `catalogs`.`year` AS t3_r20, `catalogs`.`ebg_flag` AS t3_r21, `catalogs`.`dingdian_flag` AS t3_r22, `catalogs`.`dingdian_type` AS t3_r23, `catalogs`.`dianshang_flag` AS t3_r24, `catalogs`.`piliang_flag` AS t3_r25, `catalogs`.`ebg_jn_flag` AS t3_r26, `catalogs`.`ebg_tc_flag` AS t3_r27, `catalogs`.`is_special_catalog` AS t3_r28, `catalogs`.`single_limit` AS t3_r29, `catalogs`.`annual_limit` AS t3_r30, `catalogs`.`plgd_flag` AS t3_r31, `catalogs`.`quota_standard` AS t3_r32, `catalogs`.`asset_code` AS t3_r33, `catalogs`.`bidding_type` AS t3_r34 FROM `brand_catalog_stores` LEFT OUTER JOIN `emalls` ON `emalls`.`id` = `brand_catalog_stores`.`emall_id` LEFT OUTER JOIN `brand_catalogs` ON `brand_catalogs`.`id` = `brand_catalog_stores`.`brand_catalog_id` LEFT OUTER JOIN `catalogs` ON `catalogs`.`id` = `brand_catalogs`.`catalog_id` AND (year = 2019) WHERE (catalogs.dingdian_type = 'A0609') AND `brand_catalog_stores`.`state` = 2
#金正
#2414
#wer
#4805
#vc
#15985
#hubar
#4

BrandCatalogStore.includes(:emall, brand_catalog: :catalog).references(:catalogs).where('catalogs.dingdian_type = ?', "A0609").where(state: 2).each do |store|
	store.brand_catalog.update(brand_name: 'hu') # 更新
	puts store.brand_catalog.id
end
# 更新数据没法避免n+1
# AttachmentCategory Load (6.9ms)  SELECT `attachment_categories`.* FROM `attachment_categories`  WHERE `attachment_categories`.`is_enable` = 1 AND `attachment_categories`.`kind` = 1
#  SQL (9.5ms)  SELECT `brand_catalog_stores`.`id` AS t0_r0, `brand_catalog_stores`.`brand_catalog_id` AS t0_r1, `brand_catalog_stores`.`user_id` AS t0_r2, `brand_catalog_stores`.`emall_id` AS t0_r3, `brand_catalog_stores`.`qq` AS t0_r4, `brand_catalog_stores`.`state` AS t0_r5, `brand_catalog_stores`.`created_at` AS t0_r6, `brand_catalog_stores`.`updated_at` AS t0_r7, `brand_catalog_stores`.`contact` AS t0_r8, `brand_catalog_stores`.`phone` AS t0_r9, `brand_catalog_stores`.`email` AS t0_r10, `brand_catalog_stores`.`is_need_file` AS t0_r11, `brand_catalog_stores`.`company_web` AS t0_r12, `brand_catalog_stores`.`good_url` AS t0_r13, `brand_catalog_stores`.`delay_year` AS t0_r14, `brand_catalog_stores`.`valid_end_time` AS t0_r15, `brand_catalog_stores`.`submit_audit_at` AS t0_r16, `brand_catalog_stores`.`trademark_registration_certificate` AS t0_r17, `brand_catalog_stores`.`certificate_expired_at` AS t0_r18, `emalls`.`id` AS t1_r0, `emalls`.`name` AS t1_r1, `emalls`.`url` AS t1_r2, `emalls`.`emall_code` AS t1_r3, `emalls`.`third_id` AS t1_r4, `emalls`.`created_at` AS t1_r5, `emalls`.`updated_at` AS t1_r6, `emalls`.`emall_label_id` AS t1_r7, `emalls`.`service_tel` AS t1_r8, `emalls`.`icon_url` AS t1_r9, `emalls`.`pay_tip` AS t1_r10, `emalls`.`price_name` AS t1_r11, `emalls`.`full_name` AS t1_r12, `emalls`.`dep_code` AS t1_r13, `emalls`.`main_dep_id` AS t1_r14, `emalls`.`contact` AS t1_r15, `emalls`.`tel` AS t1_r16, `emalls`.`address` AS t1_r17, `emalls`.`bank` AS t1_r18, `emalls`.`bank_code` AS t1_r19, `emalls`.`msm_tel` AS t1_r20, `emalls`.`org_code` AS t1_r21, `emalls`.`nature` AS t1_r22, `emalls`.`phone` AS t1_r23, `emalls`.`fax` AS t1_r24, `emalls`.`contactor` AS t1_r25, `emalls`.`contactorPhone` AS t1_r26, `emalls`.`contactorMobile` AS t1_r27, `emalls`.`area_id` AS t1_r28, `emalls`.`pregion_name` AS t1_r29, `emalls`.`status` AS t1_r30, `emalls`.`comment` AS t1_r31, `emalls`.`small_emall_flag` AS t1_r32, `emalls`.`small_emall_file` AS t1_r33, `emalls`.`approved_time` AS t1_r34, `emalls`.`zykt_flag` AS t1_r35, `emalls`.`zykt_file` AS t1_r36, `emalls`.`change_name` AS t1_r37, `emalls`.`is_stop` AS t1_r38, `emalls`.`stop_end_at` AS t1_r39, `emalls`.`duration` AS t1_r40, `emalls`.`stop_begin_at` AS t1_r41, `emalls`.`auction_pause_state` AS t1_r42, `emalls`.`fixed_pause_state` AS t1_r43, `emalls`.`pause_reason` AS t1_r44, `emalls`.`principal` AS t1_r45, `emalls`.`principal_phone` AS t1_r46, `emalls`.`principal_mobile` AS t1_r47, `emalls`.`email` AS t1_r48, `emalls`.`credit_log` AS t1_r49, `emalls`.`is_automatic` AS t1_r50, `emalls`.`secure_valid_end_at` AS t1_r51, `emalls`.`adviser_submit_count` AS t1_r52, `emalls`.`qualification_submit_count` AS t1_r53, `emalls`.`basic_submit_counts` AS t1_r54, `emalls`.`emall_emall_type_submit_counts` AS t1_r55, `emalls`.`service_areas_submit_counts` AS t1_r56, `emalls`.`emall_status_submit_counts` AS t1_r57, `emalls`.`apply_return_counts` AS t1_r58, `emalls`.`submit_audit_at` AS t1_r59, `brand_catalogs`.`id` AS t2_r0, `brand_catalogs`.`catalog_id` AS t2_r1, `brand_catalogs`.`catalog_code` AS t2_r2, `brand_catalogs`.`catalog_name` AS t2_r3, `brand_catalogs`.`brand_id` AS t2_r4, `brand_catalogs`.`brand_name` AS t2_r5, `brand_catalogs`.`state` AS t2_r6, `brand_catalogs`.`created_at` AS t2_r7, `brand_catalogs`.`updated_at` AS t2_r8, `brand_catalogs`.`status` AS t2_r9, `brand_catalogs`.`comment` AS t2_r10, `brand_catalogs`.`is_store` AS t2_r11, `brand_catalogs`.`realname` AS t2_r12, `brand_catalogs`.`is_stop` AS t2_r13, `catalogs`.`id` AS t3_r0, `catalogs`.`name` AS t3_r1, `catalogs`.`code` AS t3_r2, `catalogs`.`ancestry` AS t3_r3, `catalogs`.`ancestry_depth` AS t3_r4, `catalogs`.`position` AS t3_r5, `catalogs`.`desc` AS t3_r6, `catalogs`.`price_tags` AS t3_r7, `catalogs`.`usable` AS t3_r8, `catalogs`.`created_at` AS t3_r9, `catalogs`.`updated_at` AS t3_r10, `catalogs`.`log` AS t3_r11, `catalogs`.`way_ids` AS t3_r12, `catalogs`.`way_names` AS t3_r13, `catalogs`.`gid` AS t3_r14, `catalogs`.`pic` AS t3_r15, `catalogs`.`priority` AS t3_r16, `catalogs`.`stand_catalog_id` AS t3_r17, `catalogs`.`commodities_count` AS t3_r18, `catalogs`.`is_saving` AS t3_r19, `catalogs`.`year` AS t3_r20, `catalogs`.`ebg_flag` AS t3_r21, `catalogs`.`dingdian_flag` AS t3_r22, `catalogs`.`dingdian_type` AS t3_r23, `catalogs`.`dianshang_flag` AS t3_r24, `catalogs`.`piliang_flag` AS t3_r25, `catalogs`.`ebg_jn_flag` AS t3_r26, `catalogs`.`ebg_tc_flag` AS t3_r27, `catalogs`.`is_special_catalog` AS t3_r28, `catalogs`.`single_limit` AS t3_r29, `catalogs`.`annual_limit` AS t3_r30, `catalogs`.`plgd_flag` AS t3_r31, `catalogs`.`quota_standard` AS t3_r32, `catalogs`.`asset_code` AS t3_r33, `catalogs`.`bidding_type` AS t3_r34 FROM `brand_catalog_stores` LEFT OUTER JOIN `emalls` ON `emalls`.`id` = `brand_catalog_stores`.`emall_id` LEFT OUTER JOIN `brand_catalogs` ON `brand_catalogs`.`id` = `brand_catalog_stores`.`brand_catalog_id` LEFT OUTER JOIN `catalogs` ON `catalogs`.`id` = `brand_catalogs`.`catalog_id` AND (year = 2019) WHERE (catalogs.dingdian_type = 'A0609') AND `brand_catalog_stores`.`state` = 2
#   (7.4ms)  BEGIN
#  BrandCatalog Exists (7.2ms)  SELECT  1 AS one FROM `brand_catalogs`  WHERE (`brand_catalogs`.`catalog_id` = BINARY 63 AND `brand_catalogs`.`id` != #861 AND `brand_catalogs`.`brand_id` = 713) LIMIT 1
#   (7.8ms)  COMMIT
#861
#   (7.0ms)  BEGIN
#  BrandCatalog Exists (6.8ms)  SELECT  1 AS one FROM `brand_catalogs`  WHERE (`brand_catalogs`.`catalog_id` = BINARY 63 AND `brand_catalogs`.`id` != #875 AND `brand_catalogs`.`brand_id` = 724) LIMIT 1
#   (6.3ms)  COMMIT
#875
#   (7.0ms)  BEGIN
#  BrandCatalog Exists (7.1ms)  SELECT  1 AS one FROM `brand_catalogs`  WHERE (`brand_catalogs`.`catalog_id` = BINARY 63 AND `brand_catalogs`.`id` != #877 AND `brand_catalogs`.`brand_id` = 726) LIMIT 1
#   (6.7ms)  COMMIT
#877
#   (6.1ms)  BEGIN
#  BrandCatalog Exists (6.9ms)  SELECT  1 AS one FROM `brand_catalogs`  WHERE (`brand_catalogs`.`catalog_id` = BINARY 63 AND `brand_catalogs`.`id` != #882 AND `brand_catalogs`.`brand_id` = 731) LIMIT 1
#   (7.0ms)  COMMIT
#882

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














