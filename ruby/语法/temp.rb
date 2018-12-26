#===================================================================================#
# 污染对象
# ruby 会把从外界获取的值 自动标为污染对象
# tainted? 是否为污染
# untaint  解除污染 
print "input a value: "
a = gets.chomp

puts a.tainted?  # => true

a.untaint

puts a.tainted?  # => false


# dup 不能复制单例方法 #
a = Object.new

def a.foo
  puts 'foo'
end

b = a.clone.foo
#c = b.dup.foo
# undefined method `foo' for nil:NilClass (NoMethodError)


#===================================dup Vs clone ========================================#
# clone 会保持原有的状态（冻结）
class Post
  attr_accessor :title
end

p = Post.new.freeze

p1 = p.dup
p1.title = 'hello'

p2 = p.clone
p2.title = 'hello'
# can't modify frozen Post (FrozenError)


