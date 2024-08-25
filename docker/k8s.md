## k8s
[官网地址](https://kubernetes.io/zh-cn/)

### 什么是K8s？
1. K8s是Kubernetes的简称
2. 用途：对容器化应用实现自动化部署、管理、扩展
3. 它是用go语言编写，由google开发的开源工具

### 如何在自己的mac上跑一个k8s demo?
#### 1. 准备工作
一、**安装docker**
假设你之前已经安装好了

二、**安装Kubectl**
它是k8s的命令行工具，mac上通过`brew install kubectl`安装
PS: 直接执行上面的命令brew会自动更新非常慢，可以尝试执行`export HOMEBREW_NO_AUTO_UPDATE=1;brew install kubectl`

通过`kubectl version --client`检查是否安装成功。

三、**安装Minikube**
它是一个本地运行k8s集群的工具，通常用于本地学习和测试。

在mac上也可以通过brew安装`brew install minikube`
其它安装方式参考：[此链接](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Fx86-64%2Fstable%2Fhomebrew)

通过`minikube version`判断是否安装成功。

#### 2. 准备k8s demo项目
我们创建一个最简单的node.js应用




### K8s有哪些关键概念？



### 如何用k8s部署镜像？