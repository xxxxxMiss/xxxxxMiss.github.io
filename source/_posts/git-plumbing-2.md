---
title: git进阶（二）
date: 2017-09-19 01:23:39
tags:
    - git
categories:
    - git
---

## git配置文件的位置
- /etc/gitconfig
- ~/.gitconfig || $XDG_CONFIG_HOME/git/config
- $PWD/.git/config

## 查看git配置
> 对于配置选项的CURD操作，不指定--system,--global,--local选项，
> CUD默认都是--local选项, R操作查询所有的配置（相当于同时指定了三个选项）。

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

## 设置git配置
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
> global级别的.gitignore。
> 一般每个项目下都会有.gitignore文件，如果配置了global级别的.gitignore,那么对于所有的git仓库都会生效。
如：
`git config core.excludesfile ~/.gitignore_global` 

## core.autocrlf
> 用来处理各平台之间的换行符回车符之间的一致性问题

- 使用linux或者mac,一般设置为`input`,那么在检出的时候，自动将`\r\n`转化为`\n`。
- 使用windows，可以设置为`true`,那么在检出的时候，自动将`\n`转化为`\r\n`。
- 如果只在windows上开发，那么可以设置为`false`,关闭该功能。


## 使用npm安装你自己编写的脚本


