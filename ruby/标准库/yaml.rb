# ================== yaml 文件注意 =========================#
# 不可直接使用部分替换，yaml中只能完整替换
# 可用ruby的方式传入hash 进行替换
# & 定义yaml变量 * 使用变量 << 注入
# 读取出来键都是字符串

```ruby
# /Users/dongmingyan/test.yml

hu: &hu 我是单行变量
bar: *hu # 直接使用hu

default_hash: &default_hash
  first: 第一行
  second: 第二行
  three: 第三行

hash:
  <<: *default_hash  # 使用变量hash
  first: 我要替换     # 覆盖前面的值

ruby_inject_value: 'I like %{thing}'  # 必须引号
```

require 'yaml'

# 加载文件
file = YAML.load_file('/Users/dongmingyan/test.yml')
# {"hu"=>"我是单行变量",
# "bar"=>"我是单行变量",
# "default_hash"=>{"first"=>"第一行", "second"=>"第二行", "three"=>"第三行"},
# "hash"=>{"first"=>"我要替换", "second"=>"第二行", "three"=>"第三行"},
# "ruby_inject_value"=>"I like %{thing}"}

file['ruby_inject_value'] %{thing: 'sing'} # 注入hash
# => "I like sing"

# 解析yaml
YAML.load("---\n:a: b\n")
# => {:a => 'b'}

# 转储
YAML.dump({:a => 'b'})
# => "---\n:a: b\n"



