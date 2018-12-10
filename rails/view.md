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