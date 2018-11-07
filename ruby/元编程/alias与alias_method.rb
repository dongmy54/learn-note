# alias VS alias_method
# 参数 新 旧
# 1、alias 是ruby关键字；alias_method 是Module 中私有方法方法
# 2、顶层作用域只能用 alias
# 3、alias_method 参数需要用 逗号分隔
# 4、alias_method 可以用来做环绕别名
# 4、执行 alias时，self固定（alias放置位置), alias_method 则动态决定


class A
  def hu
    puts "我是A 中 hu"
  end

  def self.alias_test
    alias :hu_2 :hu         # alias 位置在A中，因此self 是 A,替换的的A 中hu
  end
end

class B < A
  def hu
    puts "我是B 中 hu"
  end

  alias_test
end

B.new.hu_2
# 我是A 中 hu


class A
  def hu
    puts "我是A 中 hu"
  end

  def self.alias_test
    alias_method :hu_2, :hu         # alias_method self 由运行动态决定，在B 中执行alias_test 故替换的是B中hu
  end
end

class B < A
  def hu
    puts "我是B 中 hu"
  end

  alias_test
end

B.new.hu_2
# 我是B 中 hu
