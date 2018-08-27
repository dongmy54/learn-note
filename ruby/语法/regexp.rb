# ^ 以 开头 $ 以 结尾
#（abc) 圆括号 全匹配 abc 一连
# [abc] 方括号 选择性匹配 a b c 中一个
# [^ahu] 非ahu
# a|b 竖线  a 或 b 中一个 通常这样用 （abc|huj)
# \d 数字
# \w 匹配 字母 数字 下划线（_)
# \s 任何空白字符
# \D 非数字
# \W 非字母、数字、下划线
# \S 非空白字符
# . 表示 任意一个字符
# ? 表示 0个 或 1个
# * 表示 0个 或 1个以上
# + 表示 1个 或 1个以上
# \d{3}     三个数字
# \d{2,10}  两到10个数字
# \d{4,}    四个以上数字
# \1        将捕获到内容顺延一位,如: [aeio](.)\1
# [\u4e00-\u9fa5] 表示汉字       等价于    /\p{Han}+/u


#===================================================================================#
# ()分组 捕获
# 默认 $1 第一个捕获 $2 类推
str   = 'kabckbdkdefdak'
regex = /(abc).[ab].(\w{3})/
str =~ regex
puts $1
# abc
puts $2
# kde


#===================================================================================#
# 具名 捕获
# 用法 (?<name> 匹配正则)
str   = 'adabkdsdfgk'
regex = /(?<first>(ab).).*(?<second>(df).)/
puts regex.match(str)[:first]
# abk
puts regex.match(str)[:second]
# dfg


#===================================================================================#
# 懒惰匹配
# 1、默认情况下 为贪婪匹配(尽可能多的去匹配)
# 2、截止前加 ？ 懒惰匹配(匹配最短长度)
str    = 'aCdjkdfC'
regex1 = /[ab].*C/
regex2 = /[ab].*?C/
puts str[regex1,0]
# aCdjkdfC
puts str[regex2,0]
# aC


#===================================================================================#
# 匹配以 小写字母开头
'sd' =~ /\A[[:lower:]]/
# => 0


#===================================================================================#
# 匹配 邮箱 一种写法
'qw@ji.com' =~ /\A[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+\z/
# => 0


#===================================================================================#
# 邮箱 正则
'hu@qq.com' =~  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
# => 0
'@sd@ku.com' =~  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
# => nil


#===================================================================================#
# match 判断匹配否
# 不能匹配时返回 nil
/^(http:\/\/|https:\/\/)(www\.)?[\w\-]*(\.)?baidu\.com/.match('http://hubaidu.com')
# => #<MatchData "http://hubaidu.com" 1:"http://" 2:nil 3:nil>


#===================================================================================#
# 1、http:// 或 https:// 开头
# 2、baidu.com 结尾
# 3、http:// 或 https:// 后接 0个 或 1个 www.
# 4. 0个 或 1个 www.后面接 0个或多个（字母/数字/下划线）
# 5、0个或多个（字母/数字/下划线） 后接 0个 或 1个 .
/^(http:\/\/|https:\/\/)(www\.)?[\w\-]*(\.)?baidu\.com/


#===================================================================================#
# 匹配方法名
# 1、不以=/？ 结尾
# 2、以大写字母 或 小写字母开头
# 3、中间可接 中横线（-） 下划线（_) 字母 数字等
/^[a-zA-Z][-\w]*[^=?]$/


#===================================================================================#
# match 只匹配首个
# 无块 => 对象
# 有块 => 对象入块
str   = 'ddjikkqodkddjkklod'
regex = /dd(.*?)kk(.o)/

match_object = str.match(regex)
puts match_object[0]           # 0 匹配
# ddjikkqo 
puts match_object[1]           # 1 第一捕获
# ji
puts match_object[2]           # 2 第二捕获
# qo

str.match(regex) do |m|    # 对象入块
  puts m
  # puts m[0]/[1]/[2]
end
# ddjikkqo


#===================================================================================#
# scan 
# 无块 => 多维数组（PS:首层:匹配; 下层:捕获)
# 有块 => 元素入块
str   = 'ddjikkqodkddjkklod'
regex = /dd(.*?)kk(.o)/

str.scan(regex)
# => [
# =>     [0] [
# =>         [0] "ji",
# =>         [1] "qo"
# =>     ],
# =>     [1] [
# =>         [0] "j",
# =>         [1] "lo"
# =>     ]
# => ]

str.scan(regex) do |m|
  puts m.inspect     # 元素入块
end
# ["ji", "qo"]
# ["j", "lo"]


#===================================================================================#
# gsub 方法对字符串做置换
str = 'asadsa asd asda sa'
str.gsub!(/\s+/, '')
# \s+ 匹配空格 换行 等
puts "处理后字符串为#{str}"
# 处理后字符串为asadsaasdasdasa