#### association
##### 关联条件
```ruby
class User < ApplicationRecord
  has_many :addresses, -> {where(country: 'sd')}
end
```
