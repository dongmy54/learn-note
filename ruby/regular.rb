# scan 对字符串不做处理，但可以校验字符串
str = 'adhwadadsawea'
count = 0
str.scan(/a/) do
  count += 1
end
puts "str中包含#{count}个字符串"
# str中包含5个字符串

# gsub 方法对字符串做置换
str = 'asadsa asd asda sa'
str.gsub!(/\s+/, '')
# \s+ 匹配空格 换行 等
puts "处理后字符串为#{str}"
# 处理后字符串为asadsaasdasdasa