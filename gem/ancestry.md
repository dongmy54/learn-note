#### ancestry
>搭配active_record 将记录以树形结构组织
>核心是,父节点、子节点、兄弟节点，这种相对关系

##### 字段认识
```ruby
# => #<Permission:0x007f965904a488
#  id: 19,
#  action: nil,
#  name: "三级下属1",
#  created_at: Thu, 04 Apr 2019 19:01:18 CST +08:00,
#  updated_at: Thu, 04 Apr 2019 19:01:18 CST +08:00,
#  ancestry: "13/14/17",
#  ancestry_depth: 3>

# ancestry          斜线分割每个节点id(从上到下) root节点 ancestry: nil
# ancestry_depth    代表当前节点深度
```

##### 使用
```ruby
# Table name: permissions
#
#  id             :bigint(8)        not null, primary key
#  action         :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#

class Permission < ApplicationRecord
  # 树形结构组织 
  has_ancestry cache_depth: true # 每个节点缓存深度 表中加 ancestry_depth字段

end

# 创建
boss = Permission.create(name: 'boss')

sub1 = boss.children.create(name: '一级下属')
sub2 = Permission.create(name: '一级下属', parent: boss)

sub11 = sub1.children.create(name: '二级下属')
sub21 = sub2.children.create(name: '二级下属2')

sub111 = sub11.children.create(name: '三级下属1')
sub112 = sub11.children.create(name: '三级下属2')

# 单个实例可调用方法
sub1.parent     # 父节点
sub1.children   # 自己的子 
sub112.root     # 根节点
sub11.ancestors # 从自己往上所有人

# 类方法
Permission.roots   # 返回所有根节点（ancestry 为nil)

# 作用域
sub1.children.where(name: 'sd').exists?

# 选择节点
Permission.before_depth(4) # 深度少于4的节点
Permission.at_depth(2)     # 某个深度节点
```