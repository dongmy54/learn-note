# 共享作用域（块内）
# 核心：
# 1、先将块/变量 存在数组中
# 2、然后调用
lambda { 
setups = []
events = []

Kernel.send :define_method, :setup do |&block|
  setups << block
end

Kernel.send :define_method, :event do |desc,&block|
  events << {:desc => desc, :block => block}
end

Kernel.send :define_method, :each_event do |&block|
  events.each do |event|
    block.call(event)  # 取出每个event 到 块中校验
  end
end

Kernel.send :define_method, :each_setup do |&block|
  setups.each do |setup| 
    setup.call         # 取出每个setup 到 块中定义实例变量
  end
end
}.call

load 'events.rb'    

each_event do |event|
  # 每个事件运行前，都会定义一遍实例变量（其实有点多余）
  each_setup do |setup|
    setup.call
  end
  puts "----#{event[:desc]}" if event[:block].call
end
# => ----set stand order number
# => -----set stand refund number
# => ----Orders are too small
# => ----set stand order number
# => -----set stand refund number
# => ----Too many refunds
