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

# 启动docker服务
sudo systemctl start docker
sudo systemctl enable docker
```

### 配置镜像
`/etc/docker/daemon.json`

PS: 配置镜像地址时，注意要同时配置上"insecure-registries"镜像注册地址，不然它还是会去docker hub查的哦！

`docker.1ms.run`
```
{
    "registry-mirrors": [
        "https://docker.1ms.run"
    ],
    "insecure-registries": [
      "docker.1ms.run"
    ]
}
```

