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

##### 宣告立即执行
> 用于一些需要同步执行的场合
```js
(function(){
  console.log(1);
})();
```

###### 箭头函数
> 1. 写法更简洁
> 2. 自动绑定外层this对象
> 3. 常用于回调

```js
var elements = [
  'Hydrogen',
  'Helium',
  'Lithium',
  'Beryllium'
];

// 常规写法
elements.map(function(element) { 
  return element.length; 
}); 

// 用箭头函数写法
elements.map((element) => {
  return element.length;
});

// 还可以进一步精简
elements.map(element => elements.length);
```
