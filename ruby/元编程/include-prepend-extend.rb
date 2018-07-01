# include prepend extend 都是扩充方法的方式
# include 上包含
# prepend 下包含
# extend  扩充类方法
module A
  def foo
    puts 'foo'
  end
end

# =========================================
class B
  include A  # 模块加到当前类 上方
end

puts B.ancestors
# [B,A,Object,Kernel,BasicObject]

# =========================================
class C
  prepend A  # 模块加到当前类 下方
end

puts C.ancestors
# [A,C,Object,Kernel,BasicObject]

# =========================================
class D
  extend A  # 扩展 当前类的类方法
end

D.ancestors # 祖先链不变
# [D,Object,Kernel,BasicObject]

D.foo
# foo
