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