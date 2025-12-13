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
