### gem 命令汇集
#### 常识
* 1、require 一个gem,相当于把一个gem lib/gem_name.rb文件加载进来 

```
gem help                         帮助

gem install rake                 安装rake 稳定版本
gem install rake -N              安装时 不安装文档
gem install rake -v 12.3.1       指定安装版本

gem uninstall rake               卸载gem
gem uninstall rake -v 12.3.1     卸载gem指定版本

gem update rake                  更新到最新版
gem update rake -N               更新时 不安装文档

gem list                         本地所有gem
gem list rails                   列出名字中包含rails的gem

rake build                       gem 打包（在gem的当前目录下）
rake install                     gem 打包 + install（本地）

```