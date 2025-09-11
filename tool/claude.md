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
    "ANTHROPIC_MODEL": "kimi-k2-0905-preview",
    "API_TIMEOUT_MS": "600000"
  }
}
```
- `claude` 进入
- `/status` 查看模型



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
| `/sessions`        | 列出所有本地会话，可**回滚**到任意节点。                    |
| `/review`          | 让 AI 对当前 **PR diff** 做代码审查。               |
| `/mcp`             | 管理 MCP 服务器（如 WebSearch、Excel、Playwright）。 |
| `/exit` 或 `Ctrl+C` | 退出交互。                                     |

`claude commit` 一键提交
`claude -c` 上下文还在，无需重复解释需求


使用go语言开发，实现一个分布式场景下的singlefight（go语言的singlefight只在单独的进程内有效），搭配redis实现，要求：
1. 实现一个完成功能包，使用时，直接导入即可使用
2. 需要包含完整基础测试，redis连接本地就行
3. 使用时支持singlefight使用的key，超时时间、缓存时间等信息



1. 界面回复用中
2. 设置调用频率


