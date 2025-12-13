## type 类型定义
### 1. interface
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

### 2. type
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


