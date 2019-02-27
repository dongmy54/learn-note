#### serialize 方法
>将数据序列化为数组/hash
```ruby
class Order
  serialize :track, Array
  serialize :emall_body, Hash
end

```