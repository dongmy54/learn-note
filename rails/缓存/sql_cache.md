#### sql缓存
> 同一个请求action中，相同的查询sql会被rails缓存到内存

```ruby
def sql_cache
  # 第一次从数据库中取
  @authors = Author.all
  # Author Load (0.5ms)  SELECT "authors".* FROM "authors"


  # 第二次从内存中取
  hu = Author.all
  # CACHE (0.0ms)  SELECT "authors".* FROM "authors"
end
```
