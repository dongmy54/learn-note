### 准备工作
1. 去ubuntu官网下载iso镜像文件（最好选择长期维护版本LTS）
2. 制作启动盘
  在mac上下载etcher工具，https://etcher.balena.io/
  安装好工具后启动打开，选择下载好的iso文件，选择U盘，点击flash即可制作启动盘
  PS：如果是在windows系统下制作，下载rufus软件去做烧录

### 安装
1. 启动盘制作好后，在主机USB接口插入U盘，电脑开机后，连续按esc(联想电脑)进入bios界面
2. 在bios界面后，切换到boot选项，选择U盘启动(它有一个顺序，此时把usb启动放到第一位)，保存退出
3. 进入ubuntu安装界面，然后按照提示进行安装即可
4. 特殊情况： 一步步执行完后，它会提示你重新启动，此时把U盘拔掉，然后重新运行
5. 最后看到登录提示，输入用户名和密码即可登录

PS：
- ubuntu官网教程提示，可以参考：https://ubuntu.com/tutorials/install-ubuntu-server#3-boot-from-install-media
- 安装期间接上网线，它自动就有网；（后续改成静态ip，需要修改/etc/netplan/xxx.yaml文件）









