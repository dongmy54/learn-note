### claude

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
PS: 修改完配置后重启`ccr code restart`,不生效的话，手动干掉进程然后重启
`lsof -i :3456`查进程id
`ccr code`直接使用

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

#### 5. 权限
~/.claude/settings.json
```json
{
  "permissions": {
    "allow": [
      /* ------- 文件操作 ------- */
      "Edit",
      "FileWrite",
      "FileDelete",

      /* ------- Git 全家桶 ------- */
      "Bash(git *)",
      "Bash(git-commit:*)",
      "Bash(git-push:*)",
      "Bash(git-pull:*)",
      "Bash(git-fetch:*)",
      "Bash(git-checkout:*)",
      "Bash(git-branch:*)",
      "Bash(git-merge:*)",
      "Bash(git-rebase:*)",
      "Bash(git-reset:*)",
      "Bash(git-stash:*)",
      "Bash(git-status)",
      "Bash(git-log)",

      /* ------- Node / JS 生态 ------- */
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Bash(node *)",
      "Bash(bun *)",

      /* ------- Python 生态 ------- */
      "Bash(python *)",
      "Bash(python3 *)",
      "Bash(pip *)",
      "Bash(pip3 *)",
      "Bash(poetry *)",
      "Bash(pdm *)",
      "Bash(conda *)",

      /* ------- Go 生态 ------- */
      "Bash(go *)",
      "Bash(gofmt *)",
      "Bash(goimports *)",

      /* ------- Rust 生态 ------- */
      "Bash(cargo *)",
      "Bash(rustfmt *)",
      "Bash(clippy *)",

      /* ------- Java / Kotlin ------- */
      "Bash(mvn *)",
      "Bash(gradle *)",
      "Bash(kotlinc *)",

      /* ------- C/C++ ------- */
      "Bash(make *)",
      "Bash(cmake *)",
      "Bash(g++ *)",
      "Bash(gcc *)",
      "Bash(clang *)",
      "Bash(clang-format *)",
      "Bash(clang-tidy *)",

      /* ------- Docker / K8s ------- */
      "Bash(docker *)",
      "Bash(docker-compose *)",
      "Bash(kubectl *)",

      /* ------- 代码格式化 / 检查 ------- */
      "Bash(prettier *)",
      "Bash(eslint *)",
      "Bash(black *)",
      "Bash(flake8 *)",
      "Bash(mypy *)",
      "Bash(ruff *)",
      "Bash(shellcheck *)",
      "Bash(shfmt *)",

      /* ------- 测试 ------- */
      "Bash(npm run test)",
      "Bash(npm run test:*)",
      "Bash(python -m pytest)",
      "Bash(pytest)",
      "Bash(cargo test)",
      "Bash(go test)",
      "Bash(mvn test)",
      "Bash(gradle test)",

      /* ------- 构建 / 发布 ------- */
      "Bash(npm run build)",
      "Bash(npm run build:*)",
      "Bash(pnpm build)",
      "Bash(yarn build)",
      "Bash(make build)",
      "Bash(cargo build)",
      "Bash(go build)",

      /* ------- 网络拉文档 ------- */
      "WebFetch(*)"
    ],

    /* 同会话内后续编辑不再弹窗 */
    "defaultMode": "acceptEdits"
  }
}
```

使用go语言开发，实现一个分布式场景下的singlefight（go语言的singlefight只在单独的进程内有效），搭配redis实现，要求：
1. 实现一个完成功能包，使用时，直接导入即可使用
2. 需要包含完整集成测试，redis连接本地就行
3. 使用时支持singlefight使用的key，超时时间、缓存时间等信息



1. 界面回复用中
2. 设置调用频率


