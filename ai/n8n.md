## n8n
github地址：https://github.com/n8n-io/n8n

快速尝试使用
```shell
docker volume create n8n_data
docker run -it --rm --name n8n   -p 5678:5678   -v n8n_data:/home/node/.n8n   -e N8N_SECURE_COOKIE=false   docker.n8n.io/n8nio/n8n

# 使用rm 停掉后自动删掉容器
```

### 通过docker-compose.yaml 启动n8n
1. 服务器创建目录`mkdir n8n`
2. 创建文件`touch n8n/docker-compose.yaml`
```yaml
version: '3.8'

services:
  n8n:
    image: docker.n8n.io/n8nio/n8n:latest # 建议替换为具体的版本号，例如 :1.30.0
    restart: always
    # 如果你没有反向代理，或者想直接通过HTTP访问n8n，请取消注释下面这行
    # 这样n8n的5678端口会映射到宿主机的5678端口
    ports:
      - "5678:5678" # <--- 如果没有反向代理，请务必取消注释此行！
    volumes:
      - n8n_data:/home/node/.n8n # n8n的数据卷
    environment:
      # n8n 核心配置
      - N8N_HOST=your_domain
      - N8N_PROTOCOL=http # <--- 将HTTPS改为HTTP
      - WEBHOOK_URL=http://n8n.your_domain/ # <--- 将HTTPS改为HTTP
      - N8N_PORT=5678 # n8n内部监听端口
      - N8N_SECURE_COOKIE=false // 这里设置为false是由于我们没有打开https，只有false本地才可以访问

      # 数据库配置 (PostgreSQL)
      - DB_TYPE=postgres
      - DB_POSTGRES_HOST=postgres # 数据库服务名，在docker-compose网络中
      - DB_POSTGRES_PORT=5432
      - DB_POSTGRES_DATABASE=n8n # n8n使用的数据库名
      - DB_POSTGRES_USER=n8n # n8n连接数据库的用户名
      - DB_POSTGRES_PASSWORD=postgres_password # <-- 替换为强密码

      # 安全配置
      - N8N_ENCRYPTION_KEY=your_strong_encryption_key # <-- 替换为随机生成的强密钥，用于加密凭据

      # 其他可选配置
      - TZ=Asia/Shanghai # 设置时区

    depends_on:
      - postgres # 确保postgres服务在n8n之前启动

  postgres:
    image: postgres:15 # 推荐使用特定版本，例如 postgres:15
    restart: always
    volumes:
      - n8n_postgres_data:/var/lib/postgresql/data # PostgreSQL数据卷
    environment:
      - POSTGRES_DB=n8n # 数据库名，与n8n配置一致
      - POSTGRES_USER=n8n # 用户名，与n8n配置一致
      - POSTGRES_PASSWORD=postgres_password # <-- 替换为强密码，与n8n配置一致

volumes:
  n8n_data:
  n8n_postgres_data:
```

```
sudo curl -L "https://github.com/docker/compose/releases/download/2.35.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

启动`docker compose -f n8n/docker-compose.yaml up`
填写owner信息（关键是邮箱等，从邮件获取配置激活key）

### cloudflare配置域名
1. 首先开启一个隧道
2. 然后点击隧道-编辑；配置公共主机名（配置好后自动生成域名记录）

#### nginx配置
sites-available/n8n配置
```nginx
server {
    listen 80;
    server_name n8n.dmyapp.top; # <-- ！！！重点检查这里，确保是 n8n.dmyapp.top 且没有拼写错误

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-N8N-Proxy-Uri $request_uri; # 某些情况下n8n需要这个头

        # WebSocket 支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    access_log /var/log/nginx/n8n.access.log;
    error_log /var/log/nginx/n8n.error.log;
}
```

链接
```shell
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/n8n
```

