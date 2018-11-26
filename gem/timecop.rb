# 常用于测试中冻结时间
require 'timecop'

freeze_time = Timecop.freeze      # 返回冻结时间点

puts freeze_time == Time.now
# => true

Timecop.travel      # 取消冻结
puts freeze_time == Time.now
# => false


