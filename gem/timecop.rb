# 常用于测试中冻结时间
require 'timecop'

freeze_time = Timecop.freeze      # 返回冻结时间点

puts freeze_time == Time.now
# => true

Timecop.travel      # 取消冻结
puts freeze_time == Time.now
# => false

puts Time.now
# => 2018-11-28 20:00:03 +0800
Timecop.travel 1*60*60 # 让时间过去 一个小时
puts Time.now
# => 2018-11-28 21:00:03 +0800


