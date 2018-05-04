## git 命令汇集
- 冲突： 只有同时修改同一文件 同一位置时会产生
- 合并时打开编辑器： 会出现在A 分支上切 B分支后，A分支又做了修改，当要把B分支改动内容合并A时会出现。

```
git init  git初始化（会在当前目录产生.git文件 ）

git add 文件/.  1、追踪文件 2、将文件添加进暂存区

git commit  -m "xx"  将文件提交到版本库
git commit -am  "xx"  等同于 git add + git commit -m 一步到位

git status  当前分支状态 

git diff  当前修改 与 暂存区间不同 也就是git add之前
git diff HEAD  当前修改 与 最新commit（HEAD)不同 也就是git add之后

git log  查看提交日志
git log -p  查看提交日志 并 展示修改信息 
git log --graph  查看提交日志 并 图形展示合并流程

git reflog  查看过去所有git操作

git remote -v  远端机信息

git push origin xx-branch --force  (在本地分支commit回退，落后于远端分支时仍可推)

git checkout -  切换到上一个分支

==========================================修改=========================================

git commit --amend  修改上一次commit信息 会打开编辑器

git reset --hard 哈希id(7位/所有位)  回到某个commit时间点

git rebase -i HEAD~2 合并最近两个commit为一个（会打开编辑器，最后一行用fixup替换pick 下面有命令说明）
```

