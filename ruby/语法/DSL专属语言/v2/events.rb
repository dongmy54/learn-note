setup do   # setup 设置变量
  puts "----set stand order number"
  @stand_order_number = 1000
end

setup do
  puts "-----set stand refund number"
  @stand_refund_number = 100 # 要让这里的实例变量 在event 中共享
end

event 'Orders are too small' do
  @stand_order_number > 900 # 这里数据应该从数据库取，这里测试随意填了个  
end

event 'Too many refunds' do
  @stand_refund_number < 101
end
