# merge hash 合并
# 相同的键 将会被后面的键值 覆盖
h1 = {:a => 'ab',:b => 'df'}
h2 = {:a => 'we',:c => 's'}
h1.merge(h2)
# {
#     :a => "we",
#     :b => "df",
#     :c => "s"
# }

# key(value) 查值的键
h = {:a => 'abc', :b => 'def',:c => 'kio'}
h.key('def')
# => :b

# 取出 每个键
h = {:a => 'abc', :b => 'def',:c => 'kio'}
h.each_key {|k| puts k}
# a
# b
# c

# 取出 每个值
h = {:a => 'abc', :b => 'def',:c => 'kio'}
h.each_value {|v| puts v}
# abc
# def
# kio


# has_key? 是否有某键
h = {:a => 'abc', :b => 'def',:c => 'kio'}
h.has_key?(:b)
# => true
h.has_key?(:d)
# => false


# hash_value? 是否有某值
h = {:a => 'abc', :b => 'def',:c => 'kio'}
h.has_value?('abc')
# => true
h.has_value?('k')
# => false
