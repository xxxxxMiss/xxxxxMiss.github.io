---
title: finalhandler
date: 2018-12-04 20:28:30
tags:
  - finalhandler
  - http
  - nodejs
categories:
  - nodejs
---

## [finalhandler](https://github.com/pillarjs/finalhandler) 简介

> 作为最后一步去响应一个 http 请求。这个模块被用在[connect](https://github.com/senchalabs/connect)中，作为所有中间的最后一步去响应一个请求。

## API

```js
var finalhandler = require('finalhandler')
```

finalhandler(req, res, [options])

> 调用该函数，返回一个新的函数。这个新的函数会被传入一个`err`。
> 如果这个`err`是个`假值`，那么新的函数会将`res`的响应码设置为`404`。如果`err`是`真值`，那么响应一个错误的`res`。

当错误发生时，以下信息会被设置到`res`上：

- 会将`res`上的`status`或者`statusCode`设置到`res`上。如果该值小于`4xx`或者大于`5xx`，那么`res`上的`statusCode`会被设置为 500。

- 会依据`res.statusCode`设置`res.statusMessage`。

- 如果在生产环境下(process.env.NODE_ENV === 'production'），会响应一个带有状态码信息的 html 页面。否则，打印堆栈信息。

- 任何头信息被指定在`err.headers`对象中。

### options.env

> 默认情况下，环境变量会通过`process.env.NODE_ENV`指定，可以通过该选项重写。

### options.onerror

> 指定一个错误处理函数，会按`onerror(error, req, res)`形式调用。

```js
module.exports = finalhandler

function finalhandler(req, res, options) {
  var opts = options || {}

  // get environment
  var env = opts.env || process.env.NODE_ENV || 'development'

  // get error callback
  var onerror = opts.onerror

  return function(err) {
    var headers
    var msg
    var status

    // ignore 404 on in-flight response
    if (!err && headersSent(res)) {
      debug('cannot 404 after headers sent')
      return
    }

    // unhandled error
    if (err) {
      // respect status code from error
      // 从err对象上取得合法的code
      status = getErrorStatusCode(err)

      if (status === undefined) {
        // fallback to status code on response
        // 从res上取得合法的code
        status = getResponseStatusCode(res)
      } else {
        // respect headers from error
        // 从err.headers上去的一个headers对象
        headers = getErrorHeaders(err)
      }

      // get error message
      // 得到错误信息
      msg = getErrorMessage(err, status, env)
    } else {
      // 如果没有发生错误，那么设置status为404
      // not found
      status = 404
      msg = 'Cannot ' + req.method + ' ' + encodeUrl(getResourceName(req))
    }

    debug('default %s', status)

    // schedule onerror callback
    if (err && onerror) {
      defer(onerror, err, req, res)
    }

    // cannot actually respond
    if (headersSent(res)) {
      debug('cannot %d after headers sent', status)
      req.socket.destroy()
      return
    }

    // send response
    send(req, res, status, headers, msg)
  }
}

// 从一个err对象上取得http状态码
// 优先从status上取，然后再从statusCode上取
// status或者statusCode必须是number类型，并且是一个有效的状态码（>=400 && <600）
// 4xx代表的是客户端的错误，5xx代表的是服务端错误
// 1xx-3xx表示没有错误
function getErrorStatusCode(err) {
  // check err.status
  if (typeof err.status === 'number' && err.status >= 400 && err.status < 600) {
    return err.status
  }

  // check err.statusCode
  if (
    typeof err.statusCode === 'number' &&
    err.statusCode >= 400 &&
    err.statusCode < 600
  ) {
    return err.statusCode
  }

  return undefined
}

// 如果通过getErrorStatusCodes没有取得状态码，那么从res.statusCode上查找
function getResponseStatusCode (res) {
  var status = res.statusCode

  // default status code to 500 if outside valid range
  // 如果status不是一个number类型，或者不是错误状态码或则超出了范围（是一个无效的状态码）
  if (typeof status !== 'number' || status < 400 || status > 599) {
    // 直接赋值为500
    status = 500
  }

  return status
}

// 那么继续在err的headers对象上查找
function getErrorHeaders(err) {
  // err.headers应该是一个对象（此处简单的判断了下）
  if (!err.headers || typeof err.headers !== 'object') {
    return undefined
  }

  var headers = Object.create(null)
  var keys = Object.keys(err.headers)

  // 将err.headers拷贝到headers上
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i]
    headers[key] = err.headers[key]
  }

  return headers
}

// 根据环境的不同，返回不同的错误信息
// 生产环境展示http code对应的错误信息
// 非生产环境展示错误堆栈信息
function getErrorMessage (err, status, env) {
  var msg

  if (env !== 'production') {
    // use err.stack, which typically includes err.message
    msg = err.stack

    // fallback to err.toString() when possible
    if (!msg && typeof err.toString === 'function') {
      msg = err.toString()
    }
  }

  return msg || statuses[status]
}
```

发送最终的响应：

```js
function send (req, res, status, headers, message) {
  function write () {
    // response body
    var body = createHtmlDocument(message)

    // response status
    res.statusCode = status
    res.statusMessage = statuses[status]

    // response headers
    setHeaders(res, headers)

    // security headers
    res.setHeader('Content-Security-Policy', "default-src 'self'")
    res.setHeader('X-Content-Type-Options', 'nosniff')

    // standard headers
    res.setHeader('Content-Type', 'text/html; charset=utf-8')
    res.setHeader('Content-Length', Buffer.byteLength(body, 'utf8'))

    if (req.method === 'HEAD') {
      res.end()
      return
    }

    res.end(body, 'utf8')
  }

  if (isFinished(req)) {
    write()
    return
  }

  // unpipe everything from the request
  unpipe(req)

  // flush the request
  onFinished(req, write)
  req.resume()
}
```