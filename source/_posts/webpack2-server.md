---
title: webpack2-server
date: 2017-03-22 11:00:47
tags: webpack
categories: 构建工具
---

### devServer
> 

```
// webpack.server.js

var config = require('./webpack.config')
var webpack = require('webpack')
var WebpackDevServer = require('webpack-dev-server')
var compiler = webpack(config)

var server = new WebpackDevServer(compiler, devServer)
```

#### devServer.clientLogLevel
string
> Default: info,可选值有`none`, `error`, `warning`, `info`
> 指定终端输出日志信息的等级, 设置为`none`, 表示什么日志都不输出。


#### devServer.compress
boolean
> 放到服务器上的文件全部使用`gzip`压缩

#### devServer.contentBase
boolean string array
> 将哪些文件放到服务器上，默认使用当前工作目录。你可以像下面这样修改文件目录

```
contentBase: path.join(__dirname, 'public')

// 或则
contentBase: [path.join(__dirname, 'public'), path.join(__dirname, 'assets')]
```

#### devServer.filename
string
> 模块的编译默认是处于`lazy`模式，就是每次请求的时候才会编译。
> 通过该选项，可以配置每次请求的时候编译某个具体的文件，而不是编译所有的文件。

```
lazy: true,
filename: 'bundle.js'
```
***注意：该选项只有在`lazy: true`时才有效***


#### devServer.noInfo
boolean
> 除了错误信息和警告信息，其他的信息都不在输出。

#### devServer.quiet
boolean
> 不在输出任何信息，包括错误信息和警告信息。


#### devServer.stats
string object
> 这个选项可以让你精确的控制在编译的过程中哪些信息应该显示在终端。就相当于可以局部的控制应该显示哪些编译信息，而不是总体的设置。
> ***如果激活了`quiet`, `noInfo`选项，那么该选项就失效了***

具体有哪些选项可以使用，可以参看[这里](https://webpack.js.org/configuration/stats/)


#### devServer.watchContentBase
boolan
> 监听`contentBase`下的文件变动情况，一旦有文件发生了改动，就立即重新编译并刷新页面。

#### devServer.watchOptions
object
> 配置文件监听的相关选项。


##### watchOptions.aggregateTimeout
number
> Default: 300（毫秒数）
> 在这个300内发生的多次改动，不会重新编译，而是汇聚到一起做一次编译。

##### watchOptions.ignored
> 忽略对某些文件的监听，因为监听一个很大的文件夹是很浪费内存和消耗CPU

支持正则和通配符使用
`ignored: /node_modules/`

`ignored: 'files/**/*.js'`


##### watchOptions.poll
boolean number
> 在某些文件系统，比如NFS中，监听如果不能正常工作，可以开启该选项。

`poll: true`

```
// 每隔1000ms检查一次文件是否改动
poll: 1000
```



