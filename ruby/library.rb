# uuid
# 产生通用唯一标识
require 'securerandom'

random_str = SecureRandom.uuid
# => "25987203-5423-4bdd-b7da-f0584ded80cb"


#===================================================================================#
# open-uri 像打开文件一样获取 html
require 'open-uri'
url      = "http://www.ruby-lang.org/"
filename = "cathedral.html"
File.open(filename, 'w') do |f|
  # 直接 open read
  text = open(url).read
  # 写入 文件
  f.write text
end
# url 内容写入到cathedral.html 中了


#===================================================================================#
# timeout module
require 'timeout'

begin
  # 如果超时没有完成，会报timeout错误
  Timeout::timeout(2) do 
    puts "未超时打印"
    sleep 3
    # 由于超时下面这句不会执行
    puts "超时打印,不会成功"
  end
rescue
  puts "rescue"
end
# 未超时打印
# rescue


#===================================================================================#
# DateTime.parse
# 解析时间
# 1、必须是字符串
# 2、格式多样 很宽松
# PS：可以接收数据库中存的时间
require 'time'

DateTime.parse('2018/8/3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018-8-3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018.8.3')
# => #<DateTime: 2018-08-03T00:00:00+00:00 ((2458334j,0s,0n),+0s,2299161j)>
DateTime.parse('2018-8-3 05:36:28')
# => #<DateTime: 2018-08-03T05:36:28+00:00 ((2458334j,20188s,0n),+0s,2299161j)>


# strftime 转换成相应格式
# PS:注意这里Y m d 都是区分大写的
Time.now.strftime('%Y-%m-%d %H:%M:%S')  # 通常用法
# => "2018-05-11 10:52:35"
Time.now.strftime('%F')                 # %F 年月日的简写
# => "2018-05-11"
DateTime.parse('2018.5.3').strftime('%Y-%m-%d %H:%M:%S') # 搭配DatTime.parse
# => "2018-05-03 00:00:00"


# 日期的加减 上月 下月 计算
DateTime.now << 1  # 指向自己 会退一个月
# => #<DateTime: 2018-04-11T10:58:46+08:00 ((2458220j,10726s,238806000n),+28800s,2299161j)>
DateTime.now >> 1  # 指向别人 前推一个月
# => #<DateTime: 2018-06-11T10:58:46+08:00 ((2458281j,10726s,239651000n),+28800s,2299161j)>
DateTime.now - 1   # 减 一天
# => #<DateTime: 2018-05-10T10:58:46+08:00 ((2458249j,10726s,240402000n),+28800s,2299161j)>
DateTime.now + 1   # 加 一天
# => #<DateTime: 2018-05-12T10:58:46+08:00 ((2458251j,10726s,241208000n),+28800s,2299161j)>

