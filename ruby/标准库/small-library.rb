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



