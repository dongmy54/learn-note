# 宽松性 public（普通） > protected（保护） > private（私有）
# private 和 protected区别在于，private不能显示调用（指明接收则）

class A
  def method_a
    puts "I'm public a"
  end

  protected
    def method_b
      puts "I'm protect b"
    end

  private
    def method_c
      puts "I'm private c"
    end
end

class B < A
  def b_class_method_b
    method_b # 隐式
  end

  def b_class_method_c
    method_c # 隐式
  end

  def b_class_method_d
    self.method_b # 显示 可调用 protected方法
  end

  def b_class_method_e
    self.method_c # 显示 不能调用 private方法
  end
end


############### 普通实例隐藏
A.new.method_a
# I'm public a
A.new.method_b
# NoMethodError
A.new.method_c
# NoMethodError


############ send 可处理
A.new.send(:method_b)
# I'm protect b
A.new.send(:method_c)
# I'm private c


############ 隐式都可调用
B.new.b_class_method_b
# I'm protect b
B.new.b_class_method_c
# I'm private c


############ 显示 仅protected可以
B.new.b_class_method_d
# I'm protect b
B.new.b_class_method_e
# NoMethodError



