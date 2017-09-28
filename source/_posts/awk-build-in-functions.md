---
title: awk内置函数
date: 2017-09-19 20:42:18
tags:
    - shell
categories:
    - shell
---

## 在awk中, 需要知道的点
- 数组，字符串等等，索引都是从**1**开始
- 变量的取值直接写变量名`var`，而不像shell中需要`$var`，除了内置的特殊变量$0，$1，$2，...等
- FS：指定列分隔符，如：`BEGIN{FS=":"}`
- 内置NF变量：以指定分隔符`FS`分割出来的列数
- 内置NR变量：当前处理的行数

## split(str, arr, field separator)
> 使用指定的列分隔符将行分割到一个数组中。如果列分隔符没有传值，默认使用IFS的值。

```bash
➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"

echo $time | awk '{split($0, arr, ":"); print arr[1]"-->"arr[2]"-->"arr[3]}'

➜  shell ./test.sh
12-->ab-->&&
```

## substr(str, start, length)
> 从str中start位置开始截取长度为length的字符串。
> 如果没有截取长度length,那么默认截取到str的末尾。

```bash
➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"

echo $time | awk '{s=substr($0, 3); print s}'

➜  shell ./test.sh
:ab:&&


➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"

echo $time | awk '{s=substr($0, 3, 4); print s}'

➜  shell ./test.sh
:ab:
```

## index(str, target_str)
> 查找target_str在str中出现的位置，如果找到了，那么返回第一次找到的索引；
> 如果没有找到，返回0

```bash
➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"

echo $time | awk '{i=index($0, "a"); print "index: "i}'

# 字符a在time中索引为4
➜  shell ./test.sh
index: 4


➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"

echo $time | awk '{i=index($0, "x"); print "index: "i}'

# 没有找到，返回0
➜  shell ./test.sh
index: 0
```

## gsub(regexp, sub_str, str)
> 将str中匹配regexp的子串全部替换为sub_str, 并返回成功匹配的次数。

```bash
➜  shell cat test.sh
#!/bin/bash

time="12:ab:&&"
# count为当前行成功匹配的次数
echo $time | awk '{count=gsub("[[:digit:]]", "**", $0); print $0"\nmatches count: "count}'

➜  shell ./test.sh
****:ab:&&
matches count: 2
```

## sub(regexp, sub_str, str)
> 将str中第一次匹配regexp的子串替换为sub_str, 并返回成功匹配的次数(0或者1)。
> 和上面的gsub比较，就相当于一个是全局匹配，一个是单词匹配。

```bash
➜  shell cat test.sh
#!/bin/bash

time="c21:ab:&&"
# count为当前行成功匹配的次数
# 因为只会匹配一次，所以成功匹配，那么返回1；没有找到一个匹配，返回0
echo $time | awk '{count=sub("[[:digit:]]", "**", $0); print $0"\nmatches count: "count}'


➜  shell ./test.sh
c**1:ab:&&
matches count: 1
```

## length(str)
> 返回指定字符串的长。当不指定str,那么返回当前行的字符串长度。

```bash
➜  shell cat test.sh
#!/bin/bash

time="c21:ab:&&"

echo $time | awk 'BEGIN{FS=":"} {
  for(i = 1; i <= NF; i++){
    print "line< "i" > char count: "length($i)
  }
}'

➜  shell ./test.sh
line< 1 > char count: 3
line< 2 > char count: 2
line< 3 > char count: 2
```


```bash
➜  shell cat test.sh
#!/bin/bash

time="c21:ab:&&"

echo $time | awk 'BEGIN{FS=":"} {print length()}'

➜  shell ./test.sh
9
```