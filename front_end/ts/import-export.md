## 导入导出

### 导出
`math.ts`
```ts
// math.ts
const PI = 3.14;

function add(a: number, b: number) {
  return a + b;
}

class Calculator {}

export { PI, add, Calculator }; // 批量导出


function log(message: string) {
  console.log(message);
}

export default log; // 默认导出（只能有一个，导出时默认导出它）
```


### 导入
`index.ts`
```ts
// 按需导出（注意这里是{})
import { add } from "./math.js"; 
console.log(add(2, 3));

// 导出时重命名
import { add as sum} from "./math.js";
console.log(sum(2, 3));

// 全部导出（必须给一个包名）
import * as math from "./math.js";
console.log(math.PI); // 使用时带上包名

// 导入默认（注意这里没有{}) 默认导出这里的log 你可以随便命名写lo也行
import log from "./math.js";
log("hello");
```


