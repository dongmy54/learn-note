## centos安装
```shell
# 检查更新
sudo yum check-update

# 安装管理工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加镜像源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装docker
sudo yum install docker-ce docker-ce-cli containerd.io
```

