# 动态定义
# 核心: define_method method_name(符号/字符串)
class Company
  define_method :info do |name|
    puts "这是公司的信息: #{name}"
  end
end

Company.new.info('成员')
# 这是公司的信息: 成员