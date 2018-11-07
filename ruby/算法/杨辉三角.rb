# 杨辉三角
#        1
#      1   1
#     1  2   1
#    1  3  3   1
#   1  4  6  4   1
#  1  5 10 10  5   1
# 1  6 15 20 15  6   1
def yang_hui_san_jiao(n)
  return [1] if n == 1
  return [1,1] if n == 2

  temp = [1]                              # 头 1
  up_arr = yang_hui_san_jiao(n-1)         # 上一个数组
  up_arr.each_with_index do |e,index|
    break if index == up_arr.length - 1   # 舍弃 最后一个索引
    temp << e + up_arr[index + 1]
  end

  temp << 1                               # 尾 1
  temp
end

puts yang_hui_san_jiao(7).inspect
# [1, 6, 15, 20, 15, 6, 1]
