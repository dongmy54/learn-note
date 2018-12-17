#### 相关method

##### decrement VS decrement!
1. decrement 不会将数据立马更新到数据库, decrement! 会将数据立马更新到数据库
2. decrement!默认情况下，不会更新updated_at; 更新写法为 `user.decrement!(post_count, 5, touch: true)`

- 'Model.column_names'  等价于  `Model.attribute_names` 展示model字段列表
- 'object.as_json' 等价于 'object.serializeble_hash' 对象转json格式序列
- 'Model.pluck(:attribute)' 只能用于Modle 或 where 关系

##### update VS update_all
1. user.update(yy) 单个 返回 true/false
2. User.where(name: 'xx').update(yy) 关系 返回对象数组，不管成功与否
3. update 验证 回调都会触发
4. update_all 验证回调都不会触发

##### order 
对具体某表排序
- usage: `GameType.includes(:game_sublevels).order('game_sublevels.name')`
按优先级别对多个字段排序
- `GameType.all.order(:name).order(:id)` 名字优先,然后id