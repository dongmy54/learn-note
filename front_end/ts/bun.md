### bun
它是一种新兴的js工具，具有启动快、性能好的非常多的优点。可以用它直接运行ts.

它集运行时、包管理、测试、打包为一体，总体还是非常方便。


- `bun run hello_world.js`可以直接运行ts文件（等效于编译成 ts -> js -> run）
- `bun build hello_world.ts --outdir ./` 把ts文件编译成js文件
- `bun hello_world.js` 直接运行js文件
- `bun build hello_world.ts --compile --outfile hw` 把ts文件编译成可执行文件，非常好啊
- `bun add -d typescript` 可以用bun 安装typescript
- `bun install -g typescript` 可以用bun 全局安装typescript


- `bunx tsc hello_world.ts` bunx是调用工具（非自己的，比如这里的tsc）,这里实际是使用bunx去找tsc然后使用tsc把hello_world.ts编译成js文件


正常操作
```bash
bun init # 初始化项目（使用bun init后就不用tsc --init）
bun add jquery # 添加依赖
bun run file.ts # 运行ts文件
```

注意：`bun run xx.ts` 默认情况下会先进行类型检查，但是有时候虽然类型不符合要求，但是并不会报错哦（感觉比较宽松），使用`tsc --noEmit`会报错

