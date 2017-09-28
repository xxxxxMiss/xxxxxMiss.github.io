---
title: encodeURIComponent
date: 2017-05-20 14:36:29
tags: 
    - js
categories: js
---

## encodeURIComponent概述
> 是对统一资源标识符（URI）的组成部分进行编码的方法。它使用一到四个转义序列来表示字符串中的每个字符的UTF-8编码（只有由两个Unicode代理区字符组成的字符才用四个转义字符编码）

## 语法
```
encodeURIComponent(str)
```
> NOTE: encodeURIComponent不转义以下字符：

| 字符 | 编码 |
| --- | --- |
| 字母 | --- |
| 数字 | --- |
| ( | %28 |
| ) | %29 |
| . | %2e |
| ! | %21 |
| ~ | %7e |
| * | %2a |
| ' | %27 |
| - | %2d | 
| _ | %5f | 

## 手动转义encodeURIComponent未转义的字符
> 因为encodeURIComponent并不对`!`, `~`, `*`, `(`, `)`, `'`等这些字符转义，而已这些字符也没有被正式划定URI的用途，所以当你需要对这些字符转义的时候，可以按照下面的方法：

```
function fixedEncodeURIComponent(str){
    return encodeURIComponent(str)
        .replace(/[!\(\)\*~']/g, function(c){
            return '%' + c.charCodeAt(0).toString(16)
        })
}
```

## 手动解码encodeURIComponent编码的字符
> URI中常见的一些字符，如`?`, `&`, '#'等，如果使用encodeURIComponent转义，那么uri就变得不是那么直观了，为了使uri直观易读，我们可以手动反转这些字符：

```
function fixedEncodeURIComponent(str){
    return encodeURIComponent(str)
        .replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent)
}
```

## 常见字符在encodeURIComponent中编码的字符对照表
| 字符 | 编码 |
| --- | --- |
| # | %23 |
| $ | %24 |
| & | %26 |
| + | %2B |
| : | %3A |
| < | %3C |
| = | %3D |
| / | %2F |
| ? | %3F |
| @ | %40 |
| [ | %5B |
| ] | %5D |
| ^ | %5E |
| ` | %60 |
| { | %7B |
| } | %7D |
| &#124; | %7C |

## 关于charCodeAt()方法
> charCodeAt() 方法返回0到65535(0xffff)之间的整数，表示给定索引处的UTF-16代码单元 (在 Unicode 编码单元表示一个单一的 UTF-16 编码单元的情况下，UTF-16 编码单元匹配 Unicode 编码单元。但在——例如 Unicode 编码单元 > 0x10000 的这种——不能被一个 UTF-16 编码单元单独表示的情况下，只能匹配 Unicode 代理对的第一个编码单元) 。如果你想要整个代码点的值，使用 codePointAt()。
> Unicode 编码单元（code points）的范围从 0 到 1,114,111（0x10FFFF）。
> 开头的 128(0-127) 个 Unicode 编码单元和 ASCII 字符编码一样。

## 语法
```
str.charCodeAt(index)
```
参数index解释：
- index: >=0 && < st.length
- 如果不是一个数值，则默认为0。
- 如果是一个超出范围的数值，那么返回NaN。

返回值：给定索引处字符的 UTF-16 代码单元值的数字

## 关于字符编码的相关问题
> 这是一个很大的话题，可以参考以下几个链接。

[为什么 UTF-8 编码比 UTF-16 编码应用更广泛?](https://www.zhihu.com/question/24572900)
[字符编码笔记：ASCII，Unicode和UTF-8](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)