#### 俄罗斯套娃缓存
>1. 简单点说就是片段缓存的嵌套，它的粒度更细
>2. 优点；如果我们直接缓存一个数据集,当其中一条数据更新时，所有缓存都不能使用；而将缓存细分下去,可以避免这样的问题
>3. 通常用于,一对多的场景,在belongs_to的一方设定 touch: true

#### 用法
```ruby
# user.rb
class User < ApplicationRecord
  has_many :collections
end
```

```ruby
# collection.rb
class Collection < ApplicationRecord
  belongs_to :user, touch: true
end
```

```html
<% cache @user %>
  <% @user.collections.each do |collection| %>

    <%# 对内层collection 缓存  %>
    <% cache collection do %>
      <%= collection.name %>
    <% end %>

  <% end %>
<% end %>
```