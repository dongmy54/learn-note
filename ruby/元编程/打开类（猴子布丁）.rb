# 打开类
# 打开一个存在的类中，向其中添加（覆盖）方法
# 它的修改是全局性的
class String

  def foo
    puts "I'm a new method of string"
  end

end

"sdaf".foo
# I'm a new method of string 