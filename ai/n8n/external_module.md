## 添加外部模块

### 1. Dockerfile 
```shell
# 1. 使用官方的 n8n 镜像作为基础
# 你可以指定一个具体的版本，例如 n8nio/n8n:1.22.1，以保证稳定性
FROM n8nio/n8n:latest

# 2. 为了安装全局 npm 包，临时切换到 root 用户
USER root

# 3. 全局安装包
RUN npm install -g marked

# 5. 为了安全，切换回 n8n 的默认非 root 用户
USER node
```

### 2. docker-compose.yml
和dockerfile保证同一目录下
```shell
services:
  n8n:
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    ports:
    # 其它省略
```

正常执行docker compose命令即可
