---
title: shell-command
date: 2018-03-08 00:48:17
tags:
categories:
---

## id
> 查看用户属性

```shell
# 打印当前用户的uid, 用户名, gid, 组名等相关信息
$ id
```

```shell
# 打印uid
$ id -u
```

```shell
# 打印gid
$ id -g
```

```shell
# 打印用户名
$ id -un
```

```shell
# 打印组名
$ id -gn
```

## &符号
> `&`是Bash内置的用于并行处理进程的一个控制操作符。在命令行的末尾添加`&`将会在后台运行该命令，它将在当前的Shell进行下启动一个子Shell进程。

```shell
$ sleep 10 &
# 输出任务编号和子进程号
[1] 22525
```

通过`jobs`命令来查看后台正在运行的任务信息：
```shell
$ jobs
[1]  + running    sleep 10
```

通过`-l`选项可以查看正在后台运行的任务的进程号等信息
```shell
$ jobs -l
[1]  + 22711 running    sleep 10
```

通过`%任务编号`或者`fg 任务编号`可以将后台任务切换到前台：
```shell
$ sleep 30 &
[1] 22711
$ %1
```

通过以下几个步骤可以将任务在前后台间切换：
```shell
$ sleep 30 &
$ %1
$ CTRL + Z组合键
# 或者使用bg
$ %1 &
```