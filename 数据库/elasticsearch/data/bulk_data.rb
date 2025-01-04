require 'json'
require 'time'

# 配置
CUSTOMERS = ["张三", "李四", "王武"]
PAYMENT_METHODS = ["支付宝", "微信", "银行卡"]
ORDER_STATUSES = ["unpaid", "paid", "cancel"]
CATEGORIES = ["办公用品", "服饰", "餐饮", "电器"]
PRODUCTS = {
  "办公用品" => ["笔记本", "打印机", "键盘", "鼠标", "USB线"],
  "服饰" => ["T恤", "衬衫", "牛仔裤", "外套"],
  "餐饮" => ["咖啡", "披萨", "汉堡", "可乐"],
  "电器" => ["笔记本电脑", "冰箱", "微波炉", "显示器"]
}

# 生成随机日期
def random_date(start_date, end_date)
  random_days = rand((end_date - start_date).to_i)
  start_date + random_days
end

# 生成订单数据
def generate_order(order_id)
  customer_name = CUSTOMERS.sample
  order_date = random_date(Time.new(2024, 10, 1), Time.new(2024, 12, 31))
  total_amount = (rand(50.0..500.0) * 100).round.to_f / 100
  payment_method = PAYMENT_METHODS.sample
  order_status = ORDER_STATUSES.sample
  items = []
  rand(1..3).times do
    category = CATEGORIES.sample
    product_name = PRODUCTS[category].sample
    quantity = rand(1..5)
    price = (rand(10.0..200.0) * 100).round.to_f / 100
    items << {
      product_id: "P#{rand(100..999)}",
      product_name: product_name,
      category: category,
      quantity: quantity,
      price: price
    }
  end
  {
    order_id: order_id.to_s,
    customer_id: "C#{rand(100..999)}",
    customer_name: customer_name,
    order_date: order_date.iso8601,
    total_amount: total_amount,
    payment_method: payment_method,
    shipping_address: "地址#{rand(1..100)}",
    order_status: order_status,
    items: items
  }
end

# 生成批量数据
bulk_data = []
(1..200).each do |i|
  bulk_data << { index: { _index: "orders" } }
  bulk_data << generate_order(i)
end

# 保存为 JSON 文件
File.open("bulk_data.json", "w") do |f|
  bulk_data.each do |item|
    f.puts(JSON.generate(item))
  end
end

puts "bulk_data.json 文件已生成"