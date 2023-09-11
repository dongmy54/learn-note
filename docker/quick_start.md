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

在安装完desktop后，会自动安装一些列dokcer相关的命令，我们在需要使用docker时，直接开启desktop就可以使用了。

`docker -v` 查看docker版本,看到信息证明docker已经安装成功啦。  
```shell
dongmingyan@sc ⮀ ~ ⮀ docker -v
Docker version 24.0.5, build ced0996
```

`docker info` 查看docker 信息
```shell
dongmingyan@sc ⮀ ~ ⮀ docker info
Client:
 Version:    24.0.5
 Context:    desktop-linux
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.11.2-desktop.1
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.20.2-desktop.1
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-compose
  dev: Docker Dev Environments (Docker Inc.)
    Version:  v0.1.0
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-dev
  extension: Manages Docker extensions (Docker Inc.)
    Version:  v0.2.20
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-extension
  init: Creates Docker-related starter files for your project (Docker Inc.)
    Version:  v0.1.0-beta.6
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-init
  sbom: View the packaged-based Software Bill Of Materials (SBOM) for an image (Anchore Inc.)
    Version:  0.6.0
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-sbom
  scan: Docker Scan (Docker Inc.)
    Version:  v0.26.0
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-scan
  scout: Command line tool for Docker Scout (Docker Inc.)
    Version:  0.20.0
    Path:     /Users/dongmingyan/.docker/cli-plugins/docker-scout

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 7
 Server Version: 24.0.5
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 3dce8eb055cbb6872793272b4f20ed16117344f8
 runc version: v1.1.7-0-g860f061
 init version: de40ad0
 Security Options:
  seccomp
   Profile: unconfined
  cgroupns
 Kernel Version: 5.15.49-linuxkit-pr
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 7.675GiB
 Name: docker-desktop
 ID: 6ac1eddd-4e29-4a5e-96aa-9f23efc6d14e
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 No Proxy: hubproxy.docker.internal
 Experimental: false
 Insecure Registries:
  hubproxy.docker.internal:5555
  127.0.0.0/8
 Registry Mirrors:
  https://5pox7t83.mirror.aliyuncs.com/
  https://hub-mirror.c.163.com/
  https://mirror.baidubce.com/
  https://www.baidubce/
 Live Restore Enabled: false

WARNING: daemon is not using the default seccomp profile
```
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
#### 1. 镜像源
它就是一个云端的镜像仓库，镜像是存储在镜像源上的，获取镜像是从镜像源拉取的，；一般默认的镜像源是国外的，做为国内环境，为了加快拉取速度，我们需要更换国内镜像源。

1. 安装desktop后，可以在界面上修改，位置为：`Settings > Docker Engine`
2. 命令行修改
   - mac上文件位置：`~/.docker/daemon.json` 文件
   - linux上一般位置：`/etc/docker/daemon.json`

这是我这本地damemon.json文件信息
```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "registry-mirrors": [
    "https://5pox7t83.mirror.aliyuncs.com",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

#### 2. 拉取镜像
`docker pull redis:5.0` 执行，这里带上了tag-版本号
```shell
dongmingyan@sc ⮀ ~ ⮀ docker pull redis:5.0
5.0: Pulling from library/redis
a2abf6c4d29d: Already exists
c7a4e4382001: Pull complete
4044b9ba67c9: Pull complete
106f2419edf3: Pull complete
9772114922b9: Pull complete
63031aedd0c4: Pull complete
Digest: sha256:a30e893aa92ea4b57baf51e5602f1657ec5553b65e62ba4581a71e161e82868a
Status: Downloaded newer image for redis:5.0
docker.io/library/redis:5.0

What's Next?
  View summary of image vulnerabilities and recommendations → docker scout quickview redis:5.0
