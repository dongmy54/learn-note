# class A
#   @@ko = "ko"      # 类变量   （对类而言）
#   @ji = "ji"       # 实例变量 （对 类而言）因为类也是对象，所以它也有实例变量
#   def test
#     @hu = "sd"     # 实例变量（针对对象而言）
#     @bar = "I'm bar"
#     ko =  'ssd'    # 而私有变量则不能被 后续函数调用
#     hu 
#   end
# end

# def hu
#   puts @hu       # 在方法调用中，可以使用前面产生的实例变量
#   bar
# end

# def bar
#   puts @bar      
# end

# object = A.new
# object.test
# puts object.instance_variables
# puts "object：我拥有这些实例方法：#{object.methods}"
# puts "A: 我拥有这些实例方法：#{A.instance_methods}"
# puts "A: 我拥有这些方法： #{A.methods}"
# puts A.instance_variables
# puts A.class_variables

# puts object.class   # A
# puts A.class        # Class
# puts Class.class    # Class
# puts A.superclass   # Object
# puts Object.class   # Class
# puts Object.superclass  #BasicObject
# puts BasicObject.class  # Class  ruby 类 根节点
# puts BasicObject.superclass  # nil ruby对象根节点
# puts Class.superclass   # module 模块
# puts Module.class       # Class
# puts Module.superclass  # Object 再次回到object

# FC = "I'm root constants"
# module A
#   FC = "I'm first contants"
#   ::FC           # 所谓的根 级别 是指：模块之外
#   class B
#     # FC = "I'm second contants"
#     # def test
#     #   puts A::FC
#     #   puts Module.nesting
#     # end

#     module C
#       class D
#         puts Module.nesting
#       end
#     end
#   end
# end

# A::B.new.test
# puts A.constants
# class MyClass

#   def self.test
#     H = "dsd"  # 类方法中也不行，只能在模块层 或者 类层定义
#   end

#   def test
#     H = "sddfa"  # 我们不能载实例方法中定义常量
#   end
# end

# MyClass.test


# module A
#   #puts "I'm A module"

#     def self.test
#       puts "I'm a methods of A module"
#     end

#     module B
#       def test
#         puts "test"
#       end
#     end
  
# end

# # class A
# #   puts "I'm A class"   # A这个名字已经被模块使用了，不能当作类
# # end

# class B
#   puts "I'm "     # 如果模块的名字是在深层就可以
# end

# module A

#   def self.hu
#     puts "I'm module methods"
#   end

#   def bar
#     puts "I'm instance_methods"
#   end

#   private

#   def ko
#     puts "I'm private instance_methods"
#   end

# end

# class B
#   include A

#   def bar
#     puts "I'm instance methods B"
#   end

#   def test
#     bar
#     ko
#   end
#   ko
#   #B.new.ko          # 私有方法不能调用
#   B.new.bar
#   puts B.ancestors
#   print A.private_instance_methods
# end

# class A

#   class << self
#     def test
#       puts "hello"
#     end
#   end

# end

# A.test


# module A

#   def self.bar
#     puts "self methods"  # 只能被A模块使用
#     #hu                   # 模块不能使用 私有实例方法
#   end

#   def moduel_method
#     puts "A Module"
#   end

#   private
#     def hu
#       puts "I'm private methods"
#     end
# end

# class B
#   include A
#   def test
#     moduel_method
#     hu
#   end
#   #hu                  # 在类中，方法之外是不能用私有实例方法的
#   puts self
# end                  

# B.new.test
# A.bar
# puts B.private_instance_methods      # 是它自己和祖先链中所有私有实例方法






# sql = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
# column_sql = "SELECT column_name FROM information_schema.columns WHERE table_name = ?"
# tables = DB[sql].all
# tables.each_with_index do |table,i|
#   if i % 20 == 0 && i != 0
#     puts "-----------------------------------------------------暂停一下:上面是第      #{i}     次数据"
#     gets
#   end
#   columns = DB[column_sql, table[:table_name]].all
#   puts "# Table名:#{table[:table_name]}"
#   puts "# 字段含义："
#   columns.each do |column|
#     puts "#   #{column[:column_name]}                : 待填充"
#   end
# end


# module K
#   private
#     def print(h)
#       puts "skdshfa s#{h}"
#     end
# end

# class B
# end

# module N
#   prepend K
# end

# class H 
#   include K
#   prepend N
 
# end

# print H.ancestors


# module M1; end

# module M2
#   include M1
# end 

# class M3
#   prepend M1
#   prepend M2
# end

# print M3.ancestors

# class A
#   def test
#     puts "hello"
#   end

#   def test_1
#     test            # 在定义启用细化前，就调用了自己类中的test方法，因此细化实效了
#   end
# end

# module AExtention
#   refine A do
#     def test
#       puts "I'm refine methods"
#     end
#   end
# end

# using AExtention
# A.new.test
# A.new.test_1


