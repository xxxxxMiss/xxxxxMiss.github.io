---
title: webpack-library
date: 2017-03-22 10:58:40
tags: 
  - webpack
categories: 构建工具
---

[TOC]

> 本章节主要介绍如何利用webpack来构建自己编写的js库，原文链接可以点击[这里](https://webpack.js.org/guides/author-libraries/)

假如我们要实现的一个数字和单词之间的互转(1 <=> one)
```
\\ src/index.js
import _ from 'lodash'
import numRef from './ref.json'

export function numToWord(num) {
    return _.reduce(numRef, (accum, ref) => {
        return ref.num === num ? ref.word : accum
    }, '')
};

export function wordToNum(word) {
    return _.reduce(numRef, (accum, ref) => {
        return ref.word === word && word.toLowerCase() ? ref.num : accum
    }, -1);
}
```

然后我们可能用下面的这几种方式来使用这个库
```
// ES2015 modules

import * as webpackNumbers from 'webpack-numbers';

...
webpackNumbers.wordToNum('Two') // output is 2
...

// CommonJS modules

var webpackNumbers = require('webpack-numbers');

...
webpackNumbers.numToWord(3); // output is Three
...

// As a script tag

<html>
...
<script src="https://unpkg.com/webpack-numbers"></script>
<script>
    ...
    /* webpackNumbers is available as a global variable */
    webpackNumbers.wordToNum('Five') //output is 5
    ...
</script>
</html>
```

下面来编写webpack配置文件
```
module.exports = function(){
  return {
    entry: './src/index.js',
    output: {
      filename: 'webpack-numbers.js',
      path: './dist'
    },
    module: {
      rules: [
        {
          test: /.json$/,
          use: 'json-loader'
        }
      ]
    }
  }
}
```
如果利用上面的配置进行编译，我们会发现lodash.js也会被编译到webpack-numbers.js中。
我们自己编写的这个webpack-numbers.js库依赖lodash.js，但是我们不希望lodash的源代码被编译到我们这个库中，而是希望他们分开，在用户下载我们的这个webpack-numbers.js库的同时也将依赖的库lodash.js下载下来。
要实现这个需求，我们可以按如下修改配置文件
```
module.exports = function(){
  return {
    ...
    externals: {
      'lodash': {
        commonjs: 'lodash',
        commonjs2: 'lodash',
        amd: 'lodash',
        root: '_'
      }
    }
    ...
  }
}
```

### output.library, output.libraryTarget
> 因为我们的库可能需要运行在不同的环境下，如CommonJS, AMD, Node.js ,作为一个全局变量，为了让我们编写的库可以运行在不同的环境下，那么我们就需要做相应的配置。

output.library
> 导出的全局变量的名称

output.libraryTarget
`string`
> Default: 'var'，可选的值有`umd`, `amd`, `commonjs`, `commonjs2`, `commonjs-module`, `this`, `var`
> 这些值指明了导出的环境, 下面我们依次来看看在各种环境下导出的代码是什么样的

假如我们的配置文件是这样的

```
module.exports = function(){
  return {
    entry: './ab.js',
    output: {
      filename: 'webpack-lib',
      path: './dist',
      library: 'abConvert',
      libraryTarget: 'var' // 当为默认值的时候，可以不指定该属性
    },
    externals: {
      'zepto': {
        commonjs: 'zepto',
        commonjs2: 'zepto',
        amd: 'zepto',
        root: '$'
      }
    }
  }
}
```

那么各种取值下导出的代码会是这个样子的
```
\\var

var abConvert = (function(modules){
    return ...
  })()

```

```
\\umd

(function webpackUniversalModuleDefinition(root, factory) {
  if(typeof exports === 'object' && typeof module === 'object')
    module.exports = factory(require("zepto"));
  else if(typeof define === 'function' && define.amd)
    define(["zepto"], factory);
  else if(typeof exports === 'object')
    exports["abConvert"] = factory(require("zepto"));
  else
    root["abConvert"] = factory(root["$"]);
})()
```

```
\\ amd

define('abConvert', ['zepto'], function(){})
```

```
\\ commonjs

exports['abConvert'] = (function(modules){
  return ...
})()
```

```
\\ commonjs2

module.exports = (function(modules){
  return ...
})()
```

```
\\ commonjs-module

module.exports = (function(modules){
  return ...
})()

Object.defineProperty(module.exports, "__esModule", { value: true })
```
> 如果libraryTarget指定为`commonjs-module`, 那么此时`module.exports`上会被定义一个`__esModule`, 表明此时采用的是es2015模块化方式定义的，并且此时的`library`属性会被忽略。


```
\\ this

this['abConvert'] = (function(modules){
  
})()
```
> 当指定为`this`时，代表的是由运行环境决定。比如运行在浏览器中，此时`this`代表`window`，如果运行在nodejs环境，那么此时`this`代表`global`。


