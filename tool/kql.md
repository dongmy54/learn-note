### kql 语法
PS：它本身不区分大小写
```
基本使用：字段：值； 比如 userId: "1234"
联合查询：and or 直接拼就行 比如：userId: "1234" and status: 200
精确匹配：双引号内的内容为精确匹配
转义：使用反斜杠\ 比如：content: "select \* from users"

需要转移字符：
- * （代表任意）
- ? 代表任意一个
- " 双引号
- > / < 比较（没有=号)

不需要转义
- ` 反引号
- = 等号


举例：content : "SELEcT \* FROM `t_df_group` WHERE `Id`  = 1121875451115999232" and userid: "627951499565076480" 
```