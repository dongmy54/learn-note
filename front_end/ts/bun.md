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
