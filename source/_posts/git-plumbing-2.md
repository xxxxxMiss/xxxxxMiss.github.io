---
title: git进阶（二）
date: 2017-09-19 01:23:39
tags:
  - git
  - workflow
categories:
  - git
---

## git 配置文件的位置

- /etc/gitconfig
- ~/.gitconfig || \$XDG_CONFIG_HOME/git/config
- \$PWD/.git/config

## 查看 git 配置

> 对于配置选项的 CURD 操作，不指定--system,--global,--local 选项，
> CUD 默认都是--local 选项, R 操作查询所有的配置（相当于同时指定了三个选项）。

```
// 查看系统级别的所有配置
git config --system -l

// 查看全局的所有配置(默认查看global级别)
git config --global -l

// 查看当前仓库的配置
git config --local -l

// 查看具体某一项的配置
git config [--system|--global|--local] --get core.editor
// 默认查看local级别
git config --get core.editor
```

## 设置 git 配置

```
git config [--system|--global|--local] user.name "qsch"
```

## 删除某个配置

```
// 删除global级别的commit.template配置
git config --global --unset commit.template

// 删除local级别
git config --local --unset commit.template
// 或则
git config --unset commit.template
```

## commit.template

> 配置提交信息的模板。使用同一份模板，可以保持团队成员的提交信息风格保持一致。

比如你这样设置`git config commit.template ~/.gitmessage.txt`,
那么当你`git commit`的时候，会进入你设置的提交信息的模板编辑页面，修改保存，那么修改后的提交信息就是本次的提交信息。

## core.excludesfile

> global 级别的.gitignore。
> 一般每个项目下都会有.gitignore 文件，如果配置了 global 级别的.gitignore,那么对于所有的 git 仓库都会生效。
> 如：
> `git config core.excludesfile ~/.gitignore_global`

## core.autocrlf

> 用来处理各平台之间的换行符回车符之间的一致性问题

- 使用 linux 或者 mac,一般设置为`input`,那么在检出的时候，自动将`\r\n`转化为`\n`。
- 使用 windows，可以设置为`true`,那么在检出的时候，自动将`\n`转化为`\r\n`。
- 如果只在 windows 上开发，那么可以设置为`false`,关闭该功能。

## 使用 npm 安装你自己编写的脚本

## 常用命令

### git rm -r --cached /logs

> 该命令主要用在你之前已经提交了某个文件或者文件夹，但是后面想要忽略它，那么使用该命令之后，再在`.gitignore`中添加下需要忽略的文件，再次提交就可以了。

## .git 目录一览

