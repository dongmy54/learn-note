# 动态派发
# 核心：send 方法名,参数
# PS:  它可以调用私有方法


#============= 单独用 ===============#
arg = 'to'
puts :hu.send "#{arg}_s"
# hu


#============= 组合用 ===============#
# 常与动态方法一起
class Car
  def initialize
    @data_resource = connection_cars_data # 链接到汽车数据
  end

  CarNames = %w(benchi baoma dazong)

  CarNames.each do |car_name|
    define_method car_name do
      info   = @data_resource.send "get_#{car_name}_info"    # 假设 get_xx_infor/price 方法存在
      price  = @data_resource.send "get_#{car_name}_price"
      result = "#{car_name}: #{info};#{price}"
      result
    end
  end

end

Car.new.benchi    # 这样用