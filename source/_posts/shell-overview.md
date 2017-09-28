---
title: shell基本知识
date: 2017-03-29 23:54:33
tags: shell
categories: linux
---
### 常见Linux Shell种类
- Bourne Shell (/usr/bin/sh 或 /bin/sh)
- Bourne Again Shell (/bin/bash)
- C Shell (/usr/bin/csh)
- K Shell (/usr/bin/ksh)
- Shell for Root (/sbin/sh)

### 第一个Shell脚本
```
#!/bin/sh
echo 'Hello World !'
```
> "#!" 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种Shell

### 运行Shell脚本的2种方法
1. 作为可执行程序
```
// 将上面的脚本保存为test.sh
chmod +x ./test.sh // 使脚本具有可执行的权限
./test.sh // 执行脚本
```


2. 作为解释器参数
```
/bin/sh test.sh
/bin/php test.php
```

> 这种方式运行的脚本，不需要再第一行指定解释器的信息，即使指定了也没用