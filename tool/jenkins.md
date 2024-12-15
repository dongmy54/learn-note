## jenkins
```shell
docker pull jenkins/jenkins:lts # 拉取官方版本
mkdir -p dmy_project/jenkins
sudo chown -R 1000:1000 /root/dmy_project/jenkins  # 添加权限
# 这里把宿主机的容器操作 给予docker容器内部处理
docker run -p 8080:8080  \
  -v /root/dmy_project/jenkins:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  -d jenkins/jenkins:lts

# 打开8080的防火墙
https://xxxx:8080 打开查看

# 在/root/dmy_project/jenkins 目录下打印出密钥填写
cat secrets/initialAdminPassword


# 安装推荐的软件
# 创建第一个管理员账号
```

### 问题1
在配置完自己github 公钥和jenkins全局凭证后
还是提示这个
```
无法连接仓库：Command "git ls-remote -h -- git@github.com:dongmy54/jenkins_project.git HEAD" returned status code 128:
stdout:
stderr: No ED25519 host key is known for github.com and you have requested strict checking.
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```
到jenkins所在的容器内部执行下`ssh -T git@github.com` 然后Yes写入信任的主机即可

### 自由风格执行shell是在哪里执行的？
1. 在docker运行的jenkins容器内部执行的
2. 可以使用一些环境变量比如：
```shell
pwd
echo $GIT_URL # 这里使用了环境变量
```

### 如何通过ssh去其它服务器上执行操作
通过安装ssh插件`Publish over SSH`
然后到manage jenkins > system > Publish over SSH 中去配置服务器信息

然后，新建一个item 中自由风格 > Build Steps > Exec command 则会在远程主机上执行命令



