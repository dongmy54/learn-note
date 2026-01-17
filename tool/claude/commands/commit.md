---
description: 一键提交：自动 stage、生成规范 commit message 并 push
argument-hint:
---

## 任务目标
根据 git diff 生成一条英文 Conventional Commits 提交信息并提交+推送


## 步骤
1. 执行 `git add .`",
2. 执行 `git diff --cached --no-color` 拿到待提交内容",
3. 依据 diff 内容，按如下规则生成一条**英文**提交信息：",
   - 格式：`<type>: <subject>`（全部小写，subject 不超过 50 字符）",
   - type 只选其一：feat / fix / docs / style / refactor / test / chore",
   - 不要正文，不要引号，不要句号结尾",
4. 用生成的信息执行 `git commit -m \"<generated message>\"`",
5. 执行 `git push` 推送到当前跟踪分支（如果配置了远程仓库）"

### 注意事项
1. 如果是新项目，需要先初始化 git 仓库
2. 如果当前没有配置远程仓库，则无需执行 `git push`
3. 撰写提交信息时，不要包含任何claude code相关的信息