#### View 相关
##### form_tag
基本用法
```
form_tag xx_url, method: :put do
  ...
```
好处
1. 可以发送任意类型的请求（put/get/post..)
2. 它会自动添加csrf 和 隐藏字段（浏览器默认不能发送put/delete等等）

##### options_for_select
```ruby
# 一般用法
select_tag :name, options_for_select(NameList, 'zhanghong')

# 1、数组列表可以为单维数组，如：[1,2,3]
# 2、options_for_select 第二个参数为选项
```