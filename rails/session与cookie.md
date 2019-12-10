##### 为了解决什么问题？
> * 由于http本身是无状态的，上次请求和下次请求之间相互独立；服务器为了识别不同用户发来的请求，所以弄出了session
> * cookie 是为了在客户端记录某些数据；比如：一个网站的登录（我们上次设定了记住密码，下次就不会再次输入；持久存储cookie）;还有就是 一些服务端发送过来的的临时性数据；


##### 会话cookie与持久化cookie
> 1. 会话: 无过期时间、存于浏览器内存（退出浏览器则消息）
![Snip20191210_1.png](https://i.loli.net/2019/12/10/viLnZgqMX4o9eIQ.png)
> 2. 持久化：存于客户端硬盘中（退出浏览器不影响 下次仍然存在）


##### session创建流程
> 1. 首次进一个网站，服务器端发现请求头中没有对应的session信息，这个时候，就会去创建session;
> 2. 然后将 这个session的id,通过set-cookie的方式，返回响应；
> 3. 客户端记录下session的id;
> 4. 下次请求的时候，在cookie中带上这个session,服务器端通过这个session id去判断用户状态


##### 常见session实现机制
> 1. cookie中存储session(rails默认）
> * 将所有数据全部加密后存于cookie中，服务器不做任何存储；
> * 客户端请求时，带上cookie，服务端根据cookie解密后数据判断用户状态
> * 类似顾客一张卡，卡片上存消费记录，店家不做任何记录

> 2. cookie 与 session结合
> * cookie中仅存session_id(表识)，数据存于服务器
> * 客户端请求时，带上cookie，服务端根据session_id在服务器查找相应记录，判断用户状态
> * 类型顾客一张卡，卡片仅是一个身份凭证（本身不记录任何信息），卡片的消费记录存于店家


##### rails中session的实现
rails中session存储有以下几种方式：
>1. cookie_store
>2. 缓存
>3. active_record_store
>4. memcached(集群)

> 默认下，通过cookie 进行存储，最简单、也轻量；rails 会利用 config/secrets.yml 对 session 进行 加密和解密


##### session 配置
```ruby
# session 配置
# app/config/initializers/session_store.rb
Rails.application.config.session_store :active_record_store, key: '_zhu_hai', expire_after: 1.hour
```


##### active_record_store
> 1. 将session记录持久化到数据库中（默认sessions表）
> 2. 退出会手动删除此条session记录
> 3. 用`ActiveRecord::SessionStore::Session.last`查看


##### cookie_store解密
```ruby
require 'cgi'
require 'json'
require 'active_support'

def verify_and_decrypt_session_cookie(cookie, secret_key_base)
  cookie = CGI::unescape(cookie)
  salt         = 'encrypted cookie'
  signed_salt  = 'signed encrypted cookie'
  key_generator = ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000)
  secret = key_generator.generate_key(salt)[0, ActiveSupport::MessageEncryptor.key_len]
  sign_secret = key_generator.generate_key(signed_salt)
  encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: JSON)

  encryptor.decrypt_and_verify(cookie)
end


cookie = 'Nk43WTJ4RzFmc1ZvZ1prUXRaajM5dDdOSG1wSnZiK2d6Smw0OGppbHEzOFZzbkw1enBHSFhnL3VvQTduMkNHWk5SZEQ5d2FzS1lEN3d1djlnWUk1cm1QU2FydlR6ZDFsUXF6Nk1FV1duRXVQZC9YaFY0RWNIbmsvb09kRmEwVXo0SGU5eUJjUmRWRFA1RUlTTUlRaG13PT0tLUthN3BDbXVOQnZRVkx5aU1kRm0wdUE9PQ%3D%3D--b6a56784056259c066483f36d99f89a305b71d9f'
secret_key_base = 'a0fdebc2ed45435555584bcfd9825a46faa5056377cfda601345534f618346454a27e451f8535e3a7e67abee778647b34afac45fa9f3b0a588999e3f8722e903'

puts verify_and_decrypt_session_cookie(cookie, key).inspect
# {"session_id"=>"0f78ed7e1cebb1bc2902415cb5a9b441", "_csrf_token"=>"n62iicYqfNx/uN0jTiiBJD4FSUVoVvQ/SwkdTJiZBCk="}
```





