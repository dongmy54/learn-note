#### 俄罗斯套娃缓存
>1. 片段缓存的延伸,粒度更细
>2. 解决：外层对象过期，内层所有对象都需要重新生成问题
> PS：内存缓存方必须`touch: true`保证内层同步更新

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
<% cache author do %>
  <tr>
    <td><%= author.id %></td>
    <td><%= author.name %></td>
    <td><%= author.age %></td>
    <td>
      <% author.articles.each do |article| %>
        <% cache article do %>
          <span><%= article.title %></span>
        <% end %>
      <% end %>
    </td>
  </tr>
<% end %>
```
