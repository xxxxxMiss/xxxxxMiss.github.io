---
title: git进阶（一）
date: 2017-08-20 14:56:16
tags:
    - git
categories:
    - git
---

## .git文件一览

```
├── COMMIT_EDITMSG
├── FETCH_HEAD
├── HEAD // 保存了当前分支的引用, 该引用指向refs/heads下对应的文件
├── ORIG_HEAD
├── branches
├── config // 当前选项的配置文件
├── description
├── hooks // git相关钩子
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── prepare-commit-msg.sample
│   └── update.sample
├── index // index区（暂存区）
├── info
│   └── exclude // 配置.gitignore相关
├── logs // 日志
│   ├── HEAD
│   └── refs
│       ├── heads
│       │   ├── dev
│       │   ├── feat
│       │   ├── master
│       │   ├── revert
│       │   └── test
│       └── remotes
│           └── origin
│               ├── HEAD
│               ├── dev
│               ├── master
│               ├── severfix
│               └── test
├── objects // 每个提交的记录
│   ├── 00
│   │   └── 0c30b7f4429c3d4c3ad782cc051798724b66f7
│   ├── 01
│   │   ├── 143716b369d9720651644bf6ad8543d3c9ff64
│   │   └── 2c1fbd55bee496631593d14814c2370f61e64a
│   ├── info
│   └── pack
│       ├── pack-edc94ec3aa0349b77e3e1b8264644068e4118389.idx
│       └── pack-edc94ec3aa0349b77e3e1b8264644068e4118389.pack
├── packed-refs
└── refs
    ├── heads // 本地各个分支最新提交
    │   ├── dev
    │   ├── feat
    │   ├── master
    │   ├── revert
    │   └── test
    ├── remotes
    │   └── origin //保存了远程分支最新提交
    │       ├── HEAD
    │       ├── dev
    │       ├── master
    │       ├── severfix
    │       └── test
    └── tags
```

{% asset_img git-plumbing-commit-tree.png git底层分支树 %}

## 远程分支
### 远程引用

> 远程引用（指针）是对远程仓库的引用
`git remote show origin`

### 远程分支

> 远程跟踪分支是远程分支状态的引用, 他们是你不能移动的本地引用。
> 已(remote)/(branch)

`git branch -a`


### 跟踪分支（上游分支）

> 本地分支关联远程分支。做了关联之后，就可以简化很多命令，比如`git pull`, git能自动的识别去哪个服务器上抓取，合并到哪个分支。

```
git checkout -b [branch] [remotename]/[branch]

git checkout --track origin/master(快捷方式)

```

> 为已有的分支设置上游分支

```
git branch -u origin/master
git branch --set-upstream-to=origin/master
```

> 查看本地分支是否设置了上游分支，与上游分支领先落后以及最后一次提交等信息

```
git branch -vv
```

> 取消上游分支

```
git branch --unset-upstream
```

## 重写历史

### 修改最近一次的提交信息

```
git commit --amend
```

> 如果你已经使用上述命令完成了最近一次提交信息的修改，又因为之前提交时忘记添加一个新创建的文件，想通过添加或修改文件来更改提交的快照，也可以通过类似的操作来完成。

```
git add || git rm
git commit --amend
```

### 修改多个提交信息。
> 如果要修改多个提交信息，可以通过交互式变基来实现。
> 这是一个变基命令: 在 HEAD~3..HEAD 范围内的每一个提交都会被重写，无论你是否修改信息。

```
git rebase -i HEAD~3
```

Note: 需要注意的是，rebase命令会将你带入文本编辑模式，这个文本编辑模式中所列出来的提交列表和使用`git log`列出来的提交是相反的。rebase:从旧到新，log:从新到旧

