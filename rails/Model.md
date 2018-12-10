#### Model 相关

##### decrement VS decrement!
1. decrement 不会将数据立马更新到数据库, decrement! 会将数据立马更新到数据库
2. decrement!默认情况下，不会更新updated_at; 更新写法为 `user.decrement!(post_count, 5, touch: true)`

- 'Model.column_names'  等价于  `Model.attribute_names` 展示model字段列表
- 'object.as_json' 等价于 'object.serializeble_hash' 对象转json格式序列
- 'Model.pluck(:attribute)' 只能用于Modle 或 where 关系