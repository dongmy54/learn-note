## jenkins
```shell
mkdir -p dmy_project/jenkins
sudo chown -R 1000:1000 /root/dmy_project/jenkins  # 添加权限
docker run -p 8080:8080  -v /root/dmy_project/jenkins:/var/jenkins_home jenkins:2.60.3

# 打开8080的防火墙
https://xxxx:8080 打开查看
```