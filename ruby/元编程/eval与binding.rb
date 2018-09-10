# eval 将字符串当代码执行
#
# 
#======================= 执行字符串 ======================# 
str = "I'm a string"
eval('puts str')      
# I'm a string


eval <<-EOF
  def hu
    puts 'hello'
  end
EOF

hu                   
# hello



#========================== 绑定 ==========================#
def ok(b)
  eval('puts bar', b)
end

bar = 'balabal..'
ok(binding)          # binding 将本地变量bar 带出作用域(进方法)
# balabal..

