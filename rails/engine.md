#### 引擎
> 定义：
> 1、可以认为是rails化的gem；
> 2、可用于扩展rails应用,类似于gem，但更偏向于rails，更像一个缩小版的rails项目


#### 如何创建？
> 命令 `rails _4.2.7_ plugin new yst --mountable` 创建骨架
> 说明：
> 1. 最好指定rails版本（确定用于什么版本的应用, 不要默认生成骨架后再去改rails版本,有版本问题）
> 2. `mountable`主要目的是让生成一个隔离（与住项目）的引擎，不然不会隔离（路由、控制器等）
> 3. 骨架创建后，要修改引擎根目录下的 `xx.gemspec`文件
> * a. 去掉其中的 TODO
> * b. 引擎依赖的gem要指明
> 4. 然后`bundle`会生成引擎的 Gemfile.lock
> 5. 引擎相当于一个小的rails应用，可以像在rails中一样去创建（MVC)
> 6. 切到引擎`test/dummy`下可以`rails s/rails c`让引擎跑起来调试等


#### 应用如何挂载引擎
> step1: Gemfile中 添加 `gem 'yst', path: '/Users/dongmingyan/yst'` 然后bundle
> step2: config/routes中挂载 `mount Yst::Engine, at: "/yst"`
> 说明：
> 1. 安装后路由区分 
> * `main_app.articles_path` 应用路由
> * `yst.articles_path` 引擎路由
> 2. 引擎迁移文件拷贝
> 应用目录下 `rake yst:install:migrations`


#### 应用初始化引擎文件配置
> 可以利用`cattr_accessor`/`mattr_accessor`来实现

```ruby
# 引擎 lib/yst.rb
class YstInterface
  cattr_accessor :config
end
```
```ruby
# 应用 config/initializers/yst_interface.rb
YstInterface.config = {
  hu: 'bar'
}
```


#### 如何自动向应用中创建（写入）配置示例文件、迁移文件等
> 在引擎中创建生成器,然后可在应用中执行引擎生成器,比如：`rails g yst`







