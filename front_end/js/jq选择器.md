### jq 选择器指南
#### 调试
> 确保成功命中目标元素 google浏览器 console中输入**选择器**,执行如下图：

![Snip20180603_1.png](https://i.loli.net/2018/06/03/5b132aea2c847.png)

---

![Snip20180603_2.png](https://i.loli.net/2018/06/03/5b132aea82bf4.png)
#### 1.基本选择器
样式               |说明                    | 其它|
------------------|------------------------|-----|
$("#first")       | id为first的元素     |
$(".first")       | 所有类为first的元素  |
$("p")            | 所有p标签的元素      |
$("input")        | 标签为input的元素    |PS: $(":input") 会同时选择 标签为input button select 等其它元素

#### 2.层次选择器
样式               | 说明                   | 其它|
------------------|------------------------|-----|
$("#first input") | id为first的元素 里面的所有input标签           |PS: 中间空格 表示：里面的东东|
$("input#first.hu")| 同时满足1、input标签；2、id为first;3、类名是hu|PS: 无空格 表示：同时满足|
$("input,p,button") |标签为input 或 p 或 button                  |PS: 逗号 表示: 多选|
$("#first > span")| 父元素id是first的span元素                     |PS: > 属于严格限定，父子之间的关系|
$("#first + span")| id为first的元素 它后面的 第一个span元素        |PS：等同于 $("#first").next();一定要记住是它后面|
$("#hu").next()   | id为hu的下一个同胞元素|                       ||
$("#hu").prev()   | id为hu的上一个同胞元素|                       ||
$("#hu").prev(".bar")| id为hu的上一个同胞元素并且类是bar||
$("#hu").prev().prev()|id为hu的上一个同胞元素的上一个同胞元素||
$("#hu").prevAll()| id为hu的前面所有同胞元素|                       ||
$("#hu").parent() | id为hu的父元素       |                       ||
$("#hu").children()| id为hu的所有子元素   |                       || 



#### 3.属性选择器
样式               | 说明                   |其它|
------------------|------------------------|----|
$("input[name=radio1]")          | name 属性等于 radio1的 input标签         |PS：属性名称是不用带引号的
$("#first input[name=radio1]")   |id为first里 name属性等于 radio1的 input标签|
$("input[type=checkbox]")        |type 属性等于 checkbox的 input标签         |
$("input[type=checkbox]:checked")|type 属性 checkbox 且选中                 |
$("button[name=export][type=submit] ")| 同时满足name=export、type=submit的button标签|

#### 4.批量选择器
样式               | 说明                   |其它|
------------------|------------------------|----|
$('[id*="default-config"')    | id 中包含default-config|


#### 5.组合选择
样式               | 说明                   |其它|
------------------|------------------------|----|
$(".query:button")| button中类是query|

#### 6.组合选择
样式               | 说明                   |其它|
------------------|------------------------|----|
$(this).closest('.sr_form_box')| 当前元素递归祖先元素中类为 sr_form_box的元素|


##### 使用
```ruby
$("[id^=value_object-parent-id]:eq(2) option:selected").text();
# 1. [id^= xx] 以value_object-parent-id 开头的id
# 2. :eq(2) 选取索引为2
# 3. option 下面的option
# 4. selected 选中的

$("[id$='_mof_code'")         id 以_mof_code结尾的
$("input[id$=_name][id*=items_attributes]")  1. input标签 id以_name结尾 id包含items_attributes的组合
```






