#### restfull_api 常见接口梳理
```ruby
# 查看服务是否正常
curl 'http://localhost:9200/?pretty'
# 列出当前索引
curl -X GET 'http://localhost:9200/_cat/indices?v'
# 创建索引
curl -X PUT 'localhost:9200/weather'
# 删除索引
curl -X DELETE 'localhost:9200/megacorp'
# 插入/更新文档 这里 megacorp为index employee为type 1为id
curl -X PUT 'localhost:9200/megacorp/employee/1' -d '
{
    "first_name" : "John",
    "last_name" :  "Smith",
    "age" :        25,
    "about" :      "I love to go rock climbing",
    "interests": [ "sports", "music" ]
}
'
# 检索
curl -X GET 'localhost:9200/megacorp/employee/1'
# 检索所有雇员
curl -X GET 'localhost:9200/megacorp/employee/_search'
# 检索last_name 为 Smith的人
curl -X GET 'localhost:9200/megacorp/employee/_search?q=last_name:Smith'
# 使用查询表达式搜索
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
    "query" : {
        "match" : {
            "last_name" : "Smith"
        }
    }
}
'
# 复杂查询
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
    "query" : {
        "bool": {
            "must": {
                "match" : {
                    "last_name" : "smith" 
                }
            },
            "filter": {
                "range" : {
                    "age" : { "gt" : 30 } 
                }
            }
        }
    }
}
'
# 全文检索
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
    "query" : {
        "match" : {
            "about" : "rock climbing"
        }
    }
}
'
# 短语检索(挨着才匹配)
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    }
}
'
# 高亮检索（匹配部分高亮单独出来）
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    },
    "highlight": {
        "fields" : {
            "about" : {}
        }
    }
}
'
# 分析聚合（真正的分析数据）PS:分析员工兴趣
curl -X GET 'localhost:9200/megacorp/employee/_search' -d '
{
  "aggs": {
    "all_interests": {
      "terms": { "field": "interests" }
    }
  }
}
'
```