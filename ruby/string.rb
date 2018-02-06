# concat 字符串、数组都可用
str1 = "abc"
str2 = "def"
puts str1.concat(str2)
# abcdef
arr1 = (1..3).to_a
arr2 = (4..6).to_a
puts arr1.concat(arr2)
# 1 2 3 4 5 6
