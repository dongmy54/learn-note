# 块参数 嵌套吧
fruits = %w(banana apple grape)
# 动态定义hu方法  接受块参数
Kernel.send :define_method, :hu do |&block|  
  fruits.each do |fruit|
    block.call(fruit)  # 这个块 也需要参数
  end
end

hu do |fruit|
  puts "I LOVE #{fruit}"
end


