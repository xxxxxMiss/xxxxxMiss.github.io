
---
title: webpack2-conding-split
date: 2017-03-22 10:57:18
tags: 
  - webpack
categories: 构建工具
---

[TOC]

### 代码分割
  - 一个应用有第三方库和程序代码组成，第三方库和程序代码最大的不同就是一般第三方库是不会轻易改动的。
  - 在打包的时候，如果能将这些第三方库和程序代码分开打包，那么就可以利用浏览器的缓存机制来缓存这些不需要经常改动的第三方库文件，这样可以节省很多的打包时间，加快资源加载速度。
### 实现
假如在index.js中引用第三方库moment.js
index.js
```
  var moment = require('monent')
  console.log(moment().format())
```

我们的webapck.config.js配置如下
```
  module.exports = function(){
    return {
      entry: './index.js',
      output: {
        filename: '[chunkhash].[name].js',
        path: './dist'
      }
    }
  }
```
经过编译之后，你会发现在第三方库moment.js和你的程序代码被打包到一个文件中了。
这样做的问题是：

- 编译后的文件很大，现在的webpack2.x对于编译后的文件很大，会在控制台输出如下的警告信息
  > WARNING in asset size limit: The following asset(s) exceed the recommended size limit (250 kB). 
  This can impact web performance.
  Assets: 
    2f22b134462399733764.main.js (443 kB)

- 每当程序代码只要改动一点点，都会重新编译整个文件，浪费时间

### 多入口
对于上面单一entry出现的问题，我们可以通过多入口来缓解这个问题。将webpack.config.js配置文件改成如下配置：
```
  module.exports = function(){
    return {
      entry: {
        index: './index.js',
        moment: 'moment'
      },
      output: {
        filename: '[chunkhash].[name].js',
        path: './dist'
      }
    }
  }
```
编译之后，dist文件夹下会出现2个文件，我们查看这两个编译后文件后会发现moment.js也会被编译到[chunkhash].index.js中，这也不是我们想要的结果。为了解决这个问题，可以使用`CommonsChunkPlugin`插件来解决这个问题。

### CommonsChunkPlugin
> CommonsChunkPlugin是一个相当复杂的插件，他可以将不同模块中相同的代码抽取到一个指定的公共的模块中，如果这个公共的模块不存在，那么它将自动为我们创建一个。

将上面的webpack.config.js修改为如下
```
  module.exports = function(){
    return {
      entry: {
        index: './index.js',
        vendor: 'moment'
      },
      output: {
        filename: '[chunkhash].[name].js',
        path: './dist'
      },
      plugins: [
        new webpack.optimize.CommonsChunkPlugin({
          name: 'vendor' // 指定抽取到哪个公共模块,必不可少的
        })
      ]
    }
  }
```

### 清单文件 Manifest File
- 当我们修改了程序代码后编译，会发现第三库模块也会被编译，即使我们现在已经将程序代码和第三方库文件分离开了。这样，我们依然不能享受浏览器缓存带来的好处。
- 问题原因在于：当webpack每次编译时，会自动生成一些运行时代码，这些代码可以可以帮助webpack更好的做他的工作。这意味着这些运行时的代码代码也会被编译到公共模块，比如这个地方的vendor.js。
- 为了解决这个问题，我们应该将这些webpack自动生成的代码提取到单独的一个文件中（清单文件），这样每次修改程序代码时重新编译的只会是程序代码和清单文件，第三方库文件不会重新编译。
webpack.config.js配置文件修改如下
```
  module.exports = function(){
    return {
      entry: {
        index: './index.js',
        vendor: 'moment'
      },
      output: {
        filename: '[chunkhash].[name].js',
        path: '.dist'
      },
      plugins: [
        new webpack.optimize.CommonsChunkPlugin({
          name: ['vendor', 'manifest']
        })
      ]
    }
  }
```