假设我们进入编辑模式是这样的：
```
pick f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file

# Rebase 710f0f8..a5f4a0d onto 710f0f8
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

> 假设我们只修改第一次的提交信息（也就是最上面的那一条），那么我们可以将最上面的那一条信息前面的`pick`改为`edit`或者`e`,保存退出。

退出保存，终端会显示如下的信息:

```
Stopped at 3d8f8dbe792fb8ec971d697470ec8bfd0ce0f8d6... delete 4 5 7 rows
You can amend the commit now, with

    git commit --amend

Once you are satisfied with your changes, run

    git rebase --continue
```

注意：此次HEAD指针已经移动到了`3d8f8db`这一次的提交，那么我们可以继续运行
```
git commit --amend // 修改第一次的提交
git rebase --continue // 将HEAD指针在移动回最近的那次提交

// 上述2个命令执行完成后，终端会显示如下信息
Successfully rebased and updated refs/heads/test.
```

### 压缩提交
> 如果多个提交都是完成一个功能的，我们可以将这些提交压缩成一个提交，使用的命令也是rebase。我们从上面的例子可以知道，一旦进入文本编辑模式，会有'pick', 'edit', 'squash', 'fixup'选项。如果我们要压缩多个提交，只需要将每条提交前面的'pick'改为'squash'(后面再讲解squash与fixup的区别)。

加入进入文本编辑模式如下
```
pick f7f3f6d changed my name a bit
pick 310154e updated README formatting and added blame
pick a5f4a0d added cat-file

# Rebase 710f0f8..a5f4a0d onto 710f0f8
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

> squash就是下面的提交记录压缩到前面的提交记录中（将几条提交记录整合到一起），但是需要注意的是，不能讲最上面的那一条提交记录前面的`pick`改为`squash`, 那样就没有**前一条记录了**。如果你真的将最上面的那一天提交记录也改为`squash`，那么在退出文本编辑模式的时候，会提示`Cannot 'squash' without a previous commit`。

那么squash后的log如下
```
commit 8406738ce7740d8800890b58bf3b6ee6aab23f3d
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 10:44:34 2017 +0800

    changed my name a bit
    updated README formatting and added blame
    added cat-file

commit 20559c2e26d7c8183c4ad73761d3e26c81de6af2
Author: chenxianlong <794465731@qq.com>
Date:   Sat Aug 19 16:56:24 2017 +0800

    test rebase configs
```

查看log信息可以squash将三条提交记录压缩为一条，但是如果你使用`fixup`选项，那么rebase后会丢掉每条被你标记为`fixup`的提交记录，这是他和`squash`的唯一区别。

使用`fixup`的log会看起来如下
```
commit 8406738ce7740d8800890b58bf3b6ee6aab23f3d
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 10:44:34 2017 +0800
    changed my name a bit

commit 20559c2e26d7c8183c4ad73761d3e26c81de6af2
Author: chenxianlong <794465731@qq.com>
Date:   Sat Aug 19 16:56:24 2017 +0800

    test rebase configs
```

## git中的三棵树（三个区）
> 平时我们使用`git add`,`git commit`, `git checkout`, `git reset`等这些命令来做git的一些操作，其实内部就是在操作这三个区域：

working: 工作区，平时文件的增删改都是在working区
index: 暂存区，使用`git add`将工作区的内容保存在暂存区，暂存区中的内容是即将要提交的内容
HEAD: 提交区，保存了当前分支最近的一次提交

{% asset_img git-three-tree.png git中的三棵树 %}


## reset压缩提交历史
> 有了上面三棵树的基础，那么了解reset工作的机理就比较清晰了。

reset 命令会以特定的顺序重写这三棵树，在你指定以下选项时停止：

1. 移动 HEAD 分支的指向 （若指定了 --soft，则到此停止）

2. 使索引看起来像 HEAD （若未指定 --hard，则到此停止）

3. 使工作目录看起来像索引

再来解析下上面1,2中括号中说明的含义

