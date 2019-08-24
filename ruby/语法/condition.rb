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

# 匹配多个
name = 'wangwu'

case name
when 'lisi'
  puts 'lisi'
when 'zhangsan','wangwu' # 匹配多个
  puts 'zhangsan or wangwu'
end


# 匹配块简写
class Fixnum
  # 比5大
  def is_greated_than_five?
    self > 5
  end

  # 普通数字
  def common_num?
    self != 5
  end
end

case 6
when proc(&:is_greated_than_five?)
  puts 'greated 5'
when proc(&:common_num?)
  puts 'common num'
end
# greated 5

