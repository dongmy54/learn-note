#### serialize 方法
>将数据序列化为数组/hash
```ruby
class Order
  serialize :track, Array
  serialize :emall_body, Hash
end

```

#### accepts_nested_attributes_for
>1. 一对多关系
>2. 创一个model同时创建另外一个model
>3. [链接](https://rubyplus.com/articles/3681-Complex-Forms-in-Rails-5)
```ruby
class Article
  has_many :attachments, :as => :attachable
  accepts_nested_attributes_for :attachments, :reject_if => lambda { |item| item[:file].blank? }, :allow_destroy => true
end
```

#### assign_attributes 批量赋值
```ruby
user = User.new
user.assign_attributes email: '23@qq.com', status: 1
user.email     # "23@qq.com"
user.status    # 1

user.new_record?  # true
```

