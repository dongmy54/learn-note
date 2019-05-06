#### 常用方法

##### 取值
1. `$(this).val();` 取值
2. `$(this).html();` 取html
3. `$(this).text();` 取/存标签文本内容

##### each 循环
```js
// 合同确认时间倒计时
  $(".contract_confirm_expired_time").each(function(){
    console.log(1);
  });
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