```ruby
# 用ruby插入数据
require 'elasticsearch'

client = Elasticsearch::Client.new log: true
# 远端连接
# client = Elasticsearch::Client.new(
#   url: 'http://username:password@localhost:9200',
#   transport_options: {
#   ssl: { ca_file: '/path/to/cacert.pem' }
#   }
# )
client.cluster.health

# 创建一个users索引
client.indices.create(
  index: 'users',
  body: {
    mappings: {
      properties: {
        name: {
          type: 'text'
        },
        age: {
          type: "integer"
        },
        city: {
          type: "keyword"
        },
        description: {
          type: "text"
        }
      }
    }
  }
)

# 插入单条数据
body = {
  name: "张三",
  age: 18,
  city: "北京",
  description: "爱好学习",
  tag: ["上进", "努力"]
}

client.index(index: 'users', body: body)

# 批量插入多条数据
body = [
  { index: { _index: "users", _id: '2' } },
  { name: "王武", age: 19, city: '成都', description: "贪玩", tag: ["渣男"]},
  { index: { _index: "users", _id: '3' } },
  { name: "李四", age: 23, city: '上海', description: "喜欢钓鱼", tag: ["青年才俊"]},
  { index: { _index: "users", _id: '4' } },
  { name: "岳飞", age: 16, city: '成都', description: "非常爱过", tag: ["精忠报国"]},
  { index: { _index: "users", _id: '5' } },
  { name: "五号", age: 18, city: '武汉', description: "家住刘家村", tag: ["嘻哈"]},
]
client.bulk(body: body)


# 查看单个文档
client.get(index: 'users', id: 2)

# 更新文档
client.update(index: 'users', id: 2, body: {doc: {description: "不是特别贪玩"}})

# 删除文档
client.delete(index: 'users', id: 5)

# 搜索
client.search(index: 'users', body: { query: { match: { name: '飞'}}})
res = client.search(index: 'users', body: { size: 15 })
res['hits']['hits'].count 

# 重新索引(重新建立一个users-reindex 原索引不变)
client.reindex(body: {source: { index: 'users'}, dest: {index: 'users-reindex' } })

# 查看索引
response = client.indices.get_mapping(index: 'users')
```

