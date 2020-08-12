#### joins、preload、eager_load、includes区别
> - joins   用于接关联的where语句
> - preload 避免n+1,使用多个单独的sql
> - eager_load 避免n+1,使用 joins 方式sql
> - includes 避免n+1,将preload / eager_load的调用交由rails,如出现关联where语句、order语句，则用eager_load
> - 以上方法都可以组合使用

#### 如何使用
> 在避免n+1时，优先使用includes，如发现性能不好，考虑使用preload/eager_load指定sql方式

#### 各情况下sql展示

##### includes
```ruby
# 直接使用 includes
# 没有 where order 单独生成了sql 没有join
User.includes(:department).map{|i| i.department.try(:id)}

# User Load (38.3ms)  SELECT `users`.* FROM `users`
#  Department Load (8.6ms)  SELECT `departments`.* FROM `departments`  WHERE (is_delete = false) AND `departments`.`id` IN (35, 1, 16, 21, 24, 43, 50, 52, 56, 57, 59, 63, 62, 65, 66, 68, 70, 73, 67, 76, 77, 51, 78, 83, 84, 72, 86, 91, 92, 93, 94, 96, 103, 110, 111, 116, 118, 119)



# 此处使用where 生成了 join 的sql
# PS: 此处用where 需用joins
User.includes(:department).joins(:department).where('departments.id > 5').map{|i| i.department.try(:id)}
#  SELECT `users`.`id` AS t0_r0, `users`.`email` AS t0_r1, `users`.`encrypted_password` AS t0_r2, `users`.`reset_password_token` AS t0_r3, `users`.`reset_password_sent_at` AS t0_r4, `users`.`remember_created_at` AS t0_r5, `users`.`sign_in_count` AS t0_r6, `users`.`current_sign_in_at` AS t0_r7, `users`.`last_sign_in_at` AS t0_r8, `users`.`current_sign_in_ip` AS t0_r9, `users`.`last_sign_in_ip` AS t0_r10, `users`.`loginname` AS t0_r11, `users`.`prefer_address_id` AS t0_r12, `users`.`created_at` AS t0_r13, `users`.`updated_at` AS t0_r14, `users`.`prefer_invoice_id` AS t0_r15, `users`.`cart` AS t0_r16, `users`.`prefer_ptype` AS t0_r17, `users`.`parent_id` AS t0_r18, `users`.`realname` AS t0_r19, `users`.`auth_token` AS t0_r20, `users`.`zcl_usertype` AS t0_r21, `users`.`zcl_topname` AS t0_r22, `users`.`zcl_depname` AS t0_r23, `users`.`zcl_depcode` AS t0_r24, `users`.`zcl_userid` AS t0_r25, `users`.`zcl_username` AS t0_r26, `users`.`zcl_realname` AS t0_r27, `users`.`department_id` AS t0_r28, `users`.`email_token` AS t0_r29, `users`.`token_expiration_at` AS t0_r30, `users`.`status` AS t0_r31, `users`.`emall_id` AS t0_r32, `users`.`mobile` AS t0_r33, `users`.`disagree_msg` AS t0_r34, `users`.`log_out_url` AS t0_r35, `users`.`user_mobile` AS t0_r36, `users`.`errors_count` AS t0_r37, `users`.`order_status` AS t0_r38, `users`.`is_industrial_purchaser` AS t0_r39, `users`.`purchase_type` AS t0_r40, `departments`.`id` AS t1_r0, `departments`.`name` AS t1_r1, `departments`.`short_name` AS t1_r2, `departments`.`org_code` AS t1_r3, `departments`.`org_code_pic` AS t1_r4, `departments`.`legal_name` AS t1_r5, `departments`.`legal_code` AS t1_r6, `departments`.`legal_code_pic` AS t1_r7, `departments`.`area_id` AS t1_r8, `departments`.`address` AS t1_r9, `departments`.`post_code` AS t1_r10, `departments`.`url` AS t1_r11, `departments`.`ancestry` AS t1_r12, `departments`.`ancestry_depth` AS t1_r13, `departments`.`summary` AS t1_r14, `departments`.`short_url` AS t1_r15, `departments`.`bank` AS t1_r16, `departments`.`bank_code` AS t1_r17, `departments`.`industry` AS t1_r18, `departments`.`cgr_nature` AS t1_r19, `departments`.`gys_nature` AS t1_r20, `departments`.`capital` AS t1_r21, `departments`.`license` AS t1_r22, `departments`.`license_pic` AS t1_r23, `departments`.`tax` AS t1_r24, `departments`.`tax_pic` AS t1_r25, `departments`.`employee` AS t1_r26, `departments`.`turnover` AS t1_r27, `departments`.`lng` AS t1_r28, `departments`.`lat` AS t1_r29, `departments`.`created_at` AS t1_r30, `departments`.`updated_at` AS t1_r31, `departments`.`order_num` AS t1_r32, `departments`.`company_type` AS t1_r33, `departments`.`hotel_star` AS t1_r34, `departments`.`product_orientation` AS t1_r35, `departments`.`product_location` AS t1_r36, `departments`.`reg_pic` AS t1_r37, `departments`.`level` AS t1_r38, `departments`.`is_top` AS t1_r39, `departments`.`key_word` AS t1_r40, `departments`.`is_delete` AS t1_r41, `departments`.`is_allow_add` AS t1_r42, `departments`.`is_center` AS t1_r43, `departments`.`belong_center` AS t1_r44, `departments`.`logo_pic` AS t1_r45, `departments`.`tel` AS t1_r46, `departments`.`fax` AS t1_r47, `departments`.`personal_style_id` AS t1_r48, `departments`.`logo_second_pic` AS t1_r49, `departments`.`use_own` AS t1_r50, `departments`.`use_id` AS t1_r51, `departments`.`code` AS t1_r52, `departments`.`auth_code` AS t1_r53, `departments`.`use_budget` AS t1_r54, `departments`.`use_upload` AS t1_r55, `departments`.`show_platform_product` AS t1_r56, `departments`.`logo_goto_url` AS t1_r57, `departments`.`show_trends` AS t1_r58, `departments`.`can_purchase_gyp` AS t1_r59, `departments`.`use_root` AS t1_r60, `departments`.`open_esp` AS t1_r61, `departments`.`show_department_product` AS t1_r62, `departments`.`card_codes` AS t1_r63, `departments`.`third_department_id` AS t1_r64, `departments`.`use_protocol_mall` AS t1_r65 FROM `users` INNER JOIN `departments` ON `departments`.`id` = `users`.`department_id` AND (is_delete = false) WHERE (departments.id > 5)


# 此处使用 order 也会生成 join 的sql
User.includes(:department).joins(:department).order('departments.id').map{|i| i.department.try(:id)}
```

