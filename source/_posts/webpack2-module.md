---
title: webpack2-module
date: 2017-03-22 10:59:48
tags: 
  - webpack
categories: 构建工具
---

> 本章节主要介绍module常用配置项
> 一个工程中的各种modules应该如何被webpack处理。

### module.noParse
RegExp

> 让webpack不解析匹配到正则的模块，比如一些第三方库或者辅助模块，我们不需要解析的，那么就可以通过该选项来配置，这样可以节省编译的时间。

`noParse: /jquery|backbone/`

这章讲解的内容配置起来是最简单的，但是用文字描述起来并不简单，直接通过配置例子来说明。

webpack1.x常用配置
```
module: {
    loaders: [
        {
            test: /^$/,
            loader: '',
            include: [],
            exclude: [],
            query: {}
        }
    ]
}
```

webpack2.x常用配置
```
module: {
    rules: [
        {
            test: /^$/,
            // 一定要注意：当使用多个loader解析一个文件时，一定要注意loader的添加顺序，他是【从右往左】依次使用每个loader来解析文件的
            use: [
                {
                    loader: '',
                    options: {}
                },
                {
                    loader: ''
                }
            ],
            include: [],
            exclude: [],
            and: [],
            or: [],
            not: ''
        }
    ]
}
```

webpack2.x常用配置（更常用）
```
module: {
    rules: [ // 每个对象称之为一个`rule`
        {
            test: /^$/,
            // 使用该选项，当需要几个loader解析一个文件时，可以连写：css!style!sass
            // 如果替换为use, 那么就不能这么写了，必须写成[{},{}]的形式
            loader: '', 
            include: [condition], // 包括这些
            exclude: [condition], // 排condition除这些
            and: [condition], // 所有的都包括
            or: [condition], // 至少包括一个
            not: 'condition', // 不包括
            options: {}, // 传入到loader中的选项
            //...
        }
    ]
}
```

> 关于`rules`中每个对象的属性的值，也就是`test`,`loader`,`include`等，都是支持以下几种类型的：

- 字符串：必须完整的匹配该字符串，比如一个文件或者文件夹的**绝对路径**
- 正则：正则匹配
- 函数：必须有匹配的返回值
- 数组：至少一个条件被匹配
- 对象：所有的属性都应该被匹配，每个属性定义一种行为

> 关于`rule`中的`condition`的说明：`condition`中会存在2中输入：

- 资源(resource): 请求文件的绝对路径，依据`resolve`选项进行解析的
- 发布者(issuer): 包含请求文件的文件的绝对路径。

以上的2句话很难理解，直接看例子，比如在`app.js`中有一句导入css语句：
app.js
```
import './style.css'
```
资源就是`/path/to/style.css`
发布者就是`/path/to/app.js`

在一个`rule`中，`test`,`include`,`resource`等都是用来处理资源的，而`issuer`是用来处理发布者的。

> 考虑到兼容性，很多属性都是可以相互替换的。如`rules`|`loaders`, `query`|`options`等。