## typescript 开发搭建

### 1. pnpm方式
`mkdir my-ts`
`cd my-ts`
```shell
pnpm init            # 创建 package.json 文件

# 安装依赖
pnpm add -D typescript # ts 做为开发以来安装（创建node-modules和pnpm-lock.yaml)
pnpm add -D ts-node # ts-node: 直接运行 TypeScript 文件
pnpm add -D @types/node # 解决看不到node类型定义的问题推荐

pnpm exec tsc --init  # 创建tsconfig.json

mkdir src # 源码目录
touch src/index.ts # 代码文件
# 然后 在里面写入
# console.log("Hello, TypeScript with pnpm!");
```

在`package.json`的`scripts`中添加`start`命令
```json
"scripts": {
    "start": "ts-node src/index.ts",
     //...
  },
```
然后命令行可以执行`pnpm start看输出了`
> 当然，直接执行`pnpm ts-node src/index.ts`也是可以的啦。


### 2. tsc
```shell
# 1. 初始化ts项目，生成tsconfig.json
tsc --init 

# 只做类型检查 不生成js文件
tsc --noEmit

# 读取tsconfig.json 生成 .js和.d.ts文件（一堆文件）
tsc

# 文件变动自动检查编译
tsc --watch

# PS：注意tsc的作用主要是做类型检查和编译（它是编译器），无法运行js/ts文件
# 而bun可以直接运行
```

### 3. tsconfig.json的作用
编译配置说明书，解决：
1. 要编译哪些文件，不编译哪些（include/exclude）
2. 类型检查严格程度（strict）
3. 按什么标准编译出文件（target）
