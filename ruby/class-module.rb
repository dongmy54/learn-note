
# ARGV 是参数值的意思，取值从0开始
# ruby test.rb 0 1    命令行传入参数 0 1
puts ARGV[0]    # 0
puts ARGV[1]    # 1


# next 与 break
(1..10).each do |i|
  next if  i == 5
  # next 跳过本次循环，进入下一次循环
  break if i == 8
  # break 直接终止整个循环
  puts i
end
# 输入1 2 3 4 6 7


# ruby test.rb >> log.text
# >> 符号会将 执行结果输出内容写到某文件中
puts 'first'
puts 'second'
# 如果log.text 文件不存在，则新建
# log.text 中会有 first 和 second


# 一个类方法 调用另一个类方法
class A 
  
  def self.test
    ret = test1('sd')
    # 这里等价于 self.test1('sd')
    # 一个类方法可以直接调用另外一个类方法
    puts ret
  end

  def self.test1(arg)
    "参数是：#{arg}"
  end

end
A.test
# 参数是：sd