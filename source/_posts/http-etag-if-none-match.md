---
title: http-etag-if-none-match
date: 2018-11-19 20:57:22
tags:
  - http
  - etag
  - if-none-match
categories:
  - http
---

## ETag简介
> 是资源的特定版本的标识符，这可以让缓存更高效，并节省带宽，因为如果内容没有改变，Web服务器不需要发送完整的响应。ETag有强弱之分：

- `W/"<etag_value>"`: 弱验证器很容易生成，但不利于比较。 强验证器是比较的理想选择，但很难有效地生成。 相同资源的两个弱Etag值可能语义等同，但不是每个字节都相同。

- `"<etag_value>"`: 没有明确指定生成ETag值的方法。 通常，使用内容的散列。

## [nodjs etag模块](https://github.com/jshttp/etag)
etag(entity, options)
> entity: 可以是`String`, `Buffer`, `fs.Stats`
> options.weak: 是否生成弱的etag, 默认为false（即默认生成强的etag），但是如果`entity`为`fs.Stats`，那么生成弱的etag。

``` js
// 只列出核心代码，一些对参数的校验啥的已略过
function etag (entity, options) {
  // 判断entity是否为fs.Stats类型
  var isStats = isstats(entity)
  var weak = options && typeof options.weak === 'boolean'
    ? options.weak
    : isStats

  // generate entity tag
  var tag = isStats
    ? stattag(entity)
    : entitytag(entity)

  return weak
    ? 'W/' + tag // 弱etag
    : tag
}

// 弱的etag是根据fs.Stats生成
function stattag (stat) {
  // 得到mtime时间戳的16进制
  var mtime = stat.mtime.getTime().toString(16)
  // 得到size的16进制
  var size = stat.size.toString(16)
  // 按照规范etag，应该用双引号包裹生成的字符串。
  return '"' + size + '-' + mtime + '"'
}
// 强tag，是将buffer或者字符串进行sha1，
// 在进行base64编码，在截取前27位
function entitytag (entity) {
  if (entity.length === 0) {
    // fast-path empty
    return '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"'
  }

  // compute hash of entity
  var hash = crypto
    .createHash('sha1')
    .update(entity, 'utf8')
    .digest('base64')
    .substring(0, 27)

  // 获取字符串或者buffer的字节数
  var len = typeof entity === 'string'
    ? Buffer.byteLength(entity, 'utf8')
    : entity.length

  // " + 字节数的16进制 + 连接符 + hash + " => 强etag
  return '"' + len.toString(16) + '-' + hash + '"'
}
```

## http缓存机制
> 主要由以下请求头和响应头控制：

- Expires
- Cache-Control
- Last-Modified
- [If-Match](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/If-Match)
- [If-None-Match](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/If-None-Match)
- [If-Modified-Since](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/If-Modified-Since)
- [If-Unmodified-Since]((https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/If-Unmodified-Since))
- Etag

### Cache-Control易混淆点解释
> Cache-Control响应头中常用字段的具体含义：

- max-age：用来设置资源可以被缓存多长时间，单位为秒；

- s-maxage：和max-age是一样的，不过它只针对代理服务器缓存而言；

- public：指示响应可被任何缓存区缓存（服务器，代理，客户端）；

- private：只能针对个人用户，而不能被代理服务器缓存；

- no-cache：强制客户端直接向服务器发送请求,也就是说每次请求都必须向服务器发送。服务器接收到请求，然后判断资源是否变更，是则返回新内容，否则返回304，未变更。这个很容易让人产生误解，使人误以为是响应不被缓存。实际上Cache-Control: no-cache是会被缓存的，只不过每次在向客户端（浏览器）提供响应数据时，缓存都要向服务器评估缓存响应的有效性。

- no-store：禁止一切缓存（这个才是响应不被缓存的意思）。

## 常用条件请求的搭配之一
> `ETag`和`If-None-Math`，原理解释如下：

1. 第一次请求由服务端生成etag，并随响应头一起返回给客户端
2. 当你第二次发起*同一个请求*时，客户端会发送一个`If-None-Match`的请求头，该请求头的值就是etag的值。然后服务器会将客户端发送过来的etag与自己保存的etag做比较。如果是一样的，那么就返回`304`，表明客户端可以继续使用本地缓存。否则就返回`200`，客户端重新解析服务器返回的数据。

### 演示demo
文件结构：
--
|-rxjs
    |-index.html
|-server.js
|-client.html

客户端：
client.html
``` html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
</head>
<body>
  <a href="http://127.0.0.1:3000">测试链接</a>
</body>
</html>
```

服务端
server.js
``` js
const http = require('http')
const serveStatic = require('serve-static')
const finalhandler = require('finalhandler')

// rxjs是和该脚本放在同一个目录下的一个文件夹
// 可以在rxjs文件夹下放置一个index.html
// 修改rxjs/index.html中的内容，然后观察network中etag和if-none-match的变化以及stausCode的变化
const serve = serveStatic('rxjs')
const server = http.createServer((req, res) => {
  serve(req, res, finalhandler(req, res))
})

server.listen(3000, () => {
  console.log('Server is listening port: 3000')
})
```

## Last-Modified & If-Modified-Since

Last-Modified与Etag类似。不过Last-Modified表示响应资源在服务器最后修改时间而已。与Etag相比，不足为：

- Last-Modified标注的最后修改只能精确到秒级，如果某些文件在1秒钟以内，被修改多次的话，它将不能准确标注文件的修改时间；

- 如果某些文件会被定期生成，当有时内容并没有任何变化，但Last-Modified却改变了，导致文件没法使用缓存；

- 有可能存在服务器没有准确获取文件修改时间，或者与代理服务器时间不一致等情形。

然而，Etag是服务器自动生成或者由开发者生成的对应资源在服务器端的唯一标识符，能够更加准确的控制缓存。
