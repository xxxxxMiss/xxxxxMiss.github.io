---
title: connect源码解读
date: 2018-11-27 22:02:53
tags:
  - nodejs
  - http
  - connect
categories:
  - nodejs
---

## connect 简介

> connect 是一款极简的 web 框架，粘合各种中间件来处理请求。

## API

```js
// require module
const connect = require('connect')

// create app
const app = connect()
```

### app(req, res[, next])

> `app`本身也是一个函数，他是`app.handle`的一个别名。

```js
module.exports = createServer

function createServer() {
  function app(req, res, next) {
    app.handle(req, res, next)
  }
  // 将proto上的方法拷贝到app上
  // proto是一个对象，该对象上只有use, handle, listen三个方法
  merge(app, proto)
  // 将EventEmitter原型链上的方法拷贝到app上
  merge(app, EventEmitter.prototype)
  app.route = '/'
  // 该stack属性就是用来存放所有的中间件
  app.stack = []
  // 返回的是一个function，并且接收(req, res, next)形式的参数
  // 这样就可以将这个返回的函数传入到nodejs原生的http或者https的createServer中
  // 后面要解读的listen方法，默认使用http模块
  // 通过返回这种形式的函数，就可以在http或者https模块之间切换
  return app
}
```

### app.listen([...])

> 就是对 nodejs 中`http.Server#listen`方法一个简单的封装。

```js
proto.listen = function listen() {
  // 因为调用都是通过app.listen，所有此处的this就是app
  // 而上面已经介绍了app是一个接收(req, res, next)的函数
  var server = http.createServer(this)
  // 调用server上的listen方法
  return server.listen.apply(server, arguments)
}
```

### app.use(fn)

> 这个方法就是添加各种中间件到`app.stack`中。
> 还有一个类似的方法`app.use(route, fn)`，其实`app.use(fn)`可以看成是`app.use('/', fn)`。

```js
proto.use = function use(route, fn) {
  var handle = fn
  var path = route

  // default route to '/'
  // 这个就是处理app.use(fn)的情况
  if (typeof route !== 'string') {
    handle = route
    path = '/'
  }

  // wrap sub-apps
  if (typeof handle.handle === 'function') {
    var server = handle
    server.route = path
    handle = function(req, res, next) {
      server.handle(req, res, next)
    }
  }

  // wrap vanilla http.Servers
  // 这种情况用来处理fn是一个http.Server实例，
  // 就是说你可以传入一个http.Server实例作为中间件
  if (handle instanceof http.Server) {
    // 因为http.Server继承了EventEmitter,所以有listeners方法
    // 取request事件中的第一个监听器作为中间件
    handle = handle.listeners('request')[0]
  }

  // strip trailing slash
  // 当你请求的路径为`/path/name/`,就是末尾带有斜杆
  // 那么会剔除末尾的斜杆
  // 其实路径末尾带有斜杆，表示的是一个文件夹，
  if (path[path.length - 1] === '/') {
    path = path.slice(0, -1)
  }

  // add the middleware
  debug('use %s %s', path || '/', handle.name || 'anonymous')
  // 将中间件和请求的路径添加到一个对象上，然后将该对象推入app.stack中
  this.stack.push({ route: path, handle: handle })

  // 返回app，可以形成链式调用，如： app.use(fn).listen()
  return this
}
```

### app.handle(req, res[, out])

> 这个方法用来处理服务器请求，模块导出的 app 内部就是调用该方法。

```js
proto.handle = function handle(req, res, out) {
  // 这个变量用来控制中间件是否已经全部结束
  var index = 0
  var protohost = getProtohost(req.url) || ''
  var removed = ''
  var slashAdded = false
  // 拿到所有的中间件
  var stack = this.stack

  // final function handler
  var done =
    out ||
    finalhandler(req, res, {
      env: env,
      onerror: logerror
    })

  // store the original URL
  // 因为我们要对一些边缘情况的url做处理，
  // 所以此处会把请求原始的url挂载到req的originUrl上
  req.originalUrl = req.originalUrl || req.url

  // 这个next方法就是每个中间件的next
  // 使用它来控制是否继续执行下一个中间件
  function next(err) {
    if (slashAdded) {
      req.url = req.url.substr(1)
      slashAdded = false
    }

    if (removed.length !== 0) {
      req.url = protohost + removed + req.url.substr(protohost.length)
      removed = ''
    }

    // next callback
    // 每次调用next都会从stack中取出一个中间件
    var layer = stack[index++]

    // all done
    // 如果不存在，说明中间件已经全部执行完毕，
    // 那么执行最后的一个收尾操作
    // 你可以自定义收尾操作，没有定义就使用finalhandler这个模块来处理
    if (!layer) {
      defer(done, err)
      return
    }

    // route data
    // parseUrl是一个npm包，功能跟nodjs自带的url模块的parse方法一样，
    // 只不过加入了缓存处理，如果每次拿到相同的url就不在解析，直接返回缓存中的结果
    // 这个path是你请求的path
    var path = parseUrl(req).pathname || '/'
    // 这个route是你在调用app.use(route, fn)中的route
    var route = layer.route

    // skip this layer if the route doesn't match
    // 因为url是不区分大小写的,所以此处使用toLowerCase来统一处理
    // 如果route为：/blog，path为：/blog/post，
    // 这个时候app.use('/blog', fn)中的fn是会执行的
    // 此处用来处理path和route没有这种包含关系，那么跳过执行fn
    if (path.toLowerCase().substr(0, route.length) !== route.toLowerCase()) {
      return next(err)
    }

    // skip if route match does not border "/", ".", or end
    // 如果path为：/blog-post, route为：/blog
    // 这种情况不满足包含关系，那么也跳过这个中间件的执行

    // 如果path为：/blog.或者/blog/, route为：/blog
    // 这种情况也视为满足包含关系，也就是说会执行对应的中间件
    var c = path.length > route.length && path[route.length]
    if (c && c !== '/' && c !== '.') {
      return next(err)
    }

    // trim off the part of the url that matches the route
    if (route.length !== 0 && route !== '/') {
      removed = route
      req.url = protohost + req.url.substr(protohost.length + removed.length)

      // ensure leading slash
      if (!protohost && req.url[0] !== '/') {
        req.url = '/' + req.url
        slashAdded = true
      }
    }

    // call the layer handle
    // 开始调用中间件
    call(layer.handle, route, err, req, res, next)
  }

  next()
}
```
