#### parameter

##### 函数中参数并不强制
```js
function hu(a, b){
  console.log(a);
  console.log(b);
}

hu();
// undefined
// undefined
// undefined
```

##### 参数默认值
```js
function hu(a = 1, b = 3){
  console.log(a);
  console.log(b);
}

hu();
// 1
// 3
// undefined
```
