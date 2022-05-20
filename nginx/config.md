##### 配置
> 1. 在生成环境中我的配置文件都是分开配置，然后在主配置文件中组合而成的
> 2. 我们通过主配置文件和次配置文件要注意嵌套的层级

关于静态文件伺服要注意
> 1. 需要给静态文件目录分配可执行权限
> 2. 需要给nginx运行用户，这里是（www-data)分配文件的用户、组权限
```shell
chown -R www-data:www-data /root/static

chmod o+x /root
chmod o+x /root/static
```

##### 主配置文件（/etc/nginx/nginx.conf）
```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
  worker_connections 768;
  # multi_accept on;
}

http {

  ##
  # Basic Settings
  ##

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  # server_tokens off;

  server_names_hash_bucket_size 64;
  # server_name_in_redirect off;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # SSL Settings
  ##

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  ##
  # Logging Settings
  ##

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  ##
  # Gzip Settings
  ##

  gzip on;

  # gzip_vary on;
  # gzip_proxied any;
  # gzip_comp_level 6;
  # gzip_buffers 16 8k;
  # gzip_http_version 1.1;
  # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  # 这里引入sites-enabled下文件
  include /etc/nginx/sites-enabled/*;
}


#mail {
# # See sample authentication script at:
# # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
# # auth_http localhost/auth.php;
# # pop3_capabilities "TOP" "USER";
# # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
# server {
#   listen     localhost:110;
#   protocol   pop3;
#   proxy      on;
# }
#
# server {
#   listen     localhost:143;
#   protocol   imap;
#   proxy      on;
# }
#}
```

##### 次配置文件（/etc/nginx/sites-enabled/dmy)
```
server {
        listen 80;
        listen [::]:80;

        root /var/www/dmy/html;
        #index index.html index.htm index.nginx-debian.html;
  index love_kxk.html;

        server_name 139.9.52.252;

        location / {
                try_files $uri $uri/ =404;
        }

       # 静态文件
      #location ~ \.(jpeg|jpg|png|js|css) {
      #  root /root/img;
      #}

     # 这里 static会做为文件路径的一部分
     location /static {
       autoindex on;
       root /root;
     }
}
```
