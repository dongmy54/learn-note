### gem 命令汇集
#### 常识
* 1、require 一个gem,相当于把一个gem lib/gem_name.rb文件加载进来 
* 2、在脚本中，当存在多个gemb版本时，默认使用最高版本


```
gem env                          当前gem环境信息     

gem -v                           gem工具版本
gem update --system              gem工具更新

gem help                         帮助

gem install rake                 安装rake 稳定版本
gem install rake -N              安装时 不安装文档
gem install rake -v 12.3.1       指定安装版本
gem install path/xx.gem          根据路径安装gem（先把gem下载下来）

gem uninstall rake               卸载gem
gem uninstall rake -v 12.3.1     卸载gem指定版本

gem update rake                  更新到最新版
gem update rake -N               更新时 不安装文档

gem list                         本地所有gem
gem list rails                   列出名字中包含rails的gem

rake build                       gem 打包（在gem的当前目录下）
rake install                     gem 打包 + install（本地）

gem unpack rake -v 12.3.1        将gem解压到本地当前目录

gem search gemname               搜索gem,名字不用写全

# 更换国内rubygems镜像
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l                   当前gem源
```
#### 脚本中指定gem 版本
```
gem 'rake','=12.2.1'
require 'rake'  # 这样会加载12.2.1

Rake::VERSION
```

#### 两个重要目录
`subl ~/.rvm/gemsets/global.gems`
```
# rvm 新装ruby 版本时，自动安装文件中的gem
~/.rvm/gemsets/global.gems

gem-wrappers
rubygems-bundler 
rake
rvm
rails       
rubocop         
cocoapods
```
`subl ~/.gemrc`
```
# gem设置（源、文档是否创建）
~/.gemrc

:sources:
- https://ruby.taobao.org/
:update_sources: true
:verbose: true
gem: --no-document --no-ri 
```