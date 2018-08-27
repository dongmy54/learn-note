# 来源: method_missing 是 BasicObject 私有实例方法
# 原理: 在找遍所有祖先链未果，会执行 method_missing
# 本质: method_missing 只是截获作用，方法仍不存在
# PS:
# 1、method_missing 明确 截获的方法类型（避免不必要的截获）
# 2、方法已存在,使用白板类（class A < BasicObject)
class A
  def method_missing(name,*params)
    case name.to_s 
    when /^cheng_du.*/      # 以cheng_du 开头的方法
      puts '成都方法'
      puts "参数是：#{params.join(',')}"
    when /^mian_yang.*/     # 以mian_yang 开头的方法
      puts '绵阳方法'
      puts "参数是：#{params.join(',')}"
    else
      super                 # 一般都会释放出去
    end    
  end

  # 为了让respond_to? 能正确反应 覆写 respond_to_missing?
  def respond_to_missing?(method_name,include_all)
    return true if method_name.to_s =~ /^cheng_du.*/ || method_name.to_s =~ /^mian_yang.*/
    false
  end
end

a = A.new
a.respond_to? :cheng_du_hh        # => true
a.cheng_du_hh('ad','ds',12)
# 成都方法
# 参数是：ad,ds,12
a.respond_to? :mian_yang_sa_ds    # => true
a.mian_yang_sa_ds('qw','rf',10)
# 绵阳方法
# 参数是：qw,rf,10
a.respond_to? :ds                 # => true
a.ds('ds')
# `method_missing': undefined method `ds' for #<A:0x007ff24f8827c0> (NoMethodError)



