### rvm命令汇总
* rvm 是一种常用的ruby版本管理工具
* 不同的ruby版本下，gem相互独立

```
ruby -v                         # 当前ruby 版本
rvm 2.3.3                       # 切换到ruby 2.3.3版本
rvm install 2.5.1               # 安装ruby 2.5.1版本
rvm remove 2.3.3                # 卸载ruby 2.3.3版本，包括其下的gem
rvm --default 2.5.1             # 默认使用ruby 2.5.1版本
```
#### 两个重要目录
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
```
# gem的一些设置
~/.gemrc

:sources:
- https://ruby.taobao.org/
:update_sources: true
:verbose: true
gem: --no-document --no-ri 
```