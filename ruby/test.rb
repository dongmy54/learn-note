# index 定位字符串
# 可接 正则/字符
str = 'asdahcfldddf'
puts str.index('ddd')
# 8
puts str.index(/[abc]f/)
# 5


# insert 在指定索引处插入
str = 'sadfdmydsa'
str.insert(str.index('dmy'),'X')
puts str
# sadfXdmydsa