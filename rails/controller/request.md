#### request
> * `request.referer` 来源url（可为nil)

##### request.env VS request.headers
> 都能拿到请求头
> 1. `headers` （PS：自定义头只能中横线`-`分割）
> 2. `env`
> * 以`HTTP_`为前缀
> * 取时（小写转大写）
> * 取时（中横线转下划线）

```ruby
# 原始头 dmy-k

request.headers['dmy-k']
# => "dmy"

request.env['HTTP_DMY_K']
# => "dmy"

request.base_url
# => "http://localhost:3000"
```

##### redirect_to 重定向
```ruby
# rails 4.x

redirect_to request.referer || root_path
# rails 5.x
redirect_back(fallback_location: root_path) # 预留回滚位
```
