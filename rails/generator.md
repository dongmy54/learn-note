#### 生成器
> 用于自定义类似 `rails g helper product`的生成器
> PS： 查看某个生成器用法`rails g g_test --help`

##### 方法一：手动创建
> 1. 手动创建 `lib/generators`目录
> 2. 然后在此目录下创建生成器文件

```ruby
# lib/generators/g_test_generator.rb
class GTestGenerator < Rails::Generators::Base
  
  desc "这是一个我测试生成器"
  def create_g_test
    # 文件路径, 写入文件内容
    create_file "config/initializers/g_test.rb", 
    <<-CONTENT
      a = 'serd'
      '这是第二行内容'
      '这是第三行内容'
      'hhhh'
    CONTENT
  end

  # rails g g_test 执行
end
```


##### 方法二：生成器创建
> 说明： 这种方法单独出了生成器模版、用法描述等，比较实用
> 命令行执行 `rails g generator g_test1`
```
create  lib/generators/g_test1
create  lib/generators/g_test1/g_test1_generator.rb
create  lib/generators/g_test1/USAGE
create  lib/generators/g_test1/templates
invoke  test_unit
create    test/lib/generators/g_test1_generator_test.rb
```
```ruby
# lib/generators/g_test1/g_test1_generator.rb
class GTest1Generator < Rails::Generators::Base 
                       # PS：如果生成器使用时不用指定文件名（文件名写死）要继承于 Rails::Generators::Base 
                       # 默认的 Rails::Generators::NamedBase 需要指定文件名

  # 引入templates下模版 用于copy
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    # 源文件，生成文件
    copy_file 'yst_interface.rb', 'config/initializers/yst_interface.rb'
  end

  # rails g g_test1
end
```

```ruby
# lib/generators/g_test1/templates/yst_interface.rb

# 这是模版文件
YstInterface.config ={
  hu: 'hu',
  bar: 'Bar'
}
```









