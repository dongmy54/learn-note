#### 用途
> model关联关系图形绘制
> [配置选项](https://voormedia.github.io/rails-erd/customise.html)
> [图形解释](https://voormedia.github.io/rails-erd/gallery.html)

##### 准备
>1. `brew brew install graphviz` mac 本地
>2. 配置默认文件

```yaml
# ~/.erdconfig 全局性
attributes: false
disconnected: true
filename: erd
filetype: pdf
indirect: true
inheritance: true
markup: true
notation: simple
orientation: horizontal
polymorphism: true
sort: true
warn: true
title: true
exclude: null
only: null
only_recursion_depth: null
prepend_primary: false
cluster: false
splines: spline
```

##### 用法
> ps: 生成的文档在项目下
```
Gemfile

gem 'rails-erd', group: :development
```
然后 `bundle exec erd` 生成pdf文件

`rake db:migrate`会自动生成文档

