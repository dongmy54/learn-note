#### function
> 创建函数主要有三种方式

##### 宣告式
> - 首推
> - (文件代码中)可以先调用 和定义
```js
square(3);

function square(number){
  return number * number;
}
```

##### 赋值给变量
```js
var square = function(number){
  return number * number;
}

square(3);
```

##### new Function
> 性能较差很少用
```js
var square = new Function('number', 'return number * number')
square(3);
```