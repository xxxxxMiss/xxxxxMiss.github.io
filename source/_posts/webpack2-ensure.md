---
title: webpack2-ensure
date: 2017-03-22 10:58:05
tags: 
  - webpack
categories: 构建工具
---

[TOC]

### 懒加载
在开发中，经常会遇到这样的需求：比如在React,Vue中的路由加载组件，如果在首次加载的时候，就将一堆的组件全部加载，毫无疑问在打开首页的时候会非常的慢，影响用户体验。为了实现第一次快速的加载，优化用户体验，可以通过动态路由。就是第一次只会加载一些必须的组件，剩下的组件等到需要的时候再去加载。使用webpack提供的`require.ensure()`可以轻松实现这一要求。

### 语法
`require.ensure(dependencies: String[], callback: function(require), chunkName: String)`

#### 参数解释
- dependencies: 一个字符串数组，在callback中的代码执行之前需要加载的依赖模块
- callback: 当dependencies中的模块全部加载完毕之后，执行callback中的代码。callback中会传入一个require函数，我们可以在callback中使用这个require()函数引入其他的依赖模块
- chunkName（可选）: 通过require.ensure()生成的模块的名称。在不同的require.ensure()中传入相同的chunkName,可以保证依赖模块按正确的顺序引入到require.ensure()生成的模块中

假如我们有如下的目录结构
```
file structure
|
js --|
|    |-- entry.js
|    |-- a.js
|    |-- b.js
webpack.config.js
|
dist

```

```
\\entry.js
require('./a')
require.ensure([], function(require){
  require('./b')
})


\\a.js
console.log('I AM A')

\\b.js
console.log('I AM B')
```

```
\\webpack.config.js
module.exports = function(){
  return {
    entry: './js/entry.js',
    output: {
      filename: 'bundle.js',
      path: './dist'
    }    
  }
}
```
编译后，我们发现dist下有bundle.js和0.bundle.js。
entry.js 和 a.js被编译到bundle.js。
b.js被编译到0.bundle.js。

### 关于require.ensure()需要注意的点
- 空数组作为参数
```
require.ensure([], function(require){
  require('./a.js')
})
```
上面的代码，webpack会创建一个模块，并且a.js被分割到这个模块中

- 依赖作为参数
```
require.ensure(['./a.js'], function(require){
  require('./b.js')
})
```
 上面的代码，a.js,b.js会被编译到一个共同的模块中，并且从entry.js中分割出来。
 但是只有b.js中的内容被执行，a.js中的内容并不会执行。如果需要执行a.js，那么我们必须通过像这样`require('./a.js')`以同步的方式来引入a.js。






