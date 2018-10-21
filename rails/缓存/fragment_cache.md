#### 片段缓存
>1. rails默认启用的缓存方式
>2. 使用：将页面上，一段内容缓存（包含一些动态数据组合成的html)

ps: 开发环境测试缓存，`rake dev:cache`(会创建tmp/caching-dev.txt)
```
<% cache project do %>
   ...
<% end %>
```
>3. 原理：缓存的片段会根据设定生成一个键,比如会生成 `views/projects/3-20141130131120000000000/366bcee2ae9bd3aa0738785aea6ec97d` 键,中间为 project id接着为updated_at时间戳,最后是页面摘要；只要project updated_at 或页面内容 改变都会使缓存失效；失效后将重新生成新的缓存条目，旧的键rails 会帮我们自动删除掉，所以也不用担心。

##### 使用
cache后 什么也不接
```
<% cache do %>
  <p> hello welcome cache </p>
<% end %>
```

cache后 接对象
```
<% cache project do %>
  <b>All the topics on this project</b>
  <%= render project.topics %>
<% end %>

``` 

cache后 接数组
```
<% cache [project, current_user] do %>
  <b>All the topics on this project</b>
  <%= render project.topics %>
<% end %>
```
>缓存的更新策略，和cache后接的对象相关，当为数组时，也就表示和数组中多个元素相关。
