#===================================================================================#
# 多行字符串
# %{} 和 <<-EOS 写法(-小横线保证不对齐时，正常编译)
# 都可插值
# EOS 可以当作参数用 比如：<<-EOS.split('\n')
name = 'dmy'
str1 = %{
  #{name} hello 
  ni hao ma
  ha ha!
}

str2 = <<-EOS
  #{name} hello 
  ni hao ma
  ha ha! 
EOS

puts str1  # 注意由于 上面%{}写法换行写 所以会有空行
#
#  dmy hello
#  ni hao ma
#  ha ha!
puts str2
#  dmy hello
#  ni hao ma
#  ha ha!
puts str1.gsub(/\s+/,' ')       # 去除换行
# dmy hello ni hao ma ha ha!


#===================================================================================#
# index 定位字符串
# 可接 正则/字符
str = 'asdahcfldddf'
puts str.index('ddd')
# 8
puts str.index(/[abc]f/)
# 5


#===================================================================================#
# insert 在指定索引处插入
str = 'sadfdmydsa'
str.insert(str.index('dmy'),'X')
puts str
# sadfXdmydsa


#===================================================================================#
# start_with? 以什么开头
"dsaf sdaf".start_with? 'dsa'
# => true


#===================================================================================#
# end_with? 以什么结尾
str = 'safdasdf'
puts str.end_with?('sdf')
# true


#===================================================================================#
# include？是否包含
str = 'safdmysaf'
puts str.include?('dmy')
# true


#===================================================================================#
str = 'abc ef'
str.each_char {|c| puts "char is '#{c}'"}
# char is 'a'
# char is 'b'
# char is 'c'
# char is ' '
# char is 'e'
# char is 'f'


#===================================================================================#
# each_line 每行
str = %{first line
second line
end ...
}

str.each_line {|line| puts line}
# first line
# second line
# end ...


#===================================================================================#
# split 劈开字符串 数组
# 第二参数 数组长度
str = "ab cd ef k cddo"
puts str.split(' ').inspect
# ["ab", "cd", "ef", "k", "cddo"]
puts str.split(' ',2).inspect
# ["ab", "cd ef k cddo"]


#===================================================================================#
# []多种用法
str = "absadffgh"
puts str[2]         # str[index]
# s
puts str[0,3]       # str[index,length]
# abs
puts str[1..3]      # str[range]
# bsa
puts str[/b(sa)/,0] # str[regex,0] 匹配内容
# bsa
puts str[/b(sa)/,1] # str[regex,1] 捕获内容
# sa
puts str['adf']     # str[str] 字符串中 字符串内容 替换时非常有用
# adf


#===================================================================================#
# delete()
# 删除字符串中指定字符
str = "asdsdadfasdfa"
str.delete('a')
# => "sdsddfsdf"


#===================================================================================#
# 替换字符串中值 
desc = "params1 您好！明天来params2吧"
desc['params1'] = 'dmy'
desc['params2'] = '西乡'
puts desc
# dmy 您好！明天来西乡吧


#===================================================================================#
# concat 字符串、数组都可用
str1 = "abc"
str2 = "def"
puts str1.concat(str2)
# abcdef
arr1 = (1..3).to_a
arr2 = (4..6).to_a
puts arr1.concat(arr2)
# 1 2 3 4 5 6


#===================================================================================#
# upto 由当前 字符串 推导出后续字符
# 字母 a..z 数组 0..9
puts 'a1'.upto('b1').to_a.inspect
# ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "b0", "b1"]
puts 'aa'.upto('aq').to_a.inspect
# ["aa", "ab", "ac", "ad", "ae", "af", "ag", "ah", "ai", "aj", "ak", "al", "am", "an", "ao", "ap", "aq"]


#===================================================================================#
# chomp
# 删除字符串末尾的东东
# 1、当不传参数时（删除换行 \r \n \r\n)
# 2、传参数时 从末尾删除匹配的 参数
a = "dmy\r\n"
a.chomp        # => "dmy"
b = "dmy\n"
b.chomp        # => "dmy"
c = 'dmy'      
c.chomp('my')  # => "d"
d = 'dmy'
d.chomp        # => "dmy"


#===================================================================================#
# chop（删除字符串末尾字符）
# 和 chomp 区别在于 
# 1、 它无论如何都要删掉一个(才甘心)
# 2、 它不需要参数
a = "string\r\n"
a.chop            # => "string"
b = "string\n"
b.chop            # => "string"
c = "string"
c.chop            # => "strin"
d = 's'
d.chop            # => ""


#===================================================================================#
# 删除字符串 前后的空行
a = " dsa sdd ddsa  "
a.strip          # => "dsa sdd ddsa"


#===================================================================================#
# match
# 1、拿到匹配的 结果值
# 2、具名捕获 可 符号 可 字符串
# 3、可接块（匹配到的内容）
# PS: 它只匹配一次
str     = 'abkddfhps'
regex   = /(?<first>[abc]k).*(?<second>[juh]p)/
results = str.match(regex)
# => #<MatchData "bkddfhp" first:"bk" second:"hp">
puts results[0]
# bkddfhp
puts results[:first]
# bk
puts results[:second]
# hp
str.match(regex) {|m| puts m }
# bkddfhp


#===================================================================================#
# sub 只替换首次匹配
# 有！方法
str   = 'hdmykahddmyib'
regex = /(dmy).[ab]/
puts str.sub(regex,'H')
# hHhddmyib


#===================================================================================#
# gsub 替换所有匹配
# 有！方法
str   = 'hdmykahddmyib'
regex = /(dmy).[ab]/
puts str.gsub(regex,'H')
# hHhdH
