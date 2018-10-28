# 说明：
# 1、通常用include 引入实例方法
# 2、通过回调，在include的同时 extend 模块,引入类方法
module ClassMethodModule     # 类方法 模块
  def hu                     # extend 获得类方法
    puts 'hu'
  end
end

module Common  
  def self.included base
    # 这里是 included 回调
    # 注意回调这里：self 是 Common
    # 用 base 去 extend
    base.extend ClassMethodModule
  end

  def bar      # include 后获得实例方法
    puts 'bar'
  end
end

class A
  include Common
end

A.hu          #  'hu'
A.new.bar     #  'bar'