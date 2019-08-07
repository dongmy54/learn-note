##### 为了解决什么问题？
> * 由于http本身是无状态的，上次请求和下次请求之间相互独立；服务器为了识别不同用户发来的请求，所以弄出了session
> * cookie 是为了在客户端记录某些数据；比如：一个网站的登录（我们上次设定了记住密码，下次就不会再次输入；持久存储cookie）;还有就是 一些服务端发送过来的的临时性数据；

##### session创建流程
> 1. 首次进一个网站，服务器端发现请求头中没有对应的session信息，这个时候，就会去创建session;
> 2. 然后将 这个session的id,通过set-cookie的方式，返回响应；
> 3. 客户端记录下session的id;
> 4. 下次请求的时候，在cookie中带上这个session,服务器端通过这个session id去判断用户状态

##### rails中session的实现
rails中session存储有以下几种方式：
>1. cookie(客户端)
>2. 缓存
>3. 数据库
>4. memcached(集群)

> 默认下，通过cookie 进行存储，最简单、也轻量；rails 会利用 config/secrets.yml 对 session 进行 加密和解密

##### 设置过期时间
```ruby
# session 配置
# app/config/initializers/session_store.rb
Rails.application.config.session_store :active_record_store, key: '_zhu_hai', expire_after: 1.hour

# cookie
cookies[:token]   = {value: data['token'], expires: 1.hour.from_now} # 这里expires为时间实例 不能用1.hour
```

