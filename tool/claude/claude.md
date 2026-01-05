### claude
https://www.claude-cn.org/

#### 1.对于本身就支持claude的模型
`npm install -g @anthropic-ai/claude-code`安装
配置后，不用每次都export
`~/.claude/settings.json`

https://mp.weixin.qq.com/s?__biz=MjM5Mzk1NzA1NA==&mid=2247486033&idx=1&sn=63aae68cc28d7cc22350bcd0cb2d5c55&poc_token=HKQgwGijl26KPaFskN9bNrWbGEkxBBE1fmEVUvzB
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "sk-9AIKMylL1CHdhWOb0OlHaxxxxx",
    "ANTHROPIC_MODEL": "kimi-k2-turbo-preview",
    "API_TIMEOUT_MS": "600000"
  }
}
```
- `claude` 进入
- `/status` 查看模型


如果不用配置文件，可以直接配置环境变量，比如：
```shell
export ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
export ANTHROPIC_AUTH_TOKEN="xxx"
```
也能生效


#### 2. 对于不支持的模型
采用`claude-code-router`转换
文档：https://github.com/musistudio/claude-code-router/blob/main/README_zh.md

- 1. 添加配置文件 
~/.claude-code-router/config.json
```json
{
  "LOG": true,
  "API_TIMEOUT_MS": 600000,
  "PROXY_URL": "http://127.0.0.1:7890", // 这个参数非常关键 有些模型对地区有限制
  "Providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "替换成你的key",
      "models": [
        "anthropic/claude-sonnet-4",
        "anthropic/claude-opus-4.1",
        "google/gemini-2.5-pro"
      ],
      "transformer": { "use": ["openrouter"] }
    }
  ],
  "Router": {
    // 注意这里写的是供应商名,模型名
    "default": "openrouter,anthropic/claude-sonnet-4",
    "background": "openrouter,anthropic/claude-opus-4.1",
    "think": "openrouter,google/gemini-2.5-pro",
    "longContext": "openrouter,google/gemini-2.5-pro"
  }
}
```
PS: 修改完配置后重启`ccr restart`
不生效的话,手动干掉进程然后重启
`lsof -i :3456`查进程id
`ccr code`直接使用

另外一种修改的方式: `ccr ui` 直接界面修改/添加/切换
另外需要注意的是，使用是要把原本正常的`~/.claude/settings.json`干掉否则不会生效。


#### 3. 常用命令
| 指令                 | 功能                                        |
| ------------------ | ----------------------------------------- |
| `/help`            | 列出所有内置命令。                                 |
| `/init`            | 生成 **CLAUDE.md** 项目记忆文件，后续对话自动加载。         |
| `/clear`           | 清空当前聊天历史，释放上下文窗口。                         |
| `/compact`         | 压缩历史，仅保留摘要，**长项目必用**，省 token。             |
| `/memory`          | 查看/编辑**持久化记忆**，跨会话生效。   项目下CLAUDE.md                  |
| `/model`           | 切换后端模型（如 claude-3.5-sonnet ↔ kimi-k2）。    |
| `/cost`            | 实时显示本次会话的 **token 花费 & 耗时**。              |
| `/doctor`          | 一键诊断安装、网络、key 是否正确。                       |
| `/add-dir <路径>`    | 把额外目录加入工作区，**多仓库**场景常用。                   |
| `/review`          | 让 AI 对当前 **PR diff** 做代码审查。               |
| `/mcp`             | 管理 MCP 服务器（如 WebSearch、Excel、Playwright）。 |
| `/exit` 或 `Ctrl+C` | 退出交互。                                     |

`claude commit` 一键提交
`claude -c` 上下文还在，无需重复解释需求


1. 配置全局规则
家目录 ~/.claude/CLAUDE.md

2. session上下文继续
/resume 手动选择，恢复哪一次session

3. 主题配置
/config 选择主题，然后退出重新进入生效

4. 代码回滚到指定检查点
/rewind

5. 压缩上下文，节省token
/compact

6. 清楚当前session的上下文
/clear 注意它是会话级别的，用于临时清理，不希望写进对话的内容
也可用于临时性的，终端cluade提问

7. 权限设置
/perssions 添加权限后，可以设置权限级别用户/项目级别

或者配置文件（~/.claude/settings.json）

8. 临时执行shell命令
进入cluade后，使用 !+命令方式，比如: !ls

9. 指定文件
@ 后会自动弹出文件供您选择

10. 一次性提问
`claude -p "go语言使用使用通道"`

11. 先把需求聊透，再编码
连续按下两次 shift + Tab 进入plan模式

12. 生成项目概览信息,后续辅助ai决策
/init 自动生成项目下的 .CLAUDE.md文件

13. vscode选中代码，终端感知
插件claude code for vscode即可

#### 4. mcp
`claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp`
`claude mcp add --transport sse brightdata "https://mcp.brightdata.com/sse?token=<your-api-token>" --scope user`
注意添加 `--scope user`全局使用
- chrome-devtools 其次

#### 5. 权限
~/.claude/settings.json
```json
{
  "permissions": {
    "allow": [
      "mcp__context7__resolve-library-id",
      "mcp__context7__get-library-docs",
      "Bash(go:*)",
      "WebSearch",
      "WebFetch",
      "WebFetch(domain:*.*)",
      "Bash(ls:*)",
      "Bash(pwd)",
      "Bash(cd:*)",
      "Bash(mkdir:*)",
      "Bash(rm:*)",
      "Bash(cp:*)",
      "Bash(mv:*)",
      "Bash(echo:*)",
      "Bash(cat:*)",
      "Bash(grep:*)",
      "Bash(which:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(git:*)",
      "Bash(brew:*)",
      "Bash(curl:*)",
      "Bash(env)",
      "Grep",
      "Glob",
      "Bash(make:*)"
    ],
    "deny": [
      "Bash(rm:*)",
      "Bash(dd:*)"
    ]
  },
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/Users/dmy/.claude/hooks/go-checks.sh"
          }
        ]
      }
    ]
  }
}
```
PS：
1. 一点注释不能加
2. 对于命令，最好去看它帮我加的是如何写的，避免编写错误；如果有语法错误，或者注释存在会导致配置不生效
3. 如何校验配置是否生效？进入交互后通过permissions命令查看(不用每次都退出后重新进入)
4. 对于hooks 中shell脚本,注意退出码（成功0 失败用2），如果写1不会看到且不处理


### 子代理
主要用于定义一个专属处理某个问题的角色，比如代码审查员，用于提高代码质量
配置在~/.claude/agents目录下

调用：
1. 在对话中明确使用 xx 子代理 做什么（显示触发）
2. 可以一次使用多个子代理，比如描述 先使用 xx 子代理，然后 使用 xx 子代理

特点：
1. 独立的上下文（它不会污染主会话，互不干扰）
2. 专注特定任务，比如做测试/代码审查
3. 一个子代理就是一个角色身份

PS: claude code自带的plan模式就是一个子代理

### 插件claude code for vscode
唯一一个注意点是，安装完后去配置下环境变量，cmd+,打开设置，搜索claude code,找到Environment Variables,配置参考
```json
"claudeCode.environmentVariables": [    
    {
        "name": "ANTHROPIC_BASE_URL",
        "value": "https://open.bigmodel.cn/api/anthropic"
    },
    {
        "name": "ANTHROPIC_AUTH_TOKEN",
        "value": "xxx"
    },
    {
        "name": "ANTHROPIC_MODEL",
        "value": "GLM-4.6"
    },
    {
        "name": "API_TIMEOUT_MS",
        "value": "600000"
    }
],
```



### 插件
插件市场 https://claudemarketplaces.com/
`/plugin marketplace add anthropics/claude-code` 添加官方插件市场
`/plugin install feature-dev ` 官方功能开发


