# 类宏 
# 事先定义类方法 后调用添加方法
class A

  def self.regist_method(method_name)
    define_method method_name do
      puts "#{method_name}已被成功添加"
    end
  end

  regist_method :hello      # 灵活注册
  regist_method :hubar
  regist_method :todo
end

a = A.new
a.hello      
# hello已被成功添加
a.hubar      
# hubar已被成功添加
a.todo       
# todo已被成功添加