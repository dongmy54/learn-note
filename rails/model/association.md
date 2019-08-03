#### association
> 1. `has_many` 和 `belongs_to`时,外键一样 
> 2. `belongs_to`时加`_id`推出外键
> 3. `has_many`时 由当前类推出外键

##### 关联条件
> 指的是: 关联后再做筛选

```ruby
class User < ApplicationRecord
  has_many :addresses, -> {where(country: 'sd')}
end
```

##### has_many through
> `source`指的是 另外关联的对象

```ruby
# 用户
class JavaSysUser < JavaDatabaseConnection
  self.table_name = 'sys_user'

  has_many :sys_user_roles, class_name: 'JavaSysUserRole', foreign_key: 'user_id'
  has_many :sys_roles, through: :sys_user_roles, source: :sys_role  # 这里是 中间表 关联对象指定
end

# 用户-角色
# user_id
# role_id
class JavaSysUserRole < JavaDatabaseConnection
  self.table_name = 'sys_user_role'

  belongs_to :sys_user, class_name: 'JavaSysUser', foreign_key: 'user_id'
  belongs_to :sys_role, class_name: 'JavaSysRole', foreign_key: 'role_id' # 即这里的 belongs_to :sys_role
end
```

