---
title: nodejs学习之fs模块
tags:
    - nodejs
    - fs
categories: nodejs
---

## fs.readdir(path[, options], callback)
> 异步的从一个目录中读取内容，该方法并不会深度递归文件夹中的文件，也就是说如果指定的路径中包含有文件夹，那么返回的就是这个文件夹的名字，而不递归到文件夹中的文件
- `path`String | Buffer: 目录的路径。
- `options`（可选的, 默认值`utf8`）String | Object: 可以是一个字符串，也可以是一个包含`encoding`属性的对象，用来指定传入到`callback`中文件名的字符编码。如果`encoding`被设置为`buffer`, 那么返回的文件名是一个`Buffer`对象。
- `callback(err,files)`:回调参数被传入两个参数, `files`为指定的`path`中的文件名，但这些返回的文件名中不包含以`.`,`..`命名的文件。（注意，并不是以`.`, `..`开头的文件名，而是文件名本身就是`.`, `..`）
> 在linux系统中，`.`,`..`开头的文件一般都是隐藏文件，作为配置文件。

```
const fs = require('fs')
const path = require('path')
fs.readdir(path.join(__dirname, '..'), (err, files) => {
    console.log(files)
})
// [ '.babelrc',
  '.editorconfig',
  '.eslintrc',
  '.git',
  '.gitignore', // .开头的文件名也会被列出
  'CONTRIBUTING.md',
  'LICENSE',
  'README.md',
  'appveyor.yml',
  'bin', // 只会返回该文件夹的名称，并不会递归出其中的文件名
  'circle.yml',
  'docs',
  'issue_template.md',
  'lib',
  'node_modules',
  'package.json',
  'test',
  'yarn.lock' ]
```

指定字符编码为'buffer'字符串或者包含`encoding`属性为`buffer`的对象
```
fs.readdir(path.join(__dirname, '..'), {
    encoding: 'buffer'
}, (err, files) => {
    console.log(files)
})
 
// 返回的是一个包含文件名的Buffer数组
[ <Buffer 2e 62 61 62 65 6c 72 63>,
  <Buffer 2e 65 64 69 74 6f 72 63 6f 6e 66 69 67>,
  <Buffer 2e 65 73 6c 69 6e 74 72 63>,
  <Buffer 2e 67 69 74>,
  <Buffer 2e 67 69 74 69 67 6e 6f 72 65>,
  <Buffer 43 4f 4e 54 52 49 42 55 54 49 4e 47 2e 6d 64>,
  <Buffer 4c 49 43 45 4e 53 45>,
  <Buffer 52 45 41 44 4d 45 2e 6d 64>,
  <Buffer 61 70 70 76 65 79 6f 72 2e 79 6d 6c>,
  <Buffer 62 69 6e>,
  <Buffer 63 69 72 63 6c 65 2e 79 6d 6c>,
  <Buffer 64 6f 63 73>,
  <Buffer 69 73 73 75 65 5f 74 65 6d 70 6c 61 74 65 2e 6d 64>,
  <Buffer 6c 69 62>,
  <Buffer 6e 6f 64 65 5f 6d 6f 64 75 6c 65 73>,
  <Buffer 70 61 63 6b 61 67 65 2e 6a 73 6f 6e>,
  <Buffer 74 65 73 74>,
  <Buffer 79 61 72 6e 2e 6c 6f 63 6b> ]
```

## fs.chmod(path, mode, callback)
> 修改文件或者目录的操作权限。
关于文件或者目录的权限，可以参看[unix/linux文件权限](https://www.tutorialspoint.com/unix/unix-file-permission.htm)
- `path`String | Buffer, 文件或目录的路径
- `mode`integer, 指定权限，8进制，如`0666`
- callback(err), 操作完成的回调

```
const fs = require('fs')
fs.chomod(__dirname + 'README.md'), 0666, err => {})
```