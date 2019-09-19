require 'active_support'
require 'active_support/core_ext'


#=========================================== 查看 ==========================================#
# instance_values 以实例变量名 - 值 hash方式输出
class A
  def initialize(x,y)
    @x, @y = x,y
  end
end

a = A.new(1,2)
a.instance_values # => {"x"=>1, "y"=>2}


# Module
# parent          父模块 
# parents_name    父模块(字符串)
# parents         所有父模块(数组)
module M
  module N
    module A
    end
  end
end

M::N::A.parent           # => M::N
M::N::A.parent_name      # => "M::N"
M::N::A.parents          # => [M::N, M, Object]


# class
# subclasses     子类
# descendants    后裔类
class C;end
class B < C;end
class A < B;end
class D < C;end

C.subclasses            # => [B, D]
C.descendants           # => [B, A, D]



#=========================================== 字符串 ==========================================#
# 数组中 不包含
%w(sda sdaf sdaf).exclude?('qw') 
# => true

# 字符串中 不包含
"sdaf".exclude?('sd')        # => false

# 字符串转常量
'Module'.constantize         # Module 常量

# 驼峰命令
'active_record'.camelize
# => "ActiveRecord"

# 驼峰转下划线
'PublicBidNotice'.underscore
# => "public_bid_notice"

# first 前面x个字符串
"hello world".first(3)       # => "hel"

# last 后多x个字符串
'hello world'.last(3)        # => "rld"

# from index--末尾
'hello world'.from(3)        # => "lo world"

# 首字母大写
"alice in wonderland".titleize  # => "Alice In Wonderland"

# truncate 截取词
str = '那是一个青春少女拥有爱时的喜悦，对对方的肯定，和父母的交心，
对未来美好的展望，以及担心父母反对的羞涩。你或许忘了吧，
你有过那样开心、可爱、羞涩、坚定而又矛盾的复杂心情。'.gsub(/\s+/, '')

str.truncate(15)               # => "那是一个青春少女拥有爱时..."



#=========================================== 时间 ==========================================#
# PS: 1、我们使用 Time.new/Time.now时,rails 会自动进行时区转换
# PS: 2、服务器：可能使用的时间就是utc时间，这时utc/local一致
# PS: 3、2019-01-28 11:38:34 +0800 最后部分代表时区

# 当前时间(当前时区)
Time.current

# utc(时间)
Time.now.utc                       # => 2019-01-28 03:43:37 UTC


#------------------------ 时间判断
# past? 过去
t1.past?   
# => true
# => true

# future? 将来
t2 = Time.now + 1.day
t2.future?      # => true

# today? 今天
Time.new(2018,3,6).today?  # false
Time.now.today?            # true


#------------------------ 时间转换
# to_time(自动转换时区)
'2019-1-28 11:39:23'.to_time       # => 2019-01-28 11:39:23 +0800

# to_datetime(默认utc时间)
'2019-1-28 11:39:23'.to_datetime   # => Mon, 28 Jan 2019 11:39:23 +0000

# to_date(日期)
'2019-1-28 11:39:23'.to_date       # => Mon, 28 Jan 2019 


#------------------------ 时间开始/结束
# 小时开始
Time.now.beginning_of_hour
# => => 2019-09-11 18:00:00 +0800

# 小时结束
Time.now.end_of_hour
# => 2019-09-11 18:59:59 +0800

# 天的开始
Time.now.beginning_of_day          # => 2019-09-06 00:00:00 +0800

# 天的结束
Time.now.end_of_day                # => 2019-09-06 23:59:59 +0800

# 月开始
Time.now.beginning_of_month
# => 2019-09-01 00:00:00 +0800

# 月结束
Time.now.end_of_month
# => 2019-09-30 23:59:59 +0800


#------------------------ 时间增减
# 加上某个时间
Time.now.advance(days: 1, hours: 1, seconds: 1, minutes: 10)
# => 2019-09-12 19:55:26 +0800

# from_now(多久后)
(1.days + 2.months + 3.years).from_now
# => Tue, 29 Mar 2022 11:47:07 CST +08:00

# ago(多久前)
3.day.ago

# change 改变时间
Time.new(2018,3,4).change(year: 2019, month: 6,day: 4, hour: 14, min: 16, sec: 35)
# => 2019-06-04 14:16:35 +0800


#--------------- 时间范围
# 整天
Time.current.all_day
# => Wed, 11 Sep 2019 00:00:00 CST +08:00..Wed, 11 Sep 2019 23:59:59 CST +08:00

# 整月
Time.current.all_month
# => Sun, 01 Sep 2019 00:00:00 CST +08:00..Mon, 30 Sep 2019 23:59:59 CST +08:00

# 整年
Time.current.all_year
# => Tue, 01 Jan 2019 00:00:00 CST +08:00..Tue, 31 Dec 2019 23:59:59 CST +08:00


#--------------- 时间格式
Time.now.to_formatted_s(:time) # => "18:50"
Time.now.to_formatted_s(:db)   # => "2019-09-11 18:49:40"




#=========================================== 模块 ==========================================#
# mattr_accessor 模块虚拟属性
module A
  mattr_accessor :hu
end

A.hu
# => nil
A.hu = 'sd'
# => 'sd'



#=========================================== 查询字符串 ==========================================#
# 解析查询字符串
Rack::Utils.parse_nested_query("hu%5B%5D=2&hu%5B%5D=4&hu%5B%5D=8")
# {"hu"=>["2", "4", "8"]}

# 数组
[2,4,8].to_query('hu')
# => "hu%5B%5D=2&hu%5B%5D=4&hu%5B%5D=8"
# {"hu"=>["2", "4", "8"]}

# hash
{name: 'zhanglong', age: 18}.to_query('user')
# => "user%5Bage%5D=18&user%5Bname%5D=zhanglong"
# {"user"=>{"age"=>"18", "name"=>"zhanglong"}}



#============================================== hash ==============================================#
# symbolize_keys 符号化键
h = {'a' => 'aww', 'b' => 'qww'}
puts h.symbolize_keys
# {:a=>"aww", :b=>"qww"}


# deep_dup(避免修改副本元素，引起原值改变)
# 比如
a = %w(hu)
b = a.clone

b << 'bar'                   # 这个时候 a 仍不受影响
b.first.gsub!('hu', 'kkk')   # a值改变了

a  # => ["kkk"]
b  # => ["kkk", "bar"]

c = %w(hu)
d = c.deep_dup

d << 'bar'
d.first.gsub!('hu', 'kkk')    # 改变元素 c 不受影响

c # => ["hu"]
d # => ["kkk", "bar"]


# with_indifferent_access 无差别访问
h = {a: '12', b: '34'}.with_indifferent_access
h[:a]
h['a']


# slice 从hash中截取部分hash
# 原hash不变
h = {:a => 1, :b => 6, :c => 12}
h.slice(:a, :b)
# => {:a=>1, :b=>6}
h
# => {:a=>1, :b=>6, :c=>12}


# extract! 从hash中截取部分hash
# 原hash改变
h = {:a => 1, :b => 6, :c => 12}
rest = h.extract!(:a, :b)
# => {:a=>1, :b=>6}
h
# => {:c=>12}


# 类方法 from_xml xml 转hash
xml = <<-XML
  <?xml version="1.0" encoding="UTF-8"?>
    <hash>
      <foo type="integer">1</foo>
      <bar type="integer">2</bar>
    </hash>
XML

hash = Hash.from_xml(xml)
# => {"hash"=>{"foo"=>1, "bar"=>2}}








