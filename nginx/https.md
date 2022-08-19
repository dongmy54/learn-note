##### 添加https证书
> 可以用一个工具 cerbot,非常简单
PS： 前提是你需要有域名

###### 操作
```bash
# 确保已经安装了snap

# 保证snap最新
sudo snap install core; sudo snap refresh core

# 安装cerbot(仅第一次)
sudo snap install --classic certbot

# （仅第一次）
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# 获取证书，且编辑配置文件（常用）=====第一次后，只需要执行此
sudo certbot --nginx
```

