#### 请求头缓存
>1. 利用 HTTP_IF_NONE_MATCH 与 HTTP_IF_MODIFIED_SINCE 实现
>2. 原理：
>>首次访问时，服务器端返回 etag(内容标识符) last_modified(最后修改时间),分别存入 HTTP_IF_NONE_MATCH、HTTP_IF_MODIFIED_SINCE;
>>下次请求时,请求头带上 HTTP_IF_NONE_MATCH、HTTP_IF_MODIFIED_SINCE,服务端去判断内容是否更新,如果没更新则返回304（未更改）

#### 用法
`stale?` 搭配 respond_to
```ruby
class JobsController < ApplicationController
  @job = Job.find_by_id(params[:id])

  if stale?(@job)
    respond_to do |format|
      format.html {render :show}
      # ....
    end
  end
end
```

`fresh_when`不分响应
```ruby
class JobsController < ApplicationController
  @job = Job.find_by_id(params[:id])
  fresh_when last_modified: @job.updated_at.utc, etag: @job
end
```
#### 效果
![Snip20181021_1.png](https://i.loli.net/2018/10/21/5bcc76c367774.png)
