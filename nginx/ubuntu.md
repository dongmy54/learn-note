##### 在ubuntu上安装
> 1. 一个命令 `apt install nginx` 就安装好了
> 2. 确保端口开放后，直接 `systemctl start nginx` 就启动了服务
> 3. 在浏览器中 ip 直接可看欢迎界面
> 非常快速简单


##### 常用命令
```shell
nginx -t 检查配置文件修改是否正确，有错会直接提示
nginx -v 版本信息

sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx 重启（在修改配置文件后）
sudo systemctl reload nginx
sudo systemctl disable nginx
sudo systemctl enable nginx
sudo systemctl status nginx  查看状态
```

##### 文件目录介绍
```shell

/etc/nginx                      # 总配置目录
/etc/nginx/sites-enabled        # 配置文件存放位置一般用来做软连接sites-available
/etc/nginx/sites-available      # 具体配置的各个网站（域名）的地方，软连接到sites-enabled下
/etc/nginx/nginx.conf           # 主配置目录，前面我们的sites-enabled下的文件会include到这里
                                # 完成所有的nginx配置组装


# 默认访问/错误日志
/var/log/nginx/access.log
/var/log/nginx/error.log

# 默认的html文档路径 当前我们可以配置自己的比如 /var/www/your_domain/html
/var/www/html
```

