# ================================== 丢出异常 ======================================#
raise StandardError, '第一个标准异常'
# ruby/test.rb:40:in `<main>': 第一个标准异常 (StandardError)
raise StandardError.new('第二个标准异常')
# ruby/test.rb:42:in `<main>': 第二个标准异常 (StandardError)
raise '默认RuntimeError异常'
# ruby/test.rb:44:in `<main>': 默认RuntimeError异常 (RuntimeError)



# ================================== 认识异常 ======================================#
# PS: 1、所有异常都是 Exception的子类
# PS: 2、大部分异常是 StandardError的子类
def test
  raise '认识异常'
rescue => e
  puts "------------异常: #{e}"                # <=> $! 当前异常 
  puts "----------异常类: #{e.class}"
  puts "---------异常描述: #{e.message}"
  puts "---------异常回溯: #{e.backtrace}"       # <=> $@ 当前回溯
  puts "------异常全部信息: #{e.full_message}"   # 2.3.3 ruby 暂不支持 
  puts "-------异常类+描述: #{e.inspect}"
end

test
# ------------异常: 认识异常
# ----------异常类: RuntimeError
# ---------异常描述: 认识异常
# ---------异常回溯: ["ruby/test.rb:41:in `test'", "ruby/test.rb:51:in `<main>'"]
# ------异常全部信息: Traceback (most recent call last):
#   1: from ruby/test.rb:51:in `<main>'
# ruby/test.rb:41:in `test': 认识异常 (RuntimeError)
# 
# -------异常类+描述: #<RuntimeError: 认识异常>



# ================================== 捕获异常 ======================================#
def exception_test(&block)
  begin
    yield if block_given?
  rescue RuntimeError => e
    puts '捕获到默认-RuntimeError异常'
  rescue ArgumentError => e
    puts '捕获到-ArgumentError异常'
  rescue RangeError,NameError => e
    puts '捕获到-RangeError/NameError异常'
  rescue StandardError => e                # 等价于 => e
    puts '捕获到-StandardError-或 其子异常'
  rescue Exception => e
    puts '这里会捕获所有前面未能捕获的异常'
  end
end

exception_test &(lambda {raise RuntimeError,'这里会被RuntimeError捕获'})
# 捕获到默认-RuntimeError异常

exception_test &(lambda {raise ArgumentError,'这里会被ArgumentError捕获'})
# 捕获到-ArgumentError异常

exception_test &(lambda {raise NameError,'这里会被NameError捕获'})
# 捕获到-RangeError/NameError异常
exception_test &(lambda {raise RangeError,'这里会被RangeError捕获'})
# 捕获到-RangeError/NameError异常

exception_test &(lambda {raise StandardError,'这里会被StandardError捕获'})
# 捕获到-StandardError-或 其子异常
exception_test &(lambda {raise TypeError,'这里会被StandarError捕获,因为是它的子类'})
# 捕获到-StandardError-或 其子异常

exception_test &(lambda {raise Exception,'这是所有异常类的祖先类，所有未能捕获都会进Exception'})
# 这里会捕获所有前面未能捕获的异常
exception_test &(lambda {raise SecurityError,'这是所有异常类的祖先类，所有未能捕获都会进Exception'})
# 这里会捕获所有前面未能捕获的异常



# ================================== 定制异常 ======================================#
class Sub1Error < StandardError
end

class Sub2Error < StandardError
end

raise Sub1Error,'定制子异常1'
# Traceback (most recent call last):
# ruby/test.rb:46:in `<main>': 定制子异常1 (Sub1Error)
raise Sub2Error, '定制子异常2'
# Traceback (most recent call last):
# ruby/test.rb:49:in `<main>': 定制子异常2 (Sub2Error)



# ================================== 异常补充 ======================================#
#===================================================================================#
# set_backtrace 设置回溯
# 参数为数组
def test
  raise '产生异常'
rescue StandardError => e
  e.set_backtrace(['回溯第一行','回溯第二行'])
  puts e.backtrace
end

test
# 回溯第一行
# 回溯第二行


#===================================================================================#
# 异常写法
# 方法中 可省略 begin 和 end
def method_name
  raise '写法测试'
rescue StandardError => e
  puts "捕获异常：#{e.inspect}"
end

method_name
# 捕获异常：#<RuntimeError: 写法测试>


