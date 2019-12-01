#### 条件get缓存
>1. 本质：利用条件请求头 IF_NONE_MATCH(etag: 实体资源表识) 与 IF_MODIFIED_SINCE(上次修改时间)
>2. 浏览器端缓存,缓存存在、未做修改时,服务器返回304;不再做渲染操作

##### 用法 stale?
> 用于响应不同format请求

```ruby
# 自定义etag 和 last_modified
def condition_get
  @author = Author.find(params[:id])

  if stale?(last_modified: @author.updated_at.utc, etag: @author.cache_key)
    respond_to do |format|
      format.html {render :condition_get}
    end
  end
end


# 给对象
def condition_get1
  @author = Author.find(params[:id])

  if stale?(@author)
    respond_to do |format|
      format.html {render :condition_get}
    end
  end
end
```

##### fresh_when 默认响应
```ruby
def condition_get2
  @author = Author.find(params[:id])
  fresh_when @author
end
```

#### 效果
![Snip20181021_1.png](https://i.loli.net/2018/10/21/5bcc76c367774.png)
