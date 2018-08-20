### pry 调试
#### 用法示例
```ruby
require 'pry'

class A
  def test(a,b)
    binding.pry    # 设置测试点
    puts a,b
  end
end

A.new.test('a','b')
```
#### 帮助
- `help`  (pry环境下) 
- `command -help` 单个命令帮助（如：ls -help)

#### 常用命令
> 流程
- `step`      单步(会进入每一个具体步骤 PS:看源码)
- `next`      单行
- `continue`  下一个断点/跳出（深入层）
- `exit`       退出

> 查看
- `ls`          列出所有信息(方法/常量/私有变量/实例变量...)
- `ls -c`       常量
- `ls -l`       局部变量
- `ls -i`       实例变量
- `ls -m`       方法
- `show-source` 查看代码

> 切上下文
- cd       可以切到某个类/模块下/变量（eg: cd A/B/C PS：另外如果是在某个对象上，可以直接运行对象方法)

