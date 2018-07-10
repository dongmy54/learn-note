# 所有找不到的方法，都会跑到这里集合
# 1. 方法的名字是 name
# 2. 参数过来是一个数组
class A

  def method_missing(name,*params)
    
    if name.to_s =~ /^cheng_du.*/      # 以cheng_du 开头的方法
      puts '成都方法'
      puts "参数是：#{params.join(',')}"
    elsif name.to_s =~ /^mian_yang.*/  # 以mian_yang 开头的方法
      puts '绵阳方法'
      puts "参数是：#{params.join(',')}"
    else
      super                            # 没有就没有
    end
      
  end

end

A.new.cheng_du_hh('ad','ds',12)
# 成都方法
# 参数是：ad,ds,12
A.new.mian_yang_sa_ds('qw','rf',10)
# 绵阳方法
# 参数是：qw,rf,10
A.new.ds('ds')
# `method_missing': undefined method `ds' for #<A:0x007ff24f8827c0> (NoMethodError)
