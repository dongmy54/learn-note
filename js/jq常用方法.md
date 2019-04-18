#### 常用方法

##### 取值
```jquery
$(this).val();
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