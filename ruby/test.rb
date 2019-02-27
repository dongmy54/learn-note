# * 代表数组
# ** 代表hash
# 数组 hash都可省
def foo(a, *b, **c)
  puts a.inspect, b.inspect, c.inspect
end

foo(2)
# 2
# []
# {}

foo(1, :a => '1', :b => '2')
# 1
# []
# {:a=>"1", :b=>"2"}

foo(2, 2, 3, 4, :a => '2', :b => '23')
# 2
# [2, 3, 4]
# {:a=>"2", :b=>"23"}