加入我们要修改前3次的提交
```
// 移动HEAD中的指针指向倒数第四次提交，此时修改的文件处于暂存区
// 也就是说加了--soft，会回退到git commit之前
git reset --soft HEAD~3

// 移动HEAD中的指针指向倒数第四次提交，此时修改的文件处于暂存区
// 更新暂存区，使工作区和暂存区看起来是一样的
// 也就是说不加--soft选项，回会退到git add之前
git reset HEAD~3

// --hard是个危险选项，会让你撤销所有的修改
git reset --hard HEAD~3
```


## reset重置路径
> 上面说的reset是针对提交历史的，我们也可以使用reset针对某个具体路径。
> 比如我们在使用`git add .`添加了所有的东西到暂存区，但是在提交的时候，发送有个文件或者文件夹中的东西不是当前功能的，那么可以通过reset来让文件或者文件集合回到工作区，只提交本次要提交的功能。
> 实际上，`git add`和`git reset`所做的事情是相反的，`git reset`本质是将HEAD区的中的文件拷贝到暂存区，并且不会移动HEAD中的分支指针。

```
On branch test
Your branch and 'origin/test' have diverged,
and have 4 and 15 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    modified:   test.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   test.txt
```

## 撤销合并之reset修改引用，revert还原
假设现在在一个特性分支上工作，不小心将其合并到 master 中，现在提交历史看起来是这样：
{% asset_img three-part-merge.png %}

对于上面的问题，有2种修复方法：

> 修改引用

如果这个不想要的合并提交只存在于你的本地仓库中，最简单且最好的解决方案是移动分支到你想要它指向的地方。 大多数情况下，如果你在错误的 `git merge` 后运行 `git reset --hard HEAD~`，这会重置分支指向所以它们看起来像这样：

{% asset_img reset-hard.png %}

这个方法的缺点是它会重写历史，在一个共享的仓库中这会造成问题的。 用简单的话说就是如果其他人已经有你将要重写的提交，你应当避免使用 reset。 如果有任何其他提交在合并之后创建了，那么这个方法也会无效；移动引用实际上会丢失那些改动。

> 还原提交

如果上面的修改引用的方法不适合你，那么你还可以使用还原操作。
```
// 1,表示需要保留下来的父节点，如下图，我们此处的父节点是C6或则C4，
// 因为我们此时在master分支上，所有保留下来的父节点是C6
git revert -m 1 HEAD
```
调用了上述命令之后，提交历史看起来是这样的：

{% asset_img reset-mainline-1.png %}

```
commit e5a5ab537309c2006676392d4fb5dc1ae2dae78e
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 17:14:20 2017 +0800

    Revert "Merge branch 'test revert in test branch'"

    This reverts commit 606de1d0d3d7313ca3c0914c65eb5f77ca97a48e, reversing
    changes made to 2ece042de65c693c709b3f9d34d7b598697984ff.

commit 606de1d0d3d7313ca3c0914c65eb5f77ca97a48e
Merge: 2ece042 d9a757b
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 17:10:16 2017 +0800

    Merge branch 'test revert in test branch'

commit d9a757b76f1e95c26bd116d18f03338c0e5920c0
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 17:10:10 2017 +0800

    revert 提交 in test branch

commit 2ece042de65c693c709b3f9d34d7b598697984ff
Merge: c7434ae 44ee440
Author: chenxianlong <794465731@qq.com>
Date:   Wed Aug 23 17:08:25 2017 +0800

    Merge branch 'feat add 9999 in feat branch'
```

该命令会生成一条新的提交，我们如果查看上面的log,可以看出第一天提交信息，其中明确的写明了`e5a5ab5`是在`606de1d`的基础上生成的新提交，并且将`2ece042`的提交还原了。


> 再来看看`git revert -m 1 HEAD`之后的历史

新的提交 ^M 与 C6 有完全一样的内容，所以从这儿开始就像合并从未发生过，但是如果你尝试再次合并 topic 到 master Git 会感到困惑：
```
$ git merge topic
Already up-to-date.
```