##### preload
```ruby
# preload 指明用单独sql
User.preload(:department).joins(:department).where('departments.id > 5').map{|i| i.department.try(:id)}
#User Load (21.4ms)  SELECT `users`.* FROM `users` INNER JOIN `departments` ON `departments`.`id` = `users`.`department_id` AND (is_delete = false) WHERE (departments.id > 5)
#  Department Load (7.9ms)  SELECT `departments`.* FROM `departments`  WHERE (is_delete = false) AND `departments`.`id` IN (35, 16, 21, 24, 43, 50, 52, 56, 57, 59, 63, 62, 65, 66, 68, 70, 73, 67, 76, 77, 51, 78, 83, 84, 72, 86, 91, 92, 93, 94, 96, 103, 110, 111, 116, 118, 119)
```

##### eager_load
> PS： 使用eager_load的时候，会覆盖select方法

```ruby
# eager_load 指明用 join sql
User.eager_load(:department).joins(:department).where('departments.id > 5').map{|i| i.department.try(:id)}
#SQL (26.8ms)  SELECT `users`.`id` AS t0_r0, `users`.`email` AS t0_r1, `users`.`encrypted_password` AS t0_r2, `users`.`reset_password_token` AS t0_r3, `users`.`reset_password_sent_at` AS t0_r4, `users`.`remember_created_at` AS t0_r5, `users`.`sign_in_count` AS t0_r6, `users`.`current_sign_in_at` AS t0_r7, `users`.`last_sign_in_at` AS t0_r8, `users`.`current_sign_in_ip` AS t0_r9, `users`.`last_sign_in_ip` AS t0_r10, `users`.`loginname` AS t0_r11, `users`.`prefer_address_id` AS t0_r12, `users`.`created_at` AS t0_r13, `users`.`updated_at` AS t0_r14, `users`.`prefer_invoice_id` AS t0_r15, `users`.`cart` AS t0_r16, `users`.`prefer_ptype` AS t0_r17, `users`.`parent_id` AS t0_r18, `users`.`realname` AS t0_r19, `users`.`auth_token` AS t0_r20, `users`.`zcl_usertype` AS t0_r21, `users`.`zcl_topname` AS t0_r22, `users`.`zcl_depname` AS t0_r23, `users`.`zcl_depcode` AS t0_r24, `users`.`zcl_userid` AS t0_r25, `users`.`zcl_username` AS t0_r26, `users`.`zcl_realname` AS t0_r27, `users`.`department_id` AS t0_r28, `users`.`email_token` AS t0_r29, `users`.`token_expiration_at` AS t0_r30, `users`.`status` AS t0_r31, `users`.`emall_id` AS t0_r32, `users`.`mobile` AS t0_r33, `users`.`disagree_msg` AS t0_r34, `users`.`log_out_url` AS t0_r35, `users`.`user_mobile` AS t0_r36, `users`.`errors_count` AS t0_r37, `users`.`order_status` AS t0_r38, `users`.`is_industrial_purchaser` AS t0_r39, `users`.`purchase_type` AS t0_r40, `departments`.`id` AS t1_r0, `departments`.`name` AS t1_r1, `departments`.`short_name` AS t1_r2, `departments`.`org_code` AS t1_r3, `departments`.`org_code_pic` AS t1_r4, `departments`.`legal_name` AS t1_r5, `departments`.`legal_code` AS t1_r6, `departments`.`legal_code_pic` AS t1_r7, `departments`.`area_id` AS t1_r8, `departments`.`address` AS t1_r9, `departments`.`post_code` AS t1_r10, `departments`.`url` AS t1_r11, `departments`.`ancestry` AS t1_r12, `departments`.`ancestry_depth` AS t1_r13, `departments`.`summary` AS t1_r14, `departments`.`short_url` AS t1_r15, `departments`.`bank` AS t1_r16, `departments`.`bank_code` AS t1_r17, `departments`.`industry` AS t1_r18, `departments`.`cgr_nature` AS t1_r19, `departments`.`gys_nature` AS t1_r20, `departments`.`capital` AS t1_r21, `departments`.`license` AS t1_r22, `departments`.`license_pic` AS t1_r23, `departments`.`tax` AS t1_r24, `departments`.`tax_pic` AS t1_r25, `departments`.`employee` AS t1_r26, `departments`.`turnover` AS t1_r27, `departments`.`lng` AS t1_r28, `departments`.`lat` AS t1_r29, `departments`.`created_at` AS t1_r30, `departments`.`updated_at` AS t1_r31, `departments`.`order_num` AS t1_r32, `departments`.`company_type` AS t1_r33, `departments`.`hotel_star` AS t1_r34, `departments`.`product_orientation` AS t1_r35, `departments`.`product_location` AS t1_r36, `departments`.`reg_pic` AS t1_r37, `departments`.`level` AS t1_r38, `departments`.`is_top` AS t1_r39, `departments`.`key_word` AS t1_r40, `departments`.`is_delete` AS t1_r41, `departments`.`is_allow_add` AS t1_r42, `departments`.`is_center` AS t1_r43, `departments`.`belong_center` AS t1_r44, `departments`.`logo_pic` AS t1_r45, `departments`.`tel` AS t1_r46, `departments`.`fax` AS t1_r47, `departments`.`personal_style_id` AS t1_r48, `departments`.`logo_second_pic` AS t1_r49, `departments`.`use_own` AS t1_r50, `departments`.`use_id` AS t1_r51, `departments`.`code` AS t1_r52, `departments`.`auth_code` AS t1_r53, `departments`.`use_budget` AS t1_r54, `departments`.`use_upload` AS t1_r55, `departments`.`show_platform_product` AS t1_r56, `departments`.`logo_goto_url` AS t1_r57, `departments`.`show_trends` AS t1_r58, `departments`.`can_purchase_gyp` AS t1_r59, `departments`.`use_root` AS t1_r60, `departments`.`open_esp` AS t1_r61, `departments`.`show_department_product` AS t1_r62, `departments`.`card_codes` AS t1_r63, `departments`.`third_department_id` AS t1_r64, `departments`.`use_protocol_mall` AS t1_r65 FROM `users` INNER JOIN `departments` ON `departments`.`id` = `users`.`department_id` AND (is_delete = false) WHERE (departments.id > 5)
```


