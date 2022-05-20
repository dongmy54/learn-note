require 'time'

#===================================================================================#
# 计算间隔天数
# 不到一天 算0天
interval_days = (DateTime.now - DateTime.parse('2018-8-6')).to_i

#===================================================================================#
# 时间转星期
# 星期1-6 星期天 0 
Time.now.wday
# => 0
DateTime.now.wday
# => 0

Time.now.strftime('%a')
# => "Sun"
DateTime.now.strftime('%a')
# => "Sun"


#===================================================================================#
# DateTime.parse
# 解析时间
# 1、必须是字符串
# 2、格式多样 很宽松
# PS：可以接收数据库中存的时间
DateTime.parse('2018/8/3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018-8-3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018.8.3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018-8-3 05:36:28')
# => #<DateTime: 2018-08-03T05:36:28+00:00 ((2458334j,20188s,0n),+0s,2299161j)>


#===================================================================================#
# strftime 转换成相应格式
# PS:注意这里Y m d 都是区分大写的
Time.now.strftime('%Y-%m-%d %H:%M:%S')  # 通常用法
# => "2018-05-11 10:52:35"
Time.now.strftime('%F')                 # %F 年月日的简写
# => "2018-05-11"
DateTime.parse('2018.5.3').strftime('%Y-%m-%d %H:%M:%S') # 搭配DatTime.parse
# => "2018-05-03 00:00:00"


#===================================================================================#
# 日期的加减 上月 下月 计算
DateTime.now << 1  # 指向自己 会退一个月
# => #<DateTime: 2018-04-11T10:58:46+08:00 ((2458220j,10726s,238806000n),+28800s,2299161j)>
DateTime.now >> 1  # 指向别人 前推一个月
# => #<DateTime: 2018-06-11T10:58:46+08:00 ((2458281j,10726s,239651000n),+28800s,2299161j)>
DateTime.now - 1   # 减 一天
# => #<DateTime: 2018-05-10T10:58:46+08:00 ((2458249j,10726s,240402000n),+28800s,2299161j)>
DateTime.now + 1   # 加 一天
# => #<DateTime: 2018-05-12T10:58:46+08:00 ((2458251j,10726s,241208000n),+28800s,2299161j)>


#===================================================================================#
# 日期的转换
end_at = '2018/6/18'
DateTime.parse("#{end_at}T23:59:59+08:00")   # 添加 时分秒 成时间戳
# => 2018-06-18T23:59:59+08:00
DateTime.parse("#{end_at}T23:59:59+08:00").to_time # 转时间
# => 2018-06-18 23:59:59 +0800
DateTime.parse("#{end_at}T23:59:59+08:00").to_time.utc # 转utc时间
# => 2018-06-18 15:59:59 UTC
DateTime.parse("#{end_at}T23:59:59+08:00").to_time.utc.localtime('+08:00') # 转本地时间 加时区
# => 2018-06-18 23:59:59 +0800


#===================================================================================#
#时间戳转时间
Time.at(1653041365)
# => 2022-05-20 18:09:25 +0800


#===================================================================================#
# 构造时间
t1 = Time.new(2018,3,18,5,45,6)    
# => 2018-03-18 05:45:06 +0800
t2 = Time.new(2018,3,18,5,45,6,'+09:00')  # 带时区
# => 2018-03-18 05:45:06 +0900
t1.year       # 挖掘时间 年 月 星期 日 天 时 秒
# => 2018
t2.month
# => 3
t1.wday      # 星期 1-6 周日 0 
# => 0
t2.day
# => 18
t2.hour
# => 5
t2.min
# => 45
t2.sec
# => 6