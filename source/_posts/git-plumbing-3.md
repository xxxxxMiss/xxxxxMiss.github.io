---
title: git进阶（三）
date: 2019-01-22 11:12:22
tags:
  - git
  - workflow
categories:
  - git
---

# git reset

## git rest [mode][commit]

### mode

- --soft：`.git/HEAD`中的引用不会改变，但是引用的值会发生改变。

> 比如开始`.git/HEAD`指向了`.git/ref/heads/master`中的值为`2a0570f44e82017823a19d08fc4cb342584dd05c`（最后一次提交的 sha-1），经过`git reset --soft HEAD^`，那么`.git/ref/heads/master`中的值会变为`978fc8a9dc1d920afda948380fa2dd339d5d9050`（倒数第二次的 sha-1）。就是说没做一次这样的操作`git reset --soft HEAD^`，`.git/ref/heads/master`中的指针就向前移动一次（正常情况下指针指向最后一次提交记录）。

- --mixed：

- --hard：

- --merge：