因为我们调用`git revert -m 1 HEAD`之后，已经将topic中提交剔除出去了，但是现在再来合并却发现并没有不一样的内容，也就是说我们无法再次将topic分支的提交合并到master.更糟的是，如果你在 topic 中增加工作然后再次合并，会产生冲突。

{% asset_img reset-merge.png %}

解决这个最好的方式是撤消还原原始的合并，因为现在你想要引入被还原出去的修改，然后 创建一个新的合并提交：
```
// revert ^M之后，又会产生一次新的提交^^M，这次新的提交包含了开始剔除出去的内容（C3,C4）
$ git revert ^M
[master 09f0126] Revert "Revert "Merge branch 'topic'""
$ git merge topic

// merge topic时，会将^^M，C7，C2做一个三方合并
```

{% asset_img reset-merge-2.png %}

> 在重新合并一个还原合并后的历史
在本例中，M 与 ^M 抵消了。 ^^M 事实上合并入了 C3 与 C4 的修改，C8 合并了 C7 的修改，所以现在 topic 已经完全被合并了。

所有遇到以上情况，我们需要做三步：
```
git revert -m -1 HEAD
git revert ^M
git merge topic
```

## reset与checkout的区别
> 因为checkout也是操纵这三棵树，所以有必要了解下他们之间的区别

{% asset_img reset-checkout.png reset和checkout区别对照表 %}

## 快速合并与三方合并策略

### 快速合并
我们在合并2个分支的时候，经常看到如下信息
```
Updating 44bc42f..a65dae0
Fast-forward
 test.txt | 13 -------------
 1 file changed, 13 deletions(-)
```

{% asset_img git-fast-forward.png 快速合并 %}

> 如果一个分支和它的源分支没有存在支路，如上图。
> 就是说iss53分支从master分支上切出来之后，并且在iss53上做了几次提交，但是在这期间master分支并未有新的提交合并，那么此时将iss53分支合并到master分支采用的就是`Fast-forward`策略。

### 三方合并策略
> 将几个分支的共同祖先节点和每个分支最后提交的节点进行一个合并。

我们在合并2个分支的时候，也会经常看到如下信息
```
Merge made by the 'recursive' strategy.
 test.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

{% asset_img three-part-merge.png git三方合并 %}

 > 如上图，topic分支从master分支C2切出来，然后做了C3,C4的提交，在此期间，master分支也有C5，C6的提交合并，那么此时将topic分支合并到master分支就会采用三方合并的策略。

## ours和theirs冲突合并策略
> 合并分支，偶有遇到冲突在所难免，git通常让你自己手动解决冲突后再进行一个合并。但是也提供了一些其他快速解决冲突的方案。

比如，2个人同时修改了某一个文件，那么在合并的时候就会遇到冲突，但是我只想保留某一方的提交。那么此时我们就可以使用ours和theirs策略。

如：将topic分支合并到master分支存在冲突
```
// 保留master分支上的代码
git merge -Xours topic

// 保留topic分支上的代码
git merge -Xtheirs topic
```

## git grep搜索
> 从提交历史或者工作目录中查找一个字符串或者正则表达式
`git grep -n fmtDate`


## 几个常用的底层命令
- git hash-object

> 将数据写入到git数据库中

- git cat-file

> 从git数据库中取出数据

- git update-index

> 将文件加入到暂存区或更新暂存区的文件

- git write-tree

> 将暂存区内容写入到一个树对象

- git read-tree

> 把树对象读入暂存区

- git commit-tree

> 创建一个提交对象

- git update-ref

> 更新某个引用

- git symbolic-ref HEAD

> 查看 HEAD 引用对应的值

- git symbolic-ref HEAD refs/heads/test

> 设置HEAD引用的值

## 几种常见的对象
- blob object: 数据对象
- tree object: 树对象
- commit object: 提交对象
- tag object: 标签对象，类似于提交对象，但是标签对象通常指向一个提交对象，而不是一个树对象

## 几个git文件的合法模式
- 100644: 普通文件
- 100755: 可执行文件
- 120000: 符号链接