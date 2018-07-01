# Kernel 属于 Object 中的模块
# 所以任何继承自 Object类的 对象都可用 用其内部方法
module Kernel
  def opp
    puts 'opp'
  end
end

class A;end

opp
# opp

'obd'.opp
# opp

A.new.opp
# opp

A.opp
# opp