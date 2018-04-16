def test(a,binding = @_binding)
  # 获取变量名
  puts "variable_name: #{a.to_s}"
  # 获取变量值
  puts "variable_name: #{eval(a.to_s,binding)}"
end