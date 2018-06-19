require 'time'

end_at = '2018/6/18'
DateTime.parse("#{end_at}T23:59:59+08:00")   # 添加 时分秒 成时间戳
# => 2018-06-18T23:59:59+08:00

DateTime.parse("#{end_at}T23:59:59+08:00").to_time # 转时间
# => 2018-06-18 23:59:59 +0800

puts DateTime.parse("#{end_at}T23:59:59+08:00").to_time.utc # 转utc时间
# => 2018-06-18 15:59:59 UTC