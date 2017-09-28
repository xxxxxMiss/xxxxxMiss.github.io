---
title: nodejs学习之path模块
date: 2017-03-22 10:28:35
tags: nodejs
categories: nodejs
---

> nodejs提供了一个path模块来处理文件和目录的路径，通过
> const path = require('path')
> 来引入该模块。以下介绍的这些方法参数全部为字符串类型，如果不是，会抛出一个TypeError异常

[关于POSIX](http://baike.baidu.com/link?url=Bhv5oqD5YMuto_rBZ4MCpOcMmXzs0E68uJQSer_pNZncK3FV38KLwrCVGuN0GWQc0f4rYwo0XosnAd-z_S6ex_)

[TOC]

## path.basename(path[, ext])
> 该方法返回一个路径的最后部分，类似于Unix中的basename命令。如果指定了ext部分，那么返回的文件名不带扩展名

- path: String
- ext: String 可选的文件扩展名
- Returns: String

For example
```
path.basename('/foo/bar/baz/afs/quux.h
tml')
// Returns: 'quux.html'

path.basename('/foo/bar/baz/afs/quux.html', '.html')
// Returns: 'quux'
```


## path.delimiter
> 根据系统类型，返回系统的路径分隔符

- `:` POSIX系统
- `;` Windows系统

For example, on POSIX:
```
console.log(process.env.PATH)
// Prints: '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin'

process.env.PATH.split(path.delimiter)
// Returns: ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin']
```

On Windows:
```
console.log(process.env.PATH)
// Prints: 'C:\Windows\system32;C:\Windows;C:\Program Files\node\'

process.env.PATH.split(path.delimiter)
// Returns: ['C:\\Windows\\system32', 'C:\\Windows', 'C:\\Program Files\\node\\']
```

## path.dirname(path)
> 返回一个路径的文件夹部分，类似于Unix中的dirname命令

For example
```
path.dirname('/foo/bar/baz/asdf/quux')
// Returns: 'foo/bar/baz/asdf'

// 路径中的最后一个/会被忽略
path.dirname('/foo/bar/baz/asdf/quux/')
// Returns: 'foo/bar/baz/asdf'
```

## path.extname(path)
> 返回一个路径中的文件扩展名。如果一个路径字符串的最后部分都不包含该`.`, 或者basename的首个字符是`.`,那么返回一个空字符串。

For example
```
path.extname('index.html')
// Returns: '.html'

path.extname('index.coffee.md')
// Returns: '.md'

path.extname('index.')
// Returns: '.'

path.extname('index')
// Returns: ''

path.extname('.index')
// Returns: ''
```

path.join([…paths])
> 使用指定平台的路径分隔符将参数中的路径的各个部分连接起来，并规范化连接的结果，使之是一个合法的路径。
> 参数中长度为0的字符串会被忽略。
> 如果连接的结果也是一个长度为0的字符串，那么会返回一个`.`， 代表当前的工作目录。

***需要注意的是，这里多次提到长度为0的字符串***
`''.length // 0, 空字符串`
`' '.length // 2, 2个空白字符串`
For example
```
// .. 代表它的上一级目录
path.join('/foo', 'bar', 'baz/asdf', 'quux', '..')
// Returns: '/foo/bar/baz/asdf'

// ../..代表它的上一级目录的上一级
path.join('/foo', 'bar', '  ', 'baz/asdf', 'quux', '../..')
// Returns: '/foo/bar/  /baz'

path.join('foo', {}, 'bar')
// throws TypeError: Arguments to path.join must be strings

path.join('/foo', 'bar', '  ', 'baz/asdf', 'quux')
// Returns: '/foo/bar/  /baz/asdf/quux'
```


## path.normalize(path)
> 返回一个规范化的路径，会解析`..`, `.`这些特殊字符。
> 当路径中出现多个平台分隔符(/on POSIX, \ on windows), 那么会用当个平台分隔符替换。
> ***这个方法会保留路径结尾部分的`/`, 如果被解析路径的尾部包含`.`, `..`，那么解析出来的路径最后的`/`会被忽略***

For example
on POSIX
```
path.normalize('/foo/bar//baz/asdf/quux/..')
// Returns: '/foo/bar/baz/asdf'

path.normalize('/foo/bar//baz/asdf/quux/.')
// Returns: '/foo/bar/baz/asdf/quux'

path.normalize('/foo/bar//baz/../asdf/quux/.')
// Returns: '/foo/bar/asdf/quux'

path.normalize('/foo/bar//baz/asdf/quux/')
// Returns: '/foo/bar/baz/asdf/quux/'
```

on Windows
```
path.normalize('C:\\temp\\\\foo\\bar\\..\\');
// Returns: 'C:\\temp\\foo\\'
```


path.resolve([…paths])
> 该方法将路径序列或者一个路径序列的各个部分解析到一个绝对路径。
> ***该方法解析路径序列是从右往左解析的，直到解析到一个绝对路径。解析到一个绝对路径后就停止解析，并返回这个绝对路径***
> 如果所有部分都解析完毕了，依然没有得到一个绝对路径，那么返回就返回当前的工作路径。
> 这个返回的结果路径是被规范化的，***并且结尾的/会被移除，除非它是一个跟路径***
> 在解析的过程中，长度为0的部分会被忽略
> 如果没有传入任何参数，那么该方法会返回一个代表当前工作目录的绝对路径

For example
```
path.resolve('/foo/bar', './baz')
// Returns: '/foo/bar/baz'

path.resolve('/foo/bar', '/tmp/file/')
// Returns: '/tmp/file'

path.resolve('wwwroot', 'static_files/png/', '../gif/image.gif')
// if the current working directory is /home/myself/node,
// this returns '/home/myself/node/wwwroot/static_files/gif/image.gif'
```

## path.relative(from, to)
> 该方法返回一个从`from`到`to`的相对路径，如果`from`, `to`分别通过`path.resolve`解析后得到相同的结果，那么返回一个长度为0的字符串
> 如果`from`, `to`中的任何一个传入了一个长度为0的字符串，那么在解析的过程中会使用当前的工作路径取代这个长度为0的字符串
> ***需要注意的是，如果`from`, `to`任何一部分传入一个相对路径，那么都会被`path.resolve`解析为一个绝对路径***

For example
on POSIX:
```
path.relative('/data/orandea/test/aaa', '/data/orandea/impl/bbb')
// Returns: '../../impl/bbb'

path.relative('/data/orandea/test/aaa', '../foo/bar/quux')
// if the current working directory is /home/myself/node,
// Returns: '../../../../home/myself/foo/bar/quux'

path.relative('/foo/bar', '/foo/bar')
// Returns: ''
```
On Windows:
```
path.relative('C:\\orandea\\test\\aaa', 'C:\\orandea\\impl\\bbb')
// Returns: '..\\..\\impl\\bbb'
```


## path.sep
> 根据不同的平台返回指定平台的路径分隔符

- `\`on Windows
- `/`on POSIX

For example
on POSIX:
```
'foo/bar/baz'.split(path.sep)
// Returns: ['foo', 'bar', 'baz']
```

On Windows:
```
'foo\\bar\\baz'.split(path.sep)
// Returns: ['foo', 'bar', 'baz']
```