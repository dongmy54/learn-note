##### 搜索api概览
> 1. 分词器一旦放入plugin目录自动生效，查询时候不用特别指定
> 2. match - 分词后进行匹配 - 全文检索 - 模糊匹配
> 3. term - 不分词直接匹配 - 利用倒排索引 - 精确匹配
> 4. terms - term复数 - 一次查多个词条 - 满足一个就查出来
> 5. bool-must 多个条件必须同时满足
> 6. bool-should 多个条件中满足任何一个就行 - 相当于or
> 7. bool-should-not -多个条件任何一个也不能满足 相当于not
> 8. bool-filter 和must类似只是不记分

###### 示例
```
POST /products/_doc
{
  "name": "噜啦啦",
  "brand_name": "HuaWei",
  "city": "成都",
  "price": 5290,
  "create_at": "2022-04-09 13:45:12"
}

# 匹配所有 默认最多返回10条
GET /products/_search
{
  "query": {
    "match_all": {}
  }
}

# 分页 from - 从多少开始 size - 一次返回条数
GET /products/_search
{
  "from": 3, 
  "size": 1
}

# _source 指定返回字段 - 相当于select
GET /products/_search
{
  "query": {
    "match_all": {}
  },
  "_source": ["name"]
}

# match 全文检索（会进行分词）模糊匹配只要分词中一个匹配都行
# 忽略大小写
GET /products/_search
{
  "query": {
    "match": {
      "name": "祖国万岁"
    }
  }
}

# match 全文检索 对于keyword类型会做为整体匹配
# brand_name是keyword
GET /products/_search
{
  "query": {
    "match": {
      "brand_name": "华"
    }
  }
}


# term 不会分词 直接进行匹配 用于精确匹配
GET /products/_search
{
  "query": {
    "term": {
      "name": {
        "value": "hua"
      }
    }
  }
}

# term的复数 多个词条
# 只要满足其中一个就会搜出来
GET /products/_search
{
  "query": {
    "terms": {
      "name": [
        "万岁",
        "天国"
      ]
    }
  }  
}

# must 相当于and 多个条件必须同时满足
GET /products/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "brand_name": "小米"
          }
        },
        {
          "match": {
            "name": "天国"
          }
        }
      ]
    }
  }
}

# should 相当于or 多个田间满足一个就行
GET /products/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "brand_name": "小米"
          }
        },
        {
          "match": {
            "name": "天国"
          }
        }
      ]
    }
  }
}

# must_not - 不包含其中的任何一个 -相当与not - 不影响记分（score)
GET /products/_search
{
  "query": {
    "bool": {
      "must_not": [
        {
          "match": {
            "name": "祖国"
          }
        },
        {
          "match": {
            "name": "万岁"
          }
        }
      ]
    }
  }
}

# filter -和must类似 - 只是这里不记分
GET /products/_search
{
  "query": {
    "bool": {
      "filter": [
        {"range": {
          "price": {
            "gte": 3000,
            "lte": 4000
          }
        }}
      ]
    }
  }
}

# highlight - 高亮 - 可以指定前/后缀标签
GET /products/_search
{
  "query": {
    "match": {
      "name": "祖国"
    }
  },
  "highlight": {
    "fields": {
      "name": {}
    },
    "pre_tags": "<font color='red'>",
    "post_tags": "</font>"
  }
}
```