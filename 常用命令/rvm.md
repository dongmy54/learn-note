### rvm命令汇总
* rvm 是一种常用的ruby版本管理工具
* 不同的ruby版本下，gem相互独立

```
ruby -v                         # 当前ruby 版本
rvm -v                          # rvm 版本
rvm list                        # 列出当前环境下，所有安装的ruby版本
rvm 2.3.3                       # 切换到ruby 2.3.3版本
rvm install 2.5.1               # 安装ruby 2.5.1版本
rvm reinstall 2.5.0             # 重装ruby 2.5.0(会先卸载ruby和其下所有gem,再重装ruby)
rvm remove 2.3.3                # 卸载ruby 2.3.3版本，包括其下的gem
rvm --default 2.5.1             # 默认使用ruby 2.5.1版本

rvm get stable  # 获取当前稳定rvm版本（有时不能成功安装某ruby版本,需升级rvm)
```



