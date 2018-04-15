# 扁平作用域：
# cal_num stand_order_number stand_refund 在块中都可用
def cal_num(int_num)
  # 随便怎么算
  int_num + 5
end

stand_order_number = 1000
stand_refund_number = 100

event 'Orders are too small' do # event 两个参数 一个desc 一个块（不带参）
  stand_order_number > cal_num(900) # 这里数据应该从数据库取，这里测试随意填了个  
end

event 'Too many refunds' do
  stand_refund_number < cal_num(100)
end