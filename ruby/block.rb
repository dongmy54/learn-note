# 定义块有两种基本方式
1、do .. end 或 
2、{ }

# 定义块时 需要参数都是在 |（参数）|中定义
block1 = lambda {|a,b| p a,b }
block2 = lambda do |a,b|
          p a,b
         end

block1.call(1,2)    # => 1,2
block2.call(1,2)    # => 1,2