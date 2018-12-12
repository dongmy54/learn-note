#### 相关验证
##### uniqueness 同时和 另外一个字段 保持唯一
```
validates :name, uniquness: {scope: :game_type_id} 
```