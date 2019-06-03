######################## case #####################
arg = 12

# 常规用法（一个数字范围）
case arg
  when 1..10
    puts '1..10'
  when 11..30
    puts '11..30'
  else
    puts 'other'
end


# 错误用法 不能 单独比较大小 ❌
case arg
  when < 10
    puts '< 10'
  when > 30
    puts '> 30'
  else
    puts 'other'
end

# 正确如下
case 
  when arg < 10
    puts '< 10'
  when arg > 30
    puts '> 30'
  else
    puts 'other'
end

# 可用块
case 2
when ->(x) { x < 0}
  puts 1
when ->(x) { x < 6}
  puts 2
when ->(x) { x > 10 }
  puts 3
end

# => 2

