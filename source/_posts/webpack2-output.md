---
title: webpack2-output
date: 2017-03-22 10:59:12
tags: 
  - webpack
categories: 构建工具
---

> 本章节主要介绍output常用配置项

### output.filename
`string`
> 用来指定打包生成的文件的名称。
> 默认值是`[name].js`,该默认值的含义并不是说你可以不指定该选项就使用默认的`[name].js` ，他的含义是当`entry`配置为单入口时（单个字符串或者字符串数组），就是`[name]`会被替换为`mian`；多入口时，`[name]`会被替换为对象的key值。


- 单入口的时候，我们可以静态的指定一个输出模块名称

`filename: bundle.js`

- 多入口的时候，可以通过下面的形式来指定输出模块名称

```
// 使用entry中指定的key
filename: '[name].bundle.js'
```

```
// 使用内部生成的id
filename: '[id].bundle.js'
```

```
# 使用每次编译自动生成的hash值
filename: '[name].[hash].bundle.js'
```

```
// 使用基于模块内容生成的chunkhash
filename: '[chunkhash].bundle.js'
```

>虽然该选项叫`filename`, 但是可以指定一个输出目录, 就像这样的`js/[name]/bundle.js`。
> 当使用了`[hash]`或者`[chunkhash]`占位符时，可以指定占位符的长度，默认是`20`位。

```
output: {
  filename: '[hash:10]' //局部指定hash的长度 
}

或者
output: {
  hashDigestLength: 15 // 全局指定hash的长度
}
```

| 占位符 | 描述 |
| ---- | ---- |
| hash | 基于文件名进行hash |
| chunkhash | 基于文件内容进行hash |


### output.chunkFilename
`string`
> 这个选项主要用来指定动态加载生成的模块名称。
> 该名字在运行中生成，就是当你去请求某一个chunk时，这时候才会去生成chunk的名称。

我们已经知道，在`require.ensure(dependencies, callback, chunkName)`中可以指定一个`chunkName`参数
- 如果指定了这个参数，那么在`output`中就可以这样来取得
```
module.exports = {
  output: {
    filename: '[chunkhash].[name].js',
    chunkFilename: '[chunkhash].[name].js'
  }
}
```
上面`[name]`占位符就是你在`require.ensure(dependencies, callback, chunkName)`中指定的那个chunkName。
- 如果在`require.ensure(dependencies, callback, chunkName)`中省略了这个`chunkName`参数，那么统一使用`output.chunkFilename`中指定的名称
- 如果output中也没有指定`chunkFilename`选项，那么会使用`output.filename`中除了`[name]`占位符以外的占位符+`[id]`占位符作为模块名。
```
module.export = function(){
  return {
    output: {
      filename: '[chunkhash].[name].js'
    }
  }
}
```
如上output配置，那么此时动态分割出来的模块名就是`[chunkhash].[id].js`。

### output.path
> 指定编译后的模块输出目录, 既可以是相对路径，也可以是绝对路径

```
// 相对路径
path: './dist'

// 绝对路径
path: path.resolve(__dirname, 'dist/assets')
```

### output.hashDigest
> 指定hash算法返回的字符编码。默认`hex`。
> nodejs中的`hash.digest([enconding])`支持的编码，此处都支持。
> `enconding`支持的有`hex`,`latin1`,`base64`。

### output.pathinfo
boolean
> Default: false
> 在编译的代码中创建一些注释信息，在开发中，当你想阅读编译后的源代码，这就显得非常的有用。
> **在生产环境中不要开启该选项**。

### output.publicPath
string
> Default: ""
> 这是一个非常重要的选项，主要用在动态加载，加载外部资源，比如加载外部资源（图片,css,js），如果指定了一个错误的值，那么将会得到404的错误。


### output.sourceMapFilename
string
> Default: '[file].map'
> 只有指定了[devtool](https://webpack.js.org/configuration/devtool/)选项，该选项才会生效。用来指定生成的sourcemap文件的名称。
> 当为一个模块生成sourcemap时，可以指定以下占位符`[name]`, `[id]`,  `[hash]`, `[chunkhash]`, `[file]`。一般情况下使用默认值即可，不需要显式地配置，因为用其他的值，当模块不存在时，就出问题了。


### output.sourcePrefix
string
`sourcePrefix: "\t"`
> 指定生成的sourcemap文件每一行开头的前缀。默认情况下使用空字符串，使用该选项的作用仅仅是使sourcemap中的代码看起来要美观一些。不要使用多行前缀，否则引起问题。
> 一般情况下完全没有必要显式的配置该选项。

- 剔除无用的模块？
- 解决无序引入模块？
- 抽取公共模块？