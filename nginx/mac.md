##### nginx用途
> - 1. 用于负载均衡（反向代理）
> - 2. 动静分离（静态文件和动态请求分开）
> - 3. 子域名/路径配置


##### 安装
> 对于mac上安装 `brew install nginx`
> 安装后,默认可以在 `localhost:8080`查看
> - 配置文件 `/usr/local/etc/nginx/nginx.conf`
> - 日志文件 `/usr/local/var/log/nginx`


##### 命令
> - nginx 启动nginx
> - nginx -s stop 关掉nginx
> - nginx -s reload 重现载入配置


##### mac上示例
```
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
  
  # 用于配置负载均衡 此处myserver1随便命令；这里server一般是多个
  upstream myserver1 {
      server localhost:3001;
  }

  server {
      listen       9090;
      server_name  sub1.localhost; # 这里配置了子域名

      charset utf-8;

      #access_log  logs/host.access.log  main;

      location / {
          #root   html;
          #index  index.html index.htm;
          #root /Users/dongmingyan/html;
          #index test.html;
          proxy_pass http://myserver1; # 代理转发
      }

      # 静态文件
      location ~ \.(jpg|png|js|css) {
        root /Users/dongmingyan/Desktop;
      }

      # 路径配置(sub1.localhost:9090/hubar)
      location /hubar/ {
        # PS： 1. 路径默认会把路径（这里的hubar)带入到目录中，如果文件名hubar不一致所以这里用了alias
        #      2. 目录 /Users/dongmingyan/html/ 尾部"/"一定要带 否则会403
        alias /Users/dongmingyan/html/;
        index test3.html;
        #proxy_pass https://www.baidu.com/;
      }
  }

  # 引入配置文件（PS: 这里是在http里，所以引入的文件只写http内部配置）
  include ./config1.conf;
}
```




