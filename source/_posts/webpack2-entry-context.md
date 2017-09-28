---
title: webpack2-entry-context
date: 2017-04-24 16:32:33
tags:
  - webpack
categories: 构建工具
---

## Entry anc Context
> 告诉webpack哪个文件作为打包的入口点。

## context
> 一个绝对路径字符串，告诉webpack要打包的文件都是基于该路径的，就相当于是一个基础路径。
> 如果不提供该选项，那么相对于当前工作目录（项目的跟路径）。
> 推荐提供该选项，这样可以将你的配置文件和当前的工作路径独立开来。

```
context: path.resove(__dirname, 'app')
```

## entry
> 指定打包的入口点, 最简单的规则就是：单页应用一个入口点，多页应用多个入口点。
> 可以提供多种类型，如下

- string
- [string]
- object
- () => string | [string] | object

## 生成的chunk名称
> 如果`entry`提供的是一个字符串或者字符串数组，那么生成的chunk名称是`main`。
> 如果`entry`提供的是一个对象，那么对象的key作为chunk名称，value作为chunk的打包入口。

```
module.exports = {
    entry: './index.js',
    // entry: ['./index.js', 'scroller.js']
    output: {
        filename: '[name].js' // [name]会被替换为main
    }
}
```

```
module.exports = {
    entry: {
        index: './index.js',
        contact: './contact.js'
    },
    output: {
        filename: '[name].js' // [name]会被替换为index, contact
    }
}
```

## 动态入口
> // TODO updating...
