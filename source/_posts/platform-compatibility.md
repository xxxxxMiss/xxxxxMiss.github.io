---
title: platform-compatibility
date: 2018-11-13 11:40:24
tags:
categories:
---

## new Date()
> 如果使用格式化字符串的形式，一般有如下几种形式：

|   | yyyy-MM-dd | yyyy/MM/dd | yyyy.MM.dd |
| --  | -- | -- | -- |
| IOS | ✅ |  ✅ | ❎ |
| Android | ✅ | ✅ | ✅ |

所以对于`yyyy.MM.dd`的形式，一般转化成前面2种形式：

``` js
dateStr.replace('.', '/')
```

Note: 经测试发现，如果少了*日*的字符，也会出现兼容性问题。
就比如这种`yyyy/MM`, 所以为了安全起见，最好这样转化下：

``` js
if (/^[\d]{2,4}[-/.]\d{1,2}$/.test(dateStr)) {
  dateStr.replace(/[.-]/g, '/') + '/01'
}
```