```

#### 3. 启动镜像
启动镜像，执行`docker run --name my-redis-container -d -p 6379:6379 redis:5.0`

```shell
dongmingyan@sc ⮀ ~ ⮀ docker run --name my-redis-container -d -p 6379:6379 redis:5.0
9c1c82caf881ee391792f42d964579d780b72d57725257ccd076d6174658aa6f
```
检查镜像,`docker ps -a`发现redis已经存在了
```shell
dongmingyan@sc ⮀ ~ ⮀ docker ps -a
CONTAINER ID   IMAGE       COMMAND                   CREATED         STATUS         PORTS                    NAMES
9c1c82caf881   redis:5.0   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:6379->6379/tcp   my-redis-container
```
此时已经可以正常连接redis服务了。

### 五、实操3 (compose多容器)
经过前面的练习，我们已经可以根据镜像运行单个容器了，但是在实际项目中，单独开启一个容器是不够的，我们通常需要开启多个服务。比如需要同时开启：redis、mysql、nginx、ruby等等。

compose控制的是一个容器组。

我们一个个去建立容器也是可以做到，但是太麻烦了。compose就是为了解决这个问题孕育而生的，通过它可以一次生成多个容器。

为了演示，我们还是先去拉取一个测试项目
#### 1. 拉取测试项目
`git clone git@github.com:docker/multi-container-app.git`

#### 2. 认识compose.yaml文件
这个文件说明了需要开启哪些容器以及它们的依赖关系。

这里会启动两个容器 todo-app和 todo-database
```yaml
services:
  # 服务1 
  todo-app:
    build:
      context: ./app #到当前项目的app目录下寻找dockefile构建镜像
    links:
      - todo-database # 表面依赖于 todo-database服务
    environment: # 启动时环境变量
      NODE_ENV: production
    ports:
      - 3000:3000

  # 服务2
  todo-database:
    image: mongo:6 # 使用mongo镜像
    #volumes: 
    #  - database:/data/db
    ports:
      - 27017:27017
```
#### 3. 启动compose
启动`docker compose up -d`

```shell
dongmingyan@sc ⮀ ~/docker-learn/multi-container-app ⮀ ⭠ main ⮀ docker compose up -d
[+] Building 43.2s (11/11) FINISHED                                                                  docker:desktop-linux
 => [todo-app internal] load build definition from Dockerfile                                                        0.0s
 => => transferring dockerfile: 1.10kB                                                                               0.0s
 => [todo-app internal] load .dockerignore                                                                           0.0s
 => => transferring context: 672B                                                                                    0.0s
 => [todo-app] resolve image config for docker.io/docker/dockerfile:1                                               15.5s
 => CACHED [todo-app] docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed04  0.0s
 => [todo-app internal] load metadata for docker.io/library/node:19.5.0-alpine                                      27.4s
 => [todo-app stage-0 1/4] FROM docker.io/library/node:19.5.0-alpine@sha256:4619ec6c9a43ab4edfa12cf96745319c3ca43af  0.0s
 => [todo-app internal] load build context                                                                           0.0s
 => => transferring context: 370B                                                                                    0.0s
 => CACHED [todo-app stage-0 2/4] WORKDIR /usr/src/app                                                               0.0s
 => CACHED [todo-app stage-0 3/4] RUN --mount=type=bind,source=package.json,target=package.json     --mount=type=bi  0.0s
 => CACHED [todo-app stage-0 4/4] COPY . .                                                                           0.0s
 => [todo-app] exporting to image                                                                                    0.0s
 => => exporting layers                                                                                              0.0s
 => => writing image sha256:736fb1920470d647a8e57a50dab09c1a5d6297a83b92bcd24b62a579d2337136                         0.0s
 => => naming to docker.io/library/multi-container-app-todo-app                                                      0.0s
[+] Running 3/3
 ✔ Network multi-container-app_default            Created                                                            0.1s
 ✔ Container multi-container-app-todo-database-1  Started                                                            0.7s
 ✔ Container multi-container-app-todo-app-1       Started
```

查看启动的镜像
```shell
dongmingyan@sc ⮀ ~/docker-learn/multi-container-app ⮀ ⭠ main ⮀ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                   CREATED              STATUS              PORTS                      NAMES
00b5638da19b   multi-container-app-todo-app   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp     multi-container-app-todo-app-1
b00c1d029ee5   mongo:6                        "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:27017->27017/tcp   multi-container-app-todo-database-1
```
PS: 注意这里生成的容器名是，项目名-compose中的服务名

此时，可以正常访问`http://localhost:3000`啦！

#### 4. 关闭compose
关闭compose只需要`docker compose down`即可

#### 5. 其它补充
在一个项目中我们其实不需要手动去创建Dockerfile文件和compose文件，可以执行`docker init`自动生成，稍做修改就可使用。

### 六、docker中的核心概念和文件
#### 1. 镜像
镜像就像一个模版一次做好后，就可以创建无数一个容器；可以认为它是打包环境的代码，一次完工，方便随处使用。
#### 2. 容器
容器就像是根据镜像这个模版生产出来的东西，它是运行的实体。我
们的服务就是启动容器，只不过它和宿主机的环境是隔离开的，相比于虚拟机，它占用的开销更小，启动、停止更快、更便捷。

### 七、docker常用命令汇总
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




