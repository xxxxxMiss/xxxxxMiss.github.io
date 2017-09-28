---
title: webpack2-resolve
date: 2017-03-22 11:00:15
tags: 
  - webpack
categories: 构建工具
---


[TOC]

### resolve
> 配置模块解析策略。
> 比如，`import lodash`, 可以通过配置`resolve.modules`来指定当解析`lodash`是，去哪个路径下去寻找`lodash`。

#### resolve.alias
object
> 配置模块的别名,这样当使用`import`或者`require`就可以使用别名来代替冗长的相对路径。
> 比如你`import`某一路径下的一个js文件:`import ../../src/js/index.js`
> 如果没有配置别名，那么你每次引入`src/js`这个路径下的某个js,都需要写很长的路径,通过配置别名，你可以简化书写。

```
module.exports = {
  resolve: {
    alias: {
      js: path.resolve(__dirname, 'src/js'),
      css: path.resolve(__dirname, 'src/css')
    }
  }
}
```
没有配置别名之前
`import { getData } from '../../src/js/fetData'`
配置别名后
`import { getData } from 'js/fetData'`

在配置别名，关于填写文件路径的各种写法，可以移步[这里](https://webpack.js.org/configuration/resolve/)


#### resolve.aliasFields
string
> 指定某些属性，用来配置别名所指定的js文件解析的环境。

`aliasFields: ['browser']`

直接这么一句话，很难理解什么意思，详细的意思可以参阅[这里](http://www.ibm.com/developerworks/cn/web/1501_chengfu_browserify/)


#### resolve.descriptionFiles
arry
> 指定用哪个json文件作为描述文件。一般情况下使用默认值即可，不需要显式的配置。

`descriptionFiles: ['package.json']`

#### resolve.enforceExtensions
boolean
> 指定是否必须使用扩展名。
比如一般情况下，我们会像这样引入某个js, `import 'lodash'`, 但是如果你指定了`enforceExtensions: true`，那么你就必须这样引入`import 'lodash.js'`

#### resolve.extensions
> 自动解析文件扩展名，默认值['.js', '.json']。
> 意思就是比如你`import _ from '../path/file'`, 会先去`path`下寻找`file.js`文件，没有找到，那么继续寻找`file.json`文件，都没找找到抛出`Module not found: Error: Can't resolve 'xx' in 'xxx'`错误。
> NOTE: 一旦你配置了该选项，那就意味着webpack不在使用默认的解析机制。比如你配置为
> `extensions: ['.txt']`, 那么webpack就只会去寻找`xx.txt`,并不会去寻找`xx.js`,`xx.json`,即使你指定的文件夹下有`xx.js`,`xx.json`，因为默认的选项已经被你重写了，只会按照你配置的选项来解析。
[node包寻找机制](https://nodejs.org/dist/latest-v7.x/docs/api/modules.html)

#### resolve.mainFields
> 当你引入某一个包时，使用包下面的哪一个文件。
> 配置: `mainFields: ['module', 'browser', 'main']`，具体看例子解释。

```
import * as D3 from 'd3'
```

在`d3`这个`package.json`中，有这几个选项
```
"main": "build/d3.node.js", // 适用node环境
"browser": "build/d3.js", // 适用浏览器环境
"module": "index" // 都支持
```
> 以上的几个选项可以分别支持不同的环境，你应该选择你需要的环境选项，通过该选项的配置，可以满足你的需求。

#### resolve.mainFiles
> 当解析到的文件是一个目录是，如何处理该目录。
> 默认：`mainFiles: ['index']`。
关于该选项的具体含义，只要理解了node中包的寻找机制，就能明白该选项的含义。
[node包寻找机制](https://nodejs.org/dist/latest-v7.x/docs/api/modules.html)

这里举例简单说明：
index.js
```
import * as fns from './js' //js是一个文件夹
```
webpack.config.js
```
resolve: {
  mainFields: ['canvas', 'utils']
}
```
> 当webpack解析到`js`是一个文件夹时，如果你的`mainFields`配置如上，那么webpack会去`js`文件夹下寻找`canvas.js`，如果没有找到,那么继续寻找`js`文件夹下的`utils.js`，如果还没有找到，抛出错误`Module not found: Error: 'xx' in 'xx'`

#### resolve.modules
array
> 默认配置：modules: ['node_modules']
> 告诉webpack在解析模块的时候，去哪些目录搜索这些即将被解析的模块。
> 既可以传入一个相对路径，也可以传入一个绝对路径。但是你要知道的是，他们之间是有一些区别的。
> 相对路径：比如你传入一个`./node_modules`, webpack会在当前路径下的`node_modules`下寻找，如果没有找到，会继续搜寻当前目录的父目录下的`node_modules`,如果还没有找到，依次类推，继续向上搜寻，直至跟目录结束。
> 绝对路径：只会在传入的路径中搜索。

如果你想优先搜索你指定的目录，而不是默认的`node_modules`, 那么你可以将这个路径插入到默认路径的前面，就像下面这样的
`modules: [path.resolve(__dirname, 'src'), 'node_modules']`

#### resolve.unsafeCache
`regexp` `array` `boolean`

> 开启缓存，但不是那么的安全（现在还不太明白怎么个不安全法）

如果你想缓存所有的解析模块，那么可以这样设置
`unsafeCache: true`

你也可以传入正则表达式或这则表达式的数组来缓存某些解析的模块
`unsafeCache: /src\/utils/`

### resolve.plugins
> 添加目录命名的一些额外的插件列表。

```
resolve: {
  plugins: [new DirectoryNamedWebpackPlugin()]
}
```

### resolveLoader[prop]
object
> 这个选项拥有的属性配置和上面的`resolve`是一样的，不过他**只能用来**配置webpack的`loader`包，默认值如下

### resolveLoader.moduleExtensions
> 用来配置`loader`的扩展名，默认是一个空数组。比如你使用`loader`的时候，想省去后缀`-loader`,那么你可以如下配置

```
resolveLoader: {
  moduleExtensions: ['-loader']
}
```
NOTE: 在`webpack1.x`，可以省去`-loader`后缀，webpack默认会加上。但是在`webpack2.x`，必须通过上面的这个配置才可以省去。