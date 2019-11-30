#### 片段缓存
> 将页面中一段html片段做缓存


##### 无键
> `views/localhost:3000/authors/frag_test/f2fec4a82cbe6d238505079892c26cb1`

```ruby
<% cache do %>
  some code
<% end %>
```


##### 对象键
> `views/authors/312-20191126100651882354000/c26a8d66b3b0055caf45f28d4006d776`

```ruby
<% cache @author do %>
  <h5>作者信息</h5>
  <p>name: <%= @author.name %></p>
  <p>age: <%= @author.age %></p>
<% end %>
```


##### 数组键
> `views/authors/303-20191126100651606879000/articles/1203-20191126100651626618000/b1ee07c81da0eae1fd840c7c5aaa1835`

```ruby
<% cache [@author,@article] do %>
  <h5>作者信息</h5>
  <p>文章标题：<%= @article.title %></p>
  <p>name: <%= @author.name %></p>
  <p>age: <%= @author.age %></p>
<% end %>
```

##### 有效期
> 1. 指定有效期必须先指定键
> 2. `views/my_cache_key/6c260298e90a834925b7`

```ruby
<% cache 'my_cache_key', expires_in: 10.second do %>
    some code
<% end %>
```

##### 集合
> 1. rails 5 才支持
> 2. 性能比each 每个条目,做缓存更好

```ruby
<%= render partial: 'authors/author', collection: @authors, cached: true %>
```






