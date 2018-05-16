# for循环
# 1、第一个_表示循环中不需要用到 值
# 2、一般情况下是 i
for _ in 1..5
  puts 'hello'
end
# => hello
#    hello
#    hello
#    hello
#    hello


#===================================================================================#
# loop 永久循环
i = 0
loop do
  puts i
  i += 1
  break if i == 5
end

# 0
# 1
# 2
# 3
# 4