# 扩展模块 虚拟属性成另外一个模块类方法
module A
  attr_accessor :name
end

module B
  extend A
end

B.name = 'sd'