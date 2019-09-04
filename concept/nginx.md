#### nginx

#### 反向代理
> 代理服务器接受到请求后，将请求转发给其它服务器，从其它服务器接收到结果后，再返回客户端
> 举例：我们访问`https://www.baidu.com/`,其背后真正的服务器，我们并不知道具体是哪个，这里只是将请求转发到幕后服务器了

```ruby
server {
  listen 80;
  server_name localhost;
  client_max_body_size 1024M;

  location /{
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host:$server_port;
  }
}
# 当请求 localhost的时候，相当于访问 localhost:8080
```

#### 正向代理
> 客户端向代理服务器发送一个请求，并指定目标服务器,之后代理服务器向目标服务器转交，并将获得内容返回客户端
> 举例： vpn

#### 正向代理和反向代理区别
> 1. 正向代理隐藏的是客户端
> 2. 反向代理隐藏的是服务端
> 3. 正向代理需要在客户端配置代理服务器（ip)

#### 负载均衡
> 1. 当有2台或2台以上服务器的时候,代理服务器，负责将请求分发到不同的服务器上
> 2. 支持PR(默认)、权重、ip_hash

##### PR（默认）
```ruby
upstream test{
  server localhost:8080;
  server localhost:8081;
}
# 当8081不能访问时，会自动使用8080
```

##### 权重
```ruby
upstream test{
  server localhost:8080 weight=9;
  server localhost:8081 weight=1;
}
```

##### ip_hash
```ruby
upstream test{
  ip_hash;
  server localhost:8080;
  server localhost:8081;
}

# 同一ip访问同一台服务器,解决session登录问题（在其中一台登录，访问另外一台需重新登录）
```

#### http服务器
> 可以用做静态资源服务器，将静态资源和动态资源分开

```ruby
upstream test{
  server localhost: 8080;
  server localhost: 8081;
}

server {
  listen 80;
  server_name localhost;

  location /{
    root e:\wwwroot;
    index index.html;
  }

  # 所有静态资源请求由nginx处理
  location ~ \.(gif|jpg|jpeg|png|bmp|swf|css|js)${
    root e:\wwwroot;
  }

  # 所有动态请求都转发给tomcat处理
  location ~\.(jsp|do)${
    proxy_pass http://test;
  }
}
```





