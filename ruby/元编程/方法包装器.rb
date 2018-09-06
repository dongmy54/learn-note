# 大体上两种
# 1、别名方法-环绕别名（不推荐)
# 2、super-细化/下包含

#======================== 环绕别名 ==========================#
class A
  def method
    'method'
  end
end

class B < A
  # 原方法复制一份
  alias_method :new_method, :method

  # 复写
  def method
    # 利用复制方法
    "D" + new_method + "M"
  end
end

puts B.new.method  # DmethodM



#======================== 下包含(推荐) =============================#
module StringWapper
  def reverse
    'D' + super + 'M'
  end
end

String.class_eval { prepend StringWapper}

puts "abc".reverse   # DcbaM




