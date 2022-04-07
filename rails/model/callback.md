#### 回调
##### before_save
>每次保存（创建/更新）都调用
>PS: 可用于根据某个字段的更新状态，来同步更新其它数据的场合
```ruby
class BetEvent < ApplicationRecord
  before_save :only_one_active_event

  private
    def only_one_active_event
      if active
        BetEvent.where(active: true).where.not(id: id).update(active: false)
        # where 可串
        # where.not 相反
      end
    end
end
```
##### after_initialize
>PS: 特别注意，不仅仅是只有new对象时，才会调用；更新数据也会调用

##### after_create
> 避免每次都做回调操作,仅在创建时执行,用 `after_save`

##### 相关属性变化方法
> 1. rails 5.1以后 previous_changes（无差别访问可以用字符/符号） 只在after_commit 后生效
> 2. after_(create/update/save/commit) 可以用 saved_change_to_<attribute>? / saved_changes? 判断属性是否改变；<attribute>_before_last_save 此前旧值
