## class
解决面向对象的问题而产生的。

### 一、传统的js
```ts
// 每个user都要这样写一遍 很累啊
const user = {
  name: "Tom",
  age: 18,
  sayHi() {
    console.log("Hi, I'm " + this.name);
  }
};


user.sayHi();
```

### 二、ES6的class
ES6引入了class语法，让面向对象编程更加直观和简洁。

```ts
class User {
  // 属性
  name: string;
  age: number;

  // 构造器
  constructor(name: string, age: number) {
    // 内部通过this使用
    this.name = name;
    this.age = age;
  }

  // 函数
  sayHi() {
    console.log("Hi, I'm " + this.name);
  }
}

// 通过 new 类名创建
const user = new User("Tom", 18);
user.sayHi();

user.name = "sdadsaf"
console.log(user.name)
```

也可以简写属性和构造器写一起
```ts
class User {
  constructor(
    public name: string,
    private age: number
  ) {}

  getAge() {
    return this.age
  }
}

let u = new User("tome", 23);
console.log(u.getAge());
```

### 三、private/public
```ts
class User {
  // 默认是public
  // private 私有外部不可用
  private age: number
  name: string

  constructor(name: string, age: number) {
    this.name = name
    this.age = age
  }

  sayHi() {
    console.log("Hi, I'm " + this.name)
  }
}

let u: User = new User("Tom", 18);
u.sayHi();
console.log(u.age); // age是私有属性
```

### 四、只读
```ts
class Order {
  constructor(
    // readonly 仅读
    public readonly id: string,
    private readonly amount: number
  ) {}

  print() {
    console.log(this.id, this.amount)
  }
}

const o = new Order("A001", 100)

o.print()
o.id = "A002" // 不能改
```

### 五、继承extends + protected
protected 保证子类内部可访问,外部无法直接访问
```ts
class User {
  constructor(
    public readonly name: string,
    protected age: number // 继承中可访问
  ) {}

  getAge() {
    return this.age
  }
}

// extends User继承
class AdminUser extends User {
  constructor(name: string, age: number) {
    // 调用继承的构造器
    super(name, age)
  }

  printAge() {
    console.log(this.age) // 调用上层父类User中age 
  }
}


let u: AdminUser = new AdminUser("tom", 23);
u.printAge()
```


### 六、抽象类
1. 抽象类主要用于定义要实现的抽象方法
2. 抽象类不用用来实例化

```ts
// Pay抽象类
abstract class Pay {
  // 定义子类需要实现的抽象方法
  abstract pay(amount: number): void

  log(amount: number) {
    console.log("pay:", amount)
  }
}


class WechatPay extends Pay {
  // 实现抽象类型方法
  pay(amount: number) {
    this.log(amount)
    console.log("wechat pay success")
  }
}

let p: Pay = new WechatPay();
p.pay(100);
p.log(2300)

// 抽象类
// let p1: Pay = Pay() 
// Value of type 'typeof Pay' is not callable. Did you mean to include 'new'?
```

