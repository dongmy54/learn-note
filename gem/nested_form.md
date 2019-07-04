#### nested_form
> 主要和 `accepted_nested_attributes_for`搭配,实现对层叠表单的动态插入/删除

##### 用法
> 1. `link_to_add` `link_to_remove` 添加/删除
> 2. 对于表单/列表,指明添加id`data: {target: '#items'}`

```ruby
# user.rb
class User < ActiveRecord::Base
  has_many :items
  accepts_nested_attributes_for :items, allow_destroy: true
end
```

```ruby
# item.rb
class Item < ActiveRecord::Base
  belongs_to :user
end
```

```ruby
# uses_controller.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    User.create(user_params)
  end

  private
    def user_params
      # items_attributes 单/复数由关联决定
      # items_attributes 中带数组字段
      params.require(:user).permit(:name, :old, items_attributes: [:name, :desc])
    end
end
```

```html
# new.html.erb
<h1>Users#test</h1>

<%= nested_form_for @user do |f| %>
  <div>用户名字<%= f.text_field :name %></div>
  <div>用户年龄<%= f.text_field :old %></div>

  <p><%= f.link_to_add "添加条目", :items, data: {target: '#items'} %></p>

  <table id="items">
    <%= f.fields_for :items do |item_form| %>
      <tr>
        <td>名称<%= item_form.text_field :name %></td>
        <td>描述<%= item_form.text_field :desc %></td>
        <td><%= item_form.link_to_remove '删除条目' %></td>
      </tr>
    <% end %>
  </table>
  

  <%= f.submit '提交' %>
<% end %>
```