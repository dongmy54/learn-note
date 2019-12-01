#### 依赖
> 主要解决：片段缓存使用helper后产生的问题

##### 显示依赖
> 确保helper中,动态render的模版更新后，缓存能刷新

```ruby
# authors_helper.rb

# 动态渲染partial
def render_diff_by_age(author)
  if author.age > 14
    render 'big_age'
  else
    render 'small_age'
  end
end
```
```ruby
# explicit_dependence.html.erb

<% cache @author do %>
  <div class="card">
    <p>name: <%= @author.name %></p>
    
    <%# Template Dependency: authors/big_age %>
    <%# Template Dependency: authors/small_age %>
    <p><%= render_diff_by_age(@author) %></p>
  </div>
<% end %>
```

##### 外部依赖
> 确保helper方法更新后,缓存能刷新

```ruby
# authors.helper.rb

def some_method
  "<p>你们好呀! haoah</p>".html_safe
end
```

```ruby
<% cache @author do %>
  <div class="card">
    <p>name: <%= @author.name %></p>
    
    <%# Helper Dependence Updated: 2019.12.2 %>
    <%= some_method %>
  </div>
<% end %>
```


















```ruby

```
