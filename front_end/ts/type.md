## type 类型定义
```ts
let a: string; // 仅仅类型
let a: number = 123; // 类型+值
```

### 1. 基础类型：
1. `string`
2. `number`
3. `null`/`undefined`
4. `boolean`

其它：
1. `any`：任意类型
```ts
let a; // 默认就是any
```

内置类型
```ts
// 定义一个布尔对象
let b: Boolean = new Boolean(1); 
// 定义一个错误对象
let e: Error = new Error('Error occurred'); 
// 定义一个日期对象
let d: Date = new Date(); 
// 定义一个正则表达式对象
let r: RegExp = /[a-z]/;

console.log(b, e, d, r);
```

### 2. 类型推断：
```ts
let message = "sdsda"; // 类型推断为string
message = 234; // 报错 因为试图分配number
```

### 3. 接口
用于定义一个对象应该有哪些属性
1. 普通
```ts
// 定义接口
interface User {
    name: string;
    age: number;
}

// 使用接口定义用户对象
const user: User = {
    name: "Alice",
    age: 30
};

// 接口的使用确保了对象结构的严格性
console.log(user.name); // 正常访问，无类型错误
```

2. 可选属性
```ts

interface Person {
    Name: string;
    Age: number;
    Birthday?: Date; // ?可选属性
}


let p: Person = {
    Name: "John",
    Age: 30
}
```

### 4. 联合类型
1. 可以同时是多种类型
```ts
let a: string | number;

a = "a"
a = 123;
```

2. 限定具体可以的值
```ts
// 只能是 a/b
type Result = "pass" | "fail"; 

// 定义一个函数，接受 Result 类型作为参数
function verify(result: Result) {
    if (result === "pass") {
        console.log("Verification Passed!");
    } else {
        console.log("Verification Failed!");
    } 
}

// 验证 1: 正确使用
verify("pass");
verify("fail");
```

### 5. 类型断言
```ts
function getid(id: string | number) {
    if (typeof id == "string") {  // typeof 类型断言
        let len = (id as string).length // 直接转类型
        console.log(len)
    }
}

getid("saf")
```


### 6. 数组
```ts
let a: number[] = []; // 注意要带上 = [];先初始化下，否则不能直接push哦；要不就多一步a = []
// let a: Array<number> = []; 等价写法，上面的更简洁，推荐使用


a.push(1);
a.push(2);
a.push(3);
console.log(a);
```
