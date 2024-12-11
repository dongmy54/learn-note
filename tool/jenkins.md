## jenkins
```shell
docker pull jenkins/jenkins:lts # 拉取官方版本
mkdir -p dmy_project/jenkins
sudo chown -R 1000:1000 /root/dmy_project/jenkins  # 添加权限
docker run -p 8080:8080  -v /root/dmy_project/jenkins:/var/jenkins_home --name jenkins -d jenkins/jenkins:lts

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

