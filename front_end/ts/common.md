## 常识
1. `index.ts`和`index.tsx`区别，
    - ts是标准的typescript文件
    - tsx是混合了html的typescript文件
2. `bun add -d typescript` 安装是项目本地安装 `-g` 是全局安装
3. `bun add xxx`和`bun install`区别
    - `bun add xxx`是安装xxx包（会更新依赖包内容）
    - `bun install`是安装package.json中的依赖


4. 如何让`.js`立即获得静态检查能力，文件顶部添加`@ts-check`
```js
// @ts-check
// JavaScript file
function compact(arr) {
    if (orr.length > 10) // 拼写错误：应该是 arr
        return arr;
}
```

5. `let`、`const`、`var`区别
- `const` 常量不用过多解释
- `let`和`var`都是变量
- `let`是块级作用域，`var`是函数作用域
```js
console.log(a);  // 不报错 undefined
var a = "sdaf";

console.log(b);  // 报错 ReferenceError: Cannot access 'b' before initialization.  的作用域还没到这里
let b = "hello";
```
除非老项目，变量都用let

6. 注意在ts中函数是写`function`而非`func`
7. 变量接`冒号`（a: number）

