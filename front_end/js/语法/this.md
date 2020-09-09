#### this
> - 代表上下文环境，可以简单理解为当前对象

> 1. 默认this代表，window
> 2. 函数呼叫 xxx_obj.xx_function() 此时 this 为 xxx_obj
> 3. 强制绑定 xx_function.bind(xx_obj)() 此时 this 为 xx_obj
> 4. new xx_function 此时会构造一个新的 this对象

##### 情况一
```js
var foo = function(){
  this.count++;
}

// 情况1 默认window
foo();
```

##### 情况二
```js
var getGender = function(){
  return this.gender;
}

var people1 = {
  gender: 'female',
  getGender: getGender
}

// 情况2 函数呼叫
people1.getGender();
// female
```

##### 情况三
```js
var obj = {
  x: 123
}

var func = function(){
  return this.x;
}

// 情况3 强制绑定this
func.bind(obj)();
// 123
```

##### 情况四
```js
var calNum = function(num){
  this.num = num; // new 函数名 构造this对象
}

var a = new calNum(100);

a.num // 100
```

