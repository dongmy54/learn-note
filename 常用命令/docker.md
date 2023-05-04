### docker
```bash
docker load < my-image.tar.gz # 从文件中加载docker镜像

docker images # 查看有哪些镜像
docker ps -a  # 查看有哪些容器
docker exec -it kb-ent-api(container name) /bin/bash # 进入容器内部

docker run --name my-container my-image # 通过镜像 创建容器

docker stop container_name # 优雅关闭容器
docker kill container_name # 强制关闭
dokcer rm container_name   # 强力删除（除了关闭容器，还会删除相关文件系统、网络、卷等）

docker start container_name   # 用于容器已经死了 或退出
docker restart container_name # 容器还活着

docker inspect <container_name_or_id> #查看容器信息，非常详细
# 格式化输出容器信息 这里代码查看ip信息
docker inspect --format='{{.NetworkSettings.IPAddress}}' <container_name_or_id>

# 日志
docker logs kb-ent-api       # 查看容器运行情况（制定容器日志）
docker logs --stderr web-app # 查看日志标准错误
docker logs -f web-app       # 动态查看日志
```
