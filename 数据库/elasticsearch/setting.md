### 日常设置
#### 问题
> Searchkick::ImportError: {"type"=>"cluster_block_exception", "reason"=>"blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"} on item with id '29866'

```bash
# 在空间较小时候，es会自动调整为只可读，下面设置为可读可写
curl -X PUT "10.193.0.21:9200/*/_settings" -H 'Content-Type: application/json' -d'
{
  "index": {
    "blocks": {
      "read_only_allow_delete": false
    }
  }
}'
```


