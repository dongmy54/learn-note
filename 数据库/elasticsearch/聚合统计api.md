##### 基本格式
> 聚合支持嵌套

```
GET /products/_search?size=0
{
  "aggs": {
    "聚合名自定义": { 
      "聚合方式（es内部支持的）": { 
        "field": "字段"
      }
    }
  }
}
```

###### terms聚合每种文档数量(类似于sql group_by)
```
# size: 0 不返回详细文档
# 按照品牌去聚会文档数量

GET /products/_search?size=0
{
  "aggs": {
    "brand_count": { 
      "terms": { 
        "field": "brand_name"
      }
    }
  }
}
```

###### 一次运行多个聚合
```
# 品牌数量统计 + 平均价格
# PS：它们都属于同一层次aggs下

GET /products/_search?size=0
{
  "aggs": {
    "brand_count": { 
      "terms": { 
        "field": "brand_name"
      }
    },
    "avg_price": {
      "avg": {
        "field": "price"
      }
    }
  }
}
```

###### 嵌套聚合（子聚合）
```
# 品牌数量统计 + 每个品牌下平均价格
# aggs下 再加aggs

GET /products/_search?size=0
{
  "aggs": {
    "brand_count": { 
      "terms": { 
        "field": "brand_name"
      },
      "aggs": {
        "avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}
```

###### histogram 按照间距分开统计计数
```
# min_doc_count 1 有数据才返回，否则跳过

GET /products/_search?size=0
{
  "aggs": {
    "prices": { 
      "histogram": { 
        "field": "price",
        "interval": 50,
        "min_doc_count": 1
      }
    }
  }
}
```

###### date_histogram 日期的间隔统计
```
# 支持两种间隔
# 1. calendar_interval minute、hour、day、week、month、quarter、year
# 2. fixed_interval(类似于自定义间隔) 支持 ms（毫秒）、s（秒）、m(分)、h(小时)、d(day)
# 写成 36d 代表36天

GET /products/_search?size=0
{
  "aggs": {
    "date_doc": { 
      "date_histogram": { 
        "field": "create_at",
        "calendar_interval": "month",
        "min_doc_count": 1
      }
    }
  }
}
```

###### range 范围（分段统计）
```
# from 包含
# to 不包含

GET /products/_search?size=0
{
  "aggs": {
    "price_ranges": { 
      "range": { 
        "field": "price",
        "ranges": [
          {"key": "便宜", "to": 2000},
          {"key": "中间", "from": 2000, "to": 4000},
          {"key": "非常贵", "from": 4000, "to": 10000}
        ]
      }
    }
  }
}
```

###### 聚合方式总结
> 聚合api 文档 https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html
> 一、指标类
> 1. avg 平均值
> 2. cardinality 基数计数（比如总共多少个品牌）类似 distinct
> 3. min、max 最小/大
> 4. stats 统计值（最小/大/平均/总数一起返回）


> 二、桶类
> 1. terms 按指定字段分组聚合（类似group_by)
> 2. histogram 直方图（需要指定一个间隔，比如价格间距分段统计）
> 3. date_histogram 日期间隔 支持 minute、hour、day、week、month、quarter、year
> 4. range 范围分段







