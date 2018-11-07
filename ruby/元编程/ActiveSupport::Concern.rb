# ActiveSupport::Concern
# 作用：简化包含并扩展技巧
# 解决问题：
# 1、每次使用包含并扩展技巧都需要，重新定义included 方法的繁琐
# 2、链式包含（多层包含并扩展）是失效的问题
# 实现原理：
# 1、复写append_features方法
# 2、用extended 去管理依赖

require 'active_support'

module MyConcern
  extend ActiveSupport::Concern     # 关键地方

  def a_instance_method
    puts "I'm a instance_method"
  end

  module ClassMethods              # 注意这里是复数
    def class_method
      puts "I'm class_method"
    end
  end
end

class A
  include MyConcern
end


A.class_method
#I'm class_method

A.new.a_instance_method
#I'm a instance_method