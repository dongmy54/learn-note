## docker 快速入门

### 一、为什么要用docker?
在传统的项目部署中，要部署一个项目通常特别麻烦，因为一个项目要跑起来依赖于它所属的环境。

比如一个rails项目，要跑起来需要各种gems，这些gems之间相互依赖，并且对版本有严格的要求。在这种情况，部署项目非常费劲，通常搞好一个环境就需要花费大量的时间。

而docker完美的解决了上述问题，可以简单的理解为：**它的思路在于将相关的环境打包好，然后直接分发到部署环境，极大的简化了部署**。

使用docker的另外一个好处是，在我们本地开发时，通常需要很多很多其它的服务，比如mysql、redis等，直接去装的话，通常比较麻烦。**使用docker可以很方便的开启一些服务供我们开发环境使用**。

### 二、如何开始学习docker
总的来说，docker的入门学习还是很简单，在开始学习之前，强烈建议装下`desktop`,地址在这里https://hub.docker.com/

为什么要装它呢？
1. 它将许多操作可视化了，在了解了可视化操作原理之后，再去了解命令就非常容易，只是换了一种方式而已。
2. 在desktop中，也提供了一些快速的学习教程，非常方便。

利用此工具，我们可以pull一些镜像，然后直接run试试看，然后进行命令行的使用。

PS：利用docker desktop 工具搜索镜像需要科学上网。
### 三、实操1(构建镜像到-容器)
PS： 这里主要说明命令行如何操作，可以对照着在desktop中去做相应的操作查看。

#### 1. 拉取测试项目
```shell
git clone git@github.com:docker/welcome-to-docker.git
cd welcome-to-docker
```

#### 2.认识Dockerfile文件
查看项目下的Dockerfile文件，这个文件很重要，**`Dockerfile`文件是构建镜像的必要文件，这个文件说明了如何去构建镜像**。
```
# Dockerfile
# 基于node镜像的 lastest(版本/标签)做修改
FROM node:latest

# 工作目录是/app(后续的RUN COPY操作的文件都会以此目录为基础)
WORKDIR /app

# 复制项目下的 package.json和package-lock.json文件到 /app目录下
COPY package*.json ./

# 复制项目下的src和public目录到 容器中app/目录下的src和public目录
COPY ./src ./src
COPY ./public ./public

# Install node packages, install serve, build the app, and remove dependencies at the end
# 安装node包，server 构建app.. 
# 时间点：RUN用于构建镜像时执行命令；目的：修改和配置镜像
RUN npm install \
    && npm install -g serve \
    && npm run build \
    && rm -fr node_modules

# 对外暴露端口 这里指定的是容器内的
EXPOSE 3000

# 用serve命令启动app
# 时间点：运行容器时执行； 目的：为启动的容器执行，启动要执行的命令
CMD [ "serve", "-s", "build" ]
```

#### 3. 构建镜像
在项目所在目录下执行`docker build -t weclcome-to-docker .`
> PS：这一步第一次执行会比较慢
```shell
 dongmingyan@pro ⮀ ~/docker-learn/welcome-to-docker ⮀ ⭠ main± ⮀ docker build -t weclcome-to-docker .
[+] Building 15.6s (11/11) FINISHED                                                                                          docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                         0.0s
 => => transferring dockerfile: 644B                                                                                                         0.0s
 => [internal] load .dockerignore                                                                                                            0.0s
 => => transferring context: 52B                                                                                                             0.0s
 => [internal] load metadata for docker.io/library/node:latest                                                                              15.4s
 => [1/6] FROM docker.io/library/node:latest@sha256:36aca218a5eb57cb23bc790a030591382c7664c15a384e2ddc2075761ac7e701                         0.0s
 => [internal] load build context                                                                                                            0.0s
 => => transferring context: 393B                                                                                                            0.0s
 => CACHED [2/6] WORKDIR /app                                                                                                                0.0s
 => CACHED [3/6] COPY package*.json ./                                                                                                       0.0s
 => CACHED [4/6] COPY ./src ./src                                                                                                            0.0s
 => CACHED [5/6] COPY ./public ./public                                                                                                      0.0s
 => CACHED [6/6] RUN npm install     && npm install -g serve     && npm run build     && rm -fr node_modules                                 0.0s
 => exporting to image                                                                                                                       0.0s
 => => exporting layers                                                                                                                      0.0s
 => => writing image sha256:c9b45a6aada9fe48f7813192e21a4a9d814c1548a3daf16048046cfa0962a58d                                                 0.0s
 => => naming to docker.io/library/weclcome-to-docker                                                                                        0.0s

What's Next?
  View summary of image vulnerabilities and recommendations → docker scout quickview
```
查看生成的镜像,可以看到已经生成了`weclcome-to-docker`镜像
```shell
dongmingyan@pro ⮀ ~/docker-learn/welcome-to-docker ⮀ ⭠ main± ⮀ docker images
REPOSITORY           TAG          IMAGE ID       CREATED         SIZE
weclcome-to-docker   latest       c9b45a6aada9   13 hours ago    1.08GB
mongo                6            00a1e8990302   8 days ago      669MB
alpine/git           latest       22d84a66cda4   9 months ago    43.6MB
postgres             latest       07e2ee723e2d   20 months ago   374MB
nginx                latest       605c77e624dd   20 months ago   141MB
redis                6.0-alpine   e8d44e1fcf20   21 months ago   31.4MB
ubuntu               latest       ba6acccedd29   23 months ago   72.8MB
mashirozx/mastodon   latest       36a2cc9bbb9a   2 years ago     1.95GB
```
#### 4.创建容器
有了镜像后我们就可以运行镜像，生成一个容器，运行命令`docker run --name my_container -p 4000:3000 -d weclcome-to-docker:latest`

```shell
dongmingyan@pro ⮀ ~/docker-learn/welcome-to-docker ⮀ ⭠ main± ⮀ docker run --name my_container -p 4000:3000 -d weclcome-to-docker:latest
59b5e3d1017f6c430fa8d2b05f0d7521fbb8866d482178ad77c75726effa9d3e
```
这里返回的字符串是容器id,执行命令`docker ps -a`查看当前运行的容器
```shell
dongmingyan@pro ⮀ ~/docker-learn/welcome-to-docker ⮀ ⭠ main± ⮀ docker ps -a
CONTAINER ID   IMAGE                       COMMAND                   CREATED         STATUS         PORTS                    NAMES
59b5e3d1017f   weclcome-to-docker:latest   "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:4000->3000/tcp   my_container
```
看它的状态是up说明它已经正常启动了，此时在浏览器可以正常访问 `http://localhost:4000`看效果啦！


### 四、实操2（从仓库镜像运行容器）
### 五、实操3 (compose多容器)
### 六、docker中的核心概念和文件
#### 1. 镜像
#### 2. 容器
#### 3. Dockefile
#### 4. compose.yml
### 七、docker常用命令汇总
```bash
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

# 在容器内创建备份文件
docker exec -it my_postgres_container pg_dump -U postgres -W -F t my_database > my_database_backup.tar

# 将备份文件从容器复制到宿主机
docker cp my_postgres_container:/path/to/backup/in/container/my_database_backup.tar /path/to/backup/on/host/
```