# module A
#   module B
#     def test
#       puts "hello"
#     end
#   end
# end

# class C
#   extend A::B
  
# end

# C.test

# class TesExpection < StandardError      #定义异常类
# end

# def test
#   begin
#     raise TesExpection, "I'm TesExpection"
#   rescue TesExpection => e
#     puts e.message
#   end
# end

# test

# a = Account.new

# unless a.valid?
#   error_message = []
#   a.errors.each_value do |value|
#     error_message << value
#   end
#   puts error_message.join(',')
# end

# File.open("文件测试.txt","a") do |f|
#   f.syswrite("huasdada\r\n")
#   f.syswrite("第二行\r\n")
#   f.syswrite("第s行\r\n")
# end


# def fetch_level_text(level_code)
#   level_relation = {
#     :free   => '免费版',
#     :devel  => '开发版',
#     :level1 => '基础版',
#     :paid   => '专业版',
#     :level3 => '企业版',
#     :level4 => '旗舰版'
#   }
#   level_relation[level_code.to_sym]
# end

# puts "通知" + fetch_level_text("free")

# *arg 与 options={}不要同时用，会误会
# def test(arg,options={})
#   puts "arg是：#{arg};"
#   puts "options是：#{options}"
# end

# test(:class => 'hu')

# class Object            # 打开一个类，让所有对象都可以去调用这个try方法
#   def try(method_name)
#     self.nil? ? '无': self.send(method_name)
#   end
# end

# puts "sd".try(:to_s)

# class A
#   def test
#   end

#   private

#     def hu
#       puts "hu"
#     end
# end


# a = A.new

# puts a.respond_to?(:hu)

# puts a.respond_to?(:hu,true)
# 为true是 私有方法 也会被包含进来


# def test(a,b)
#   t = ''
#   if a &&(t = b)     # 赋值之后再做判断是可以的
#     puts 'ok'
#   else
#     puts 'no'
#   end
# end

# test(2,false)

# class A
#   def respond_to_missing?(name,include_private=false)     # respond_to_missing？ 可以去探测幽灵方法
#     true                                                  # respond_to? 它会触发respond_to_missing?方法
#   end                                                     # respond_to? 正常情况下不会觉知到幽灵方法
# end

# puts A.new.respond_to? :kokokoko 

# class A
#   def test
#     puts 'sd'
#   end

#   undef_method :private_methods     # undef_method 会解除某些实例方法
# end

# puts A.new.private_methods

# require 'byebug'
# module A
#   class B
#     def self.t
#       byebug
#       puts 'sdasdfa'
#     end
#   end
# end

# A::B.t
# printf "请输入一个任意值："
# a = gets.chomp

# puts "这个值是：#{a}"

# def test(a,c,b={},d=5)
#   puts "sd"
# end

# test(2,2,{:a => 'sd'},6)

# def test(a,b= true,c = false)
#   puts "a: #{a}"
#   puts "b: #{b}"
#   puts "c: #{c}"
# end

# test('sd',c = 'sdwe')

# class A;end
# class B < A;end

# puts B.new.is_a?(A)

# module A
#   module B
#     def self.test
#       puts "ds"
#     end
#   end
# end

# A::B::test

# puts File.expand_path("blog-tutorial/app/controllers", __FILE__)

# puts __FILE__

# require 'sequel' 
# require 'pg'

# DB = Sequel.postgres(:host => '121.201.29.243', 
#            :port => 59888, 
#            :user => 'yeeshop', 
#            :password => '123456', 
#            :database => 'yeeshop_v1', 
#            :max_connections => 20, 
#            :pool_timeout => 30 
#            )

# sql = "select * from accounts limit 1"
# puts DB[sql].first

# class A

#   def initialize
#     @k = 'k'
#   end

#   def test
#     @h = 'h'
#     @b = 'b'
#   end
# end

# a = A.new
# puts "对象实例变量：#{a.instance_variables}"
# puts "对象实例变量对应值：#{a.instance_variable_get a.instance_variables[0]}"

# def test(a)
#   return if a == 1         # 当仅是return 时程序就已经返回了 后面打印信息不执行
#   puts "输入不是1"
#   return if a == 2
#   puts "输入不是2"
# end

# test(1)
# # test(2)
# # test(3)

# require 'uri'
# require 'net/http'
# require 'json'

# uri = URI('https://sms.yunpian.com/v2/sign/get.json')

# res = Net::HTTP.post_form(uri, 
#                           'apikey' => '00dfb91f1b591cf8a5d1836ac9abf655',
#                           'sign' => '【欢乐公司】')
# res_hash = JSON.parse(res.body)
# puts res_hash


# module A
#   module B
#     C = 'sd'
#   end
# end

# puts Object.const_get 'A::B'
# puts Object.const_get 'A::B::C'

# while (true)
#   print "请输入指令 1. add 2. remove 3. save，然后按 Enter: "
#   command = gets.chomp

