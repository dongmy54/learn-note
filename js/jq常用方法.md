#### 常用方法

##### 取值
1. `$(this).val();` 取值
2. `$(this).html();` 取html
3. `$(this).text();` 取/存标签文本内容
4. `$("#property_submit").parent().parent()[0].id;` 获取id值
5. `$("#create_project").attr('action');` 取属性（`"/ancient/projects/91"`）
6. `$("#create_project").prop('action');` 和上类似(`"http://localhost:3000/ancient/projects/91"`)
7. `$('input[name="columns[]"]').attr('checked', true);` 选中
8. `$("#session_type").val('1')` select选项可选中值

##### 判断
```js
// isEmpty 是否为空
isEmpty("ds")
// false
isEmpty(" ")
// true

typeof('sdf');
// 'string'

// 是否包含类
$("#project_purchase_department_name").hasClass('hu');
// false

// 是否选中
$('input[name=all_check_box').is(':checked');
```

#### 阻止默认行为
```js
$(".form_submit").click(function(e){
  e.preventDefault();
}
```

##### 解析
```js
// 解析
$.parseJSON('{"json_class": "Department"}');
// {json_class: "Department"}
```

##### 去除字符串首尾空格
```js
"   sdafs 我 是 adf dsfs  ".replace(/^\s*|\s*$/g,"");
// "sdafs 我 是 adf dsfs"
```

##### 循环
```js
// 合同确认时间倒计时
  $(".contract_confirm_expired_time").each(function(){
    console.log(1); // 里面用 $(this)获取当前元素
  });

// each循环
$.each([ 52, 97 ], function( index, value ) {
  alert( index + ": " + value );
});

// forEach
var data = [{'id': 1,'name': 'zs'},{'id': 2, 'name': 'hubar'}]
data.forEach(function(element){
  console.log(element.id + element.name);
})
```

##### 数据缓存
```js
$( "body" ).data( "foo", 52 );
$( "body" ).data( "bar", { isManual: true } );
$( "body" ).data( { baz: [ 1, 2, 3 ] } );
$( "body" ).data(); // { foo: 52, bar: { isManual: true }, baz: [ 1, 2, 3 ] }
```

##### 重定向页面
```js
window.location.href = "/companies/new?category_ids=" + ids.join(',');
```

##### 读取cookie
```js
document.cookie
```

#### localStorage
> 本地存储
```js
localStorage.setItem("name","Amy")
localStorage.name
// 'Amy'
```

##### 下拉框值改变
```html
<p>Car:
  <select class="field" name="cars">
    <option value="volvo">Volvo</option>
    <option value="saab">Saab</option>
    <option value="fiat">Fiat</option>
    <option value="audi">Audi</option>
  </select>
</p>

<script type="text/javascript">
$(document).ready(function(){
  $(".field").change(function(){
    $(this).css("background-color","#FFFFCC");
  });
});
```