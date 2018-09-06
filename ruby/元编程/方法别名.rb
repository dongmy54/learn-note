# 方法别名 <=>  cpoy 原方法
# 内层用 alias_method
# 顶层用 alias
class A
  def say
    puts 'say something'
  end
  
  # 内层 新, 旧
  alias_method :say_s, :say
end

a = A.new
a.say_s      # say something
a.say        # say something



def say
  puts 'say_m'
end

# 顶层 新 旧
alias :say_s :say

say         # say_m
say_s       # say_m