#   if command == "add"
#     print "请输入代办事项: "
#     event = gets
#     nfile = File.new("todos.txt", "a+") 
#       nfile.write(event)
      

#   elsif command == "remove"
#     print "请输入要删除的编号: "
#     number = gets.chomp
    
#     file_lines = ''
#     i = 0
#     File.readlines("todos.txt").each do |line|
#       unless i == number.to_i
#         file_lines += line
#         puts line
#       end
#        i += 1
#     end

#     File.open('todos.txt', "w") do |f|
#       f.puts file_lines
#     end
  
#   elsif command == "save"
#     puts "存盘离开"

#     # ...
#     break;
#   else
#     puts "看不懂，请再输入一次"
#   end
# end

# print "--------------请输入一个开始页面的post编号："
# start_page = gets

# puts start_page


# print "-----------请输入一个开始页面的post编号、文件名（用英文逗号逗号','分隔）："
# # 获取开始页面的编码 和文件名
# start_page,file_name = gets.chop.split(",")

# puts start_page,file_name

# module A
#   module B
#     module C
#     end
#   end
# end

# def fetch_class(str)
# puts  str.split("::").inject(Object) {|mode,name| mode.const_get name}
# end

# fetch_class("A::B")


# block = proc {
#   puts "这是#{k} 次，值为：#{h}"    #  感觉必须要传参数呀
# }
# (1..3).each_with_index do |a,i|
 
#   block.call    
# end

# b = '看看'

# a = %( #{b} sda sda; sd
# sa sdaf sda sadf sadf 
# sd sdf sd sd sdaf ).gsub(/\s+/, ' ')

# puts a

# c = 'sdaf sdaf sda sd'\
#     'sda sda sda sdaf'\
#     'sdfa sda'

# puts c

# require 'rake'

# task :my_task, [:a,:b] do |t,args|
#   puts args
# end

# $stdout.print "Output to $stdout.\n"

# $stderr.print "Output to $stderr.\n"

# if $stdin.tty?
#   print "stdin is a TTY.\n"
# else
#   print "stdin is not a TTY.n"
# end

# File.open("log.txt") do |io|
#   while line = io.gets
#     puts line
#   end
# end

# puts "sd"

# file = File.open("log.txt")
# file.close
# p file.closed?

# io = File.open("log.txt")
# io.each_line do |line|
#   #line.chomp!

#   printf("%3d %s", io.lineno, line)
# end                # io.lineno 行号

# p io.eof?

# io.close


# $stdin.each_line do |line|
#   printf("%3d %s", $stdin.lineno, line)
# end

# io = File.open("log.txt")

# io.each_byte do |ch|
#   puts ch
# end

# io.close
# io = File.open("log.txt")
# while ch = io.getc
#   puts ch
# end

# File.open("log.txt") do |io|
#   p io.read(5)
  
# end

#puts "foo","bar","baz"

# $stdout.putc(82)
# $stdout.putc("ruby")
# $stdout.putc("\n")

# io = File.open("log.txt", 'a')
# io << "foo" << "bar" << "baz"
# io.close

# File.open("log.txt") do |io|
#   p io.gets
#   io.rewind        # 正常情况下，读取一次之后会跳到下一行
#   p io.gets
# end

# io = File.open("log.txt", 'w')
# io.truncate(200)
# io = File.open("log.txt")
# io.each_line do |line|
#   p line
# end
# io.close

# $stdout.print "out1 "
# $stderr.print "err1 "
# $stdout.print "out2 "
# $stdout.print "out3 "
# $stderr.print "err2\n  "
# $stdout.print "out4\n "

# require 'open-uri'

# options = {
#   "Accept-Language" => "zh-cn, cn;q=0.5",
# }

# open("http://www.ruby-lang.org", options) do |io|
#   puts io.read
# end

# f = ARGV[0]
# s = ARGV[1]
# t = ARGV[2]

# puts f,s,t

# require 'open-uri'
# require 'nkf'

# url = %(https://code.tutsplus.com/tutorials/ssh-what-and-how--net-25138).gsub(/\s+/, '').strip
# puts url
# filename = "cathedral.html"

# File.open(filename, 'w') do |f|
#   text = open(url).read
#   f.write text
# end

# class Test

#   def initialize(name = 'dmy', age = 18)
#     @name ,@age = name,age
#   end

#   def tell_info
#     puts "You name is #{@name}","You age is #{@age}"
#   end

# end

# 可以在终端require '文件路径/test.rb' 加载这个文件


# def test(number,i)
#   if i == 1
#     rand_number = number
#   else
#     rand_number = rand(100) 
#   end
#   return if number == 49        # break 只能用于循环
#   puts "第#{i}次number值：#{rand_number}"
#   i += 1
#   test(rand_number,i)            # 神奇的事，自己居然可以调用自己
# end

require 'find'

Find.find('blog-tutorial') do |path|
  puts path      # 强大的find库
end
































