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

8. `node_modules`目录是存放项目依赖的地方，
  由`xx install`根据package.json生成，因此不要把它提交到git仓库，
  应该在`.gitignore`中忽略该目录。

9. 包的引入，通过`import` `import $ from "jquery";`
10. 包的安装要注意
    - 是否包含xx.b.ts 如果已包含说明已支持ts类型，直接安装即可
    - 是否有@types/xxx包来提供类型定义，如果有则多安装下它，如果没有，那么自己就需要写类型申明了

11. `npm install @types/node --save-dev` 这里的`--save-dev`是保存到开发依赖

