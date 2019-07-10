# uuid
# 产生通用唯一标识
require 'securerandom'

random_str = SecureRandom.uuid
# => "25987203-5423-4bdd-b7da-f0584ded80cb"


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



