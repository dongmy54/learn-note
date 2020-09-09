#### object_oriented

##### 示例
```js
var car = function(location_x, location_y){
  // 位置
  this.location_x = location_x;
  this.location_y = location_y;

  // 前进
  this.advance = function(num){
    this.location_x += num;
    return this; // 目的便于级联调用方法
  }

  // 后退
  this.back = function(num){
    this.location_x -= num;
    return this;
  }

  // 向左
  this.left = function(num){
    this.location_y += num;
    return this;
  }

  // 向右
  this.right = function(num){
    this.location_y -= num;
    return this;
  }
}

var car1 = new car(0,0);

car1.advance(10).back(5); // 前进十米 后退5米

car1.location_x // 5

car1.left(30).right(10) // 左转30米 右转10米

car1.location_y // 20
```


