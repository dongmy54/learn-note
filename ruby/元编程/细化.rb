# 细化
# 1、细化是对打开类的补充
# 2、细化将修改后的代码作用域 限制在了一定范围
# 3、启用细化需要 用using 模块
# 4、细化作用域 在类/模块/文件结束
# PS: 细化对 其它方法调用 细化的方法没有作用

module A
  # 细化把 修改装到模块中
  
  # refine + 类名 + 块 标准写法
  refine String do
    def foo
      puts 'refine foo'
    end
  end

end

# 没有using 细化并不生效
# "sdaf".foo       
# undefined method `foo' for "sdaf":String (NoMethodError)

using A      # using + 装细化的模块 启用
'sdaf'.foo
# refine foo