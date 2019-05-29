require 'yaml'

# 解析yaml
YAML.load("---\n:a: b\n")
# => {:a => 'b'}

# 转储
YAML.dump({:a => 'b'})
# => "---\n:a: b\n"

# 加载文件
YAML.load_file('/Users/dmy/test.yml')
# {
#   "dmy" => {
#     "name" => "dmy",
#     "age" => 26
#     },
#   "zhangsan" => {
#       "name" => "zs",
#       "age" => 23
#   }
# }
