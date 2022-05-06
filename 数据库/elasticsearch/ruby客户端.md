```ruby
# 用ruby插入数据
require 'elasticsearch'

client = Elasticsearch::Client.new log: true
client.cluster.health

# 对数据类型很挑剔啊 这里必须严格 2022-03-01 其它不行
# 这里由于没有指定mapping es会自动生成响应的mapping
[
  {name: "笔记本-hw-001", brand_name: "华为", city: "成都", price: 2850, create_at: "2022-03-01 10:12:21"},
  {name: "笔记本-hw-001", brand_name: "华为", city: "北京", price: 1870, create_at: "2022-04-01 10:12:21"},
  {name: "笔记本-hw-001", brand_name: "华为", city: "重庆", price: 8850, create_at: "2022-05-01 10:12:21"},
  {name: "笔记本-hw-002", brand_name: "华为", city: "成都", price: 3850, create_at: "2022-06-01 10:12:21"},
  {name: "笔记本-xm-001", brand_name: "小米", city: "成都", price: 5850, create_at: "2022-03-01 10:12:21"},
  {name: "笔记本-小米-001", brand_name: "小米", city: "北京", price: 7850, create_at: "2022-04-01 10:12:21"},
  {name: "笔记本-小米-002", brand_name: "小米", city: "重庆", price: 7850, create_at: "2022-05-01 10:12:21"},
  {name: "笔记本-apple-001", brand_name: "苹果", city: "成都", price: 2950, create_at: "2022-03-01 10:12:21"},
  {name: "笔记本-apple-001", brand_name: "苹果", city: "成都", price: 2450, create_at: "2022-04-01 10:12:21"},
  {name: "笔记本-apple-001", brand_name: "苹果", city: "北京", price: 6650, create_at: "2022-03-02 10:12:21"},
].each do |body|
  client.index(index: 'products', body: body)
end

client.search(index: 'my-index', body: { query: { match: { title: 'test' } } })
# 搜索
client.search(index: 'books', q: 'dune', field: 'name')
```