```bash
.git
├── COMMIT_EDITMSG
├── FETCH_HEAD
├── HEAD # HEAD 文件指示目前被检出的分支
├── branches
├── config
├── description
├── hooks
│   ├── applypatch-msg
│   ├── applypatch-msg.sample
│   ├── commit-msg
│   ├── commit-msg.sample
│   ├── post-applypatch
│   ├── post-checkout
│   ├── post-commit
│   ├── post-merge
│   ├── post-receive
│   ├── post-rewrite
│   ├── post-update
│   ├── post-update.sample
│   ├── pre-applypatch
│   ├── pre-applypatch.sample
│   ├── pre-auto-gc
│   ├── pre-commit
│   ├── pre-commit.sample
│   ├── pre-push
│   ├── pre-push.sample
│   ├── pre-rebase
│   ├── pre-rebase.sample
│   ├── pre-receive
│   ├── pre-receive.sample
│   ├── prepare-commit-msg
│   ├── prepare-commit-msg.sample
│   ├── push-to-checkout
│   ├── sendemail-validate
│   ├── update
│   └── update.sample
├── index # index 文件保存暂存区信息
├── info
│   └── exclude
├── logs
│   ├── HEAD
│   └── refs
│       ├── heads
│       │   └── master
│       └── remotes
│           ├── ic
│           │   └── master
│           └── origin
│               ├── HEAD
│               └── master
├── objects # objects 目录存储所有数据内容
│   ├── 00
│   │   ├── 1944b907297391ac895a43ccb5182db4ba1d5e
│   │   └── 7f05591d83caf91021ca21106599fd3b0719ed
│   ├── 02
│   │   ├── 72bb2098373fbb55fa5137b31d2b979233b371
│   │   └── bcdd0387939012661c2aa1e25746d4503e5c66
│   ├── 03
│   │   └── 871471b02a1a65b016b6378462a57148e9e4aa
│   ├── 04
│   │   ├── 0b659ee4d47c704a9f26d7415151209e7ad280
│   │   ├── 2d65662492648b48e5ccffd6b25aa6fa581183
│   │   └── c378b8542bcc82b951fd6e198c3e203aafd009
│   ├── 05
│   │   └── f1bdae4365ff4d7d6f6202ea198aae7c158712
│   ├── 06
│   │   └── 978ea7e95ca7be09d6bc0cdbcb378bef7b2b4b
│   ├── 07
│   │   └── a3b7248bb9ae391b23a34a7f3c35b5fe181066
│   ├── 09
│   │   ├── 3c46ea357bcde01ba8ddbf090756242974b92b
│   │   └── 55f9e5879eb0e7e154384a84ca88993f26cf4e
│   ├── 0a
│   │   └── 742dd09293f7f13252a58d10bf1cca6454e221
│   ├── 0b
│   │   └── f5c975b7d8992626aed02a8ad6d865214e4592
│   ├── 0c
│   │   └── 2bb456d818e8bc6f133895526811a24fadc6bb
│   ├── 0d
│   │   ├── 114e8b92703196c358a00ae1499a6e1d58f87f
│   │   ├── 49a9ef13725bd17500a7ca79959ff27f3fb2c7
│   │   └── d7eb84cc190cffb011b031bf1f5ddaed958e61
│   ├── 11
│   │   ├── 807b67ecc6d9a3ee1d8fe2c1b5fe9f6a75d71f
│   │   ├── a6b34c5c00221bd88cc1d4e47d6320d710b08e
│   │   └── d9f79cb34afec894a1a31905437442d5af96dc
│   ├── 12
│   │   └── cb2f867712289514b0da06446513180adee0ce
│   ├── 13
│   │   ├── 2562d2de5a81f1eb136a2bef15aa4ba74bb1a6
│   │   └── d2bc813fcc31cc2910c83a343723e101cd9148
│   ├── info
│   └── pack
│       ├── pack-6b734ba9803a97aa7ebb24027c097d914d9860ff.idx
│       └── pack-6b734ba9803a97aa7ebb24027c097d914d9860ff.pack
├── packed-refs
└── refs # refs 目录存储指向数据（分支）的提交对象的指针
    ├── heads
    │   ├── autoliv
    │   ├── camelot
    │   ├── feature
    │   ├── hotfix
    │   │   └── 20181113
    │   ├── master
    │   ├── page-title
    │   ├── release
    │   │   ├── 20180809
    │   │   └── 20180906
    │   └── wicresoft-share
    ├── remotes
    │   └── origin
    │   │   ├── 1129
    │   │   ├── hotfix
    │   │   │   └── 20181113
    │   │   ├── master
    │   │   ├── page-title
    │   │   ├── release
    │   │   │   ├── 20181115
    │   │   │   ├── 20181129
    │   │   │   └── 20181228
    │   │   ├── weichuang
    │   │   └── wicresoft-share
    │   ├── ic
    │       └── master
```

## 底层命令

- git hash-object

  > 生成内容的 SHA-1

- git cat-file

  > 解析 SHA-1，得到原始内容
  > `git cat-file -t SHA-1`可以得到内部存储的任何对象类型

- git update-index

  > 创建文件的暂存区

- git write-tree

  > 将暂存区内容写入一个树对象

- git read-tree

  > 把树对象读入暂存区

- git commit-tree

  > 创建一个提交对象

- git update-ref

  > 更新引用

- git symbolic-ref HEAD [refs/heads/test]

  > 查看/更新 HEAD 中的引用

- git update-ref refs/tags/v1.0 sha-1
  > 创建一个轻量标签

## 内部对象类型

> 所有内容均以树对象和数据对象的形式存储，其中树对象对应了 UNIX 中的目录项，数据对象则大致上对应了 inodes 或文件内容。

- blob（数据对象）：只保存了文件的内容

- tree（树对象）：层次关系结构

- commit（提交对象）：提交记录

- tag（标签对象）：tag

## 文件类型

- 100644（blob）：普通文件

- 040000（tree）：文件夹

- 100755（blob)：表示一个可执行文件

- 120000（blob）：表示一个符号链接

- 160000（commit）：表示一次提交记录
