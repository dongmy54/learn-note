### docker
```bash
docker --help # 帮助信息
docker -v # 查看docker版本
docker info # docker 信息

# 构建镜像
# docker build -t IMAGE_NAME:TAG PATH_TO_DOCKERFILE
# 利用当前目录下的Dockefile去构建一个叫 weclome-to-docker的镜像(默认情况下tag为：latest)
docker build -t welcome-to-docker . 
# 多了:xx 构建镜像的同时指定tag(同一个镜像名可有多个tag)
docker build -t welcome-to-docker:20230910 .
# docker save -o my-image.tar my-image:tag
# 将镜像welcome-to-docker打包成welcome-to-docker.tar
docker save -o welcome-to-docker.tar welcome-to-docker

docker load < my-image.tar.gz # 从文件中加载docker镜像

docker images # 查看有哪些镜像
# 删除镜像 weclcome-to-docker tag名为20230910
docker rmi welcome-to-docker:20230910 

# docker run --name my-container my-image # 通过镜像 创建容器
# 指定容器名my_container 
# 端口映射 4000（外部）- 3000（容器内） 
# -d 后台运行
# weclcome-to-docker-镜像名
# lastest- tag号
docker run --name my_container -p 4000:3000 -d weclcome-to-docker:latest

docker ps -a  # 查看有哪些容器
docker exec -it kb-ent-api(container name) /bin/bash # 进入容器内部

docker stop container_name # 优雅关闭容器(推荐使用，使用后在rm删除容器)
docker kill container_name # 强制关闭
dokcer rm container_name   # 强力删除（这个命令 不能直接用于running状态的容器，除了关闭容器，还会删除相关文件系统、网络、卷等）

docker start container_name   # 用于容器已经死了 或退出
docker restart container_name # 容器还活着

docker inspect <container_name_or_id> #查看容器信息，非常详细
# 格式化输出容器信息 这里代码查看ip信息
docker inspect --format='{{.NetworkSettings.IPAddress}}' <container_name_or_id>

# 日志
docker logs kb-ent-api       # 查看容器运行情况（制定容器日志）
docker logs --stderr web-app # 查看日志标准错误
docker logs -f web-app       # 动态查看日志

# 在容器内创建备份文件
docker exec -it my_postgres_container pg_dump -U postgres -W -F t my_database > my_database_backup.tar

# 将备份文件从容器复制到宿主机
docker cp my_postgres_container:/path/to/backup/in/container/my_database_backup.tar /path/to/backup/on/host/


# compose
docker compose up -d # 开启容器组
docker-compose down  # 关闭容器组
docker-compose ps    # 查看容器组
docker-compose logs  # 查看容器组日志
docker-compose exec CONTAINER_NAME COMMAND # 容器内部执行命令
```
