# 函数限制次数 自我调用
def m(x,limit = 6)
  raise ArgumentError,'调用次数太多' if limit == 1
  
  return puts x*2 if x % 3 == 2
  m(rand(1000),limit -1)    # 自我调用 次数 -1
end

m(258)
# => 604


#===================================================================================#
# 块参数 嵌套吧
fruits = %w(banana apple grape)

# 动态定义hu方法  接受块参数
Kernel.send :define_method, :hu do |&block|  
  fruits.each do |fruit|
    block.call(fruit)  # 这个块 也需要参数
  end
end

# 内核方法可以直接调用
hu do |fruit|
  puts "I LOVE #{fruit}"
end
# => I LOVE banana
# => I LOVE apple
# => I LOVE grape


