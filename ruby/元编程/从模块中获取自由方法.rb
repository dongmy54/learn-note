#===================================================================================#
# 方法对象 中的 自由方法
module B
  def module_method
    puts "module method"
  end
end

# 获取自由方法（从模块中独立出的自由方法 可用于任何对象，而从类中独立出的 只能用于其子类）
method_object = B.instance_method(:module_method)
puts method_object.class
# => UnboundMethod 自由方法

String.send :define_method, :hu, method_object
"sdas".hu
# => module method

