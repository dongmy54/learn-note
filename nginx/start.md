#### nginx 起步

##### 基本
> 1. 安装 `brew install nginx`
> 2. 启动 `brew services start nginx`
> 3. 重启 `brew services restart nginx`

##### 各文件位置
> 统一在 `/usr/local`下

> 1. 配置文件位置 `/usr/local/etc/nginx/nginx.conf`
> 2. 页面文件位置 `/usr/local/var/www`目录下
> 3. 日志文件  `/usr/local/var/log`目录下
> 4. 端口文件 `/usr/local/var/run/nginx.pid`

##### 默认
> 默认端口号是 8080,可在`http://localhost:8080/`查看

