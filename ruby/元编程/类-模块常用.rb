#===================================================================================#
# const_get 常量获取
# 参数 字符串/符号
class A
  Hu = {
    a: 'hello',
    b: 'bye'
  }
end

puts A.const_get(:Hu).inspect
# {:a=>"hello", :b=>"bye"}
