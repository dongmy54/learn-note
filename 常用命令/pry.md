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

>断点
- `break 4`   第四行加断点,运行过程中加   

> 检查
- `ls`          列出所有信息(方法/常量/私有变量/实例变量...)
- `ls -c`       常量
- `ls -l`       局部变量
- `ls -i`       实例变量
- `ls -m`       方法
- `ls -m --grep current` 过滤出某方法

> 查看代码
- `show-source`                  切到某类下,展示类文件
- `show-source BetEvent`         展示某个类源码
- `show-source current_event`    切到某类上，展示方法源码

> 查找方法
- `find-method current_event`              如果不在某个作用域中，最好不要这样查，很费时间
- `find-method current_event BetEvent`     在BetEvent中找 current_event 方法
- `find-method -c current_event BetEvent`  查找方法,并显示被调用位置

> 切上下文
- `cd`            切出当前目录            
- `cd User`       切类
- `cd User.first` 切实例

>退出
- `exit`
- `finish`
- `!!!` 等价于 `exit-all` 暴力退出

>深层调用切换
- `up 2` 向上切两层(用于一个方法，调用另一个方法，另一个方法又调用另外的方法)
- `down 2` 向下调两层（一般`step`步进到深入层)

>编辑
- `edit spec/models/bet_event_spec.rb`        编辑文件（ctrl + x、Y、enter)
- `edit spec/models/bet_event_spec.rb:10`     编辑文件指定行数

















