## git 命令汇集
>流程：文件未追踪 -> 文件被追踪 -> 文件进暂存区（git add.) -> 文件进版本库/分支（git commit)
- 冲突： 只有同时修改同一文件 同一位置时会产生
- 合并时打开编辑器： 会出现在A 分支上切 B分支后，A分支又做了修改，当要把B分支改动内容合并A时会出现。


```
Host github.com
    Hostname ssh.github.com
    Port 20

连接恢复
ssh -T git@github.com
```

```
git init              git初始化（会在当前目录产生.git文件 ）
rm -rf .git           移除所有git 数据

git add 文件/.        1、追踪文件 2、将文件添加进暂存区

git reset 将git add .中所有文件退出来
git reset 文件1 文件二 仅将文件从暂存区中撤离出来

git commit  -m "xx"   将文件提交到版本库
git commit -am  "xx"  等同于 git add + git commit -m 一步到位(PS：新文件不受影响)

git status             当前分支状态
git branch -a          当前本地 和 远端具有的所有分支
git branch -m new_name 修改当前分支名称

git diff                                                 当前修改 与 暂存区间不同 也就是git add之前
git diff HEAD                                            当前修改 与 最新commit（HEAD)不同 也就是git add之后
git diff brand1 brand2 app/controllers/xx_controller.rb  显示不同分支中同一文件差异

git log          查看提交日志
git log -p       查看提交日志 并 展示修改信息 
git log --graph  查看提交日志 并 图形展示合并流程

git reflog       查看过去所有git操作

git stash        将改变暂时存在git剪贴板（ps:确保修改全部处于 git add .状态)
git stash pop    恢复之前的临时存储

git remote update origin --prune           更新远端分支名称
git checkout -b xx-branch                  在当前分支的基础上创建分支
git checkout -b xx-branch develop          在develop分支上创建分支
git checkout -b xx-branch origin/develop   在远端develop分支上创建分支

git checkout -   切换到上一个分支
git checkout .   当前所有修改全部放弃

git checkout test --        消除歧义（切换到test分支）
git checkout -- test        消除歧义（恢复test文件内容到commit版本 -- 等于当前分支）
git checkout 0317198a2b48045b9f7c2423b5397594d3e53848 test 和上等价（此时用 commit id)

git branch --set-upstream develop origin/develop  本地develop 与 远端develop 做关联
git branch -m new_branch_name                     修改本地分支名
git branch -m old_branch_name new_branch_name     改分支名称


git cherry-pick 76b53de95710166d6f58951d26298e058fa734e6 挑选commit合并到当前分支
                                                         PS: 1. 将其它分支的commit合并过来、带commit 信息
                                                             2. git cherry-pick a b 中间空格一次合多个
当上面出现失败要求带上-m参数时
git cherry-pick xxx -m 1 - 以当前分支为主线（合并过来的内容较少，不会带无关的内容）
git cherry-pick xxx -m 2 - 以其它分支为主（合并内容较多，比较杂乱）
==========================================远端=========================================

git remote -v                                远端机信息

git remote add origin github仓库网址/ssh地址   添加远端连接

git remote remove origin                     删除远端连接

git clone  克隆远端仓库ssh/网址 
git clone address new_folder_name            克隆并命名文件夹名称
1、默认分支为master 
2、自动建立本地分支与远端上游upstream

git clone -b 分支 克隆远端仓库ssh/网址          指定克隆分支

git push -u origin master  
1、推master到远端 
2、指定上游（upstream)与本地关联 
3、以后可直接 git push/git pull

git pull                               推分支到远端

git fetch --all                        获取远端所有分支
git fetch origin master                获取远端master 到本地
git merge origin/master                合并origin/master 到当前分支

git branch -a                          查看当前所有分支（本地 和 远端的）

git checkout -b develop origin/develop 以远端develop来创建本地develop分支


==========================================修改=========================================

git commit --amend                 修改上一次commit信息 会打开编辑器

git reset --hard HEAD^              回滚到上一个commit
git reset --hard 哈希id(7位/所有位)   回到某个commit时间点

git rebase -i HEAD~3               合并最近三个commit为一个（会打开编辑器，s-保留commit信息,f-不要commit信息）
                                   仅适用于本地commit
                                   PS: 1、合并几个commit对应几行
                                       2、除第一行外,其它行命令全部改成s(保留commit信息) 如果改成f则弃用（可省略第4步）
                                       3、wq保存
                                       4、修改commit 信息，
                                       5、wq离开

git push origin xx-branch --force  (在本地分支commit回退，落后于远端分支时仍可推)
                                    实用于已将错误内容推到github,本地回到前一个commit,强推
                                    
==========================================不常用=========================================

git remote add upstream  仓库地址    添加远端upstream（用于fork别人项目，同步源仓库情况）
git rm xxx文件                      从暂存区中删除某文件（对实际文件不做影响,有时需要用-f）

rm -rf .git-credential-cache       解决仓库存在、账号正确却提示仓库不存在的问题


# 批量删除远程分支
git branch -r | grep  'fixbug' | sed 's/origin\///g' | xargs -I {} git push origin :{}
```

##### 如何添加一个空目录到git
> PS: 空目录是不会被追加的

方法：
> 在目录下创建 `.gitnogre`文件,内容如下:
```git
# 忽略所有文件
*
# 除了 忽略文件自己
!.gitignore
```

##### 关于忽略目录的写法
> 1. `vendor/emall_interface`、`vendor/emall_interface/`、`/vendor/emall_interface/*` 在使用效果（版本提交）是等效的
> 2. 如果是忽略目录下所有文件建议写成 `vendor/emall_interface/*`

##### 关于复制子项目导致的dirty解决方案
> 1. 方案一: `cp -a xx/project/* other_dir/` 将子项目下所有内容复制到新目录下
> 2. 方案二：`git status --ignore-submodules=dirty`






