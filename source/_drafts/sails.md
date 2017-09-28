---
title: sails
tags:
  - nodejs
  - sails
categories: nodejs
---

## sails(v0.12) 目录结构
```
├── Gruntfile.js
├── README.md
├── api // 核心
│   ├── controllers // 充当model和view的桥梁
│   ├── models
│   ├── policies
│   ├── responses
│   └── services
├── app.js
├── assets
│   ├── favicon.ico
│   ├── images
│   ├── js
│   ├── robots.txt
│   ├── styles
│   └── templates
├── config
│   ├── blueprints.js
│   ├── bootstrap.js
│   ├── connections.js
│   ├── cors.js
│   ├── csrf.js
│   ├── env
│   ├── globals.js
│   ├── http.js
│   ├── i18n.js
│   ├── local.js
│   ├── locales
│   ├── log.js
│   ├── models.js
│   ├── policies.js
│   ├── routes.js
│   ├── session.js
│   ├── sockets.js
│   └── views.js
├── config.yaml
├── package.json
├── tasks // 不启用grunt,可以直接删除tasks文件夹
│   ├── README.md
│   ├── config
│   ├── pipeline.js
│   └── register
└── views // 不需要服务端渲染,可以直接删除views文件夹
    ├── 403.ejs
    ├── 404.ejs
    ├── 500.ejs
    ├── homepage.ejs
    └── layout.ejs
```

## controller
> 由一系列被称为`action`的方法构成,`action`和`routes`绑定在一起，所以当请求某一个路由时，触发对应的对应的路由方法，并返回一个响应(这里的响应主要指路由的分发)

### controller的定义
>在`sails`中`controller`定义在`controller`文件夹下，按照约定，全部采用[pascal-case](http://baike.baidu.com/link?url=kjvNUyU140pHXUqZO4h4_tnPfpr6OudXYBe4ArkaZEEjggrCIOY0w-XrNStkdgcPJjlWo-v2kIPvZRQ4y_T2r_RceI9rx_8jZaaQwqXs2iW)写法（及每个单词的首字母都是大写），并且必须必须以`Controller.js`结尾。
- NOTE: 可以将`controller`分文件夹定义，那么此时子文件夹也会成为路由标示的一部分。

### 代码演示
`SayController.js`
```
// 一个controller就是一个纯对象，对象的属性为action的名字，值为对应的action的处理函数
module.exports = {
    // req, res跟express中的一样，不过没有第三个参数next
    // 如果有next的需求，那么应该见该逻辑写到policies中
    hi: function (req, res) {
      return res.send('Hi there!');
    },
    bye: function (req, res) {
      return res.redirect('http://www.sayonara.com');
    }
}
```

### 隐式路由（sails自动绑定）
```
 /:controllerIdentity/:nameOfAction
 /controller标识符/action的名字
```
> 拿上面的`SayController.js`来说，那么当程序启动时，就会自动绑定到这样的路由`/say/hi`, `/say/bye`。
> 如果上面的`controller`在一个子文件夹中`/we`中，那么就会绑定到这样的路由`/we/say/hi`, `/we/say/bye`

### 显式路由（自定义路由）
>手动绑定路由，可以在`config/routes.js`中按照如下规则进行路由的配置:
>http请求方法（POST,GET等）+ 路由地址 : `controller`的名字+`.`+`action`的名字

```
'POST /make/a/sandwith': 'SandwichController.makeIt'

// 当controller在子文件夹中定义时，子文件夹是controller的一部分
'/do/homework': 'stuff/things/HomeworkController.do'
```

### 显式路由常见定义方式
```
module.exports.routes = {
  'get /signup': { view: 'conversion/signup' },
  'post /signup': 'AuthController.processSignup',
  'get /login': { view: 'portal/login' },
  'post /login': 'AuthController.processLogin',
  '/logout': 'AuthController.logout',
  'get /me': 'UserController.profile'
}
```

## 自定义响应和`responses`文件夹
> 一般情况下，`controller`中的响应都会定义在`responses`文件夹中.
> 任何定义在`/api/responses`中的`.js`中的脚本都是通过`res.[responsesName]`这种形式在`controller`中调用的。
> 在`responses`函数中，可以使用`this.req`, `this.res`来获取`Request`和`Response`对象。 

## 数据库适配器Adapters
> 指”数据库适配器“（可以连接不同的数据库），主要用来和数据库之间的通信。
> 在`adapter`中，我们主要关注的是`CRUD`操作。
> 在`sails`中，主要指这个几个方法`create()`, `find()`, `update()`, `destroy()`

### 可选的Adapter
- 官方支持的数据库器

| 数据库名称 | 简介 |
| ----- | ----- |
| sails-disk| sails默认捆绑的，不需要做任何的配置。直接将数据写入磁盘，不适合用在生成环境，一般用在开发环境或者一些小的项目中 |
| sails-memory | 将数据写入内存中，不会正在的持久化，所以一般适合用在开发环境或者磁盘空间不足的时候 |
| sails-mysql | 链接mysql（关系型数据库） |
| sails-postgres | 链接postgres(关系型数据库) | 
| sails-mongo | 链接mongo(非关系型数据库) | 
| sails-redis | 链接redis |

- 社区支持的数据库

## 全局变量
> 全局变量可以在`sails`**加载完毕之后**全局访问，这些全局变量都可以在`config/globals.js`中禁用。
- models(文件名作为全局变量名)
- services(文件名作为全局变量名)
- sails
- _(Lodash实例，默认提供，无需安装)
- async(Async实例，默认提供，无需安装)

NOTE: 必须等到`sails`加载完成之后，才可以访问这些全局变量。也就是说，不能再导出的函数外部使用（此时`sails`尚未加载完毕）,必须导出的函数内部使用

```
// 禁用所有
module.exports.globals = false

module.exports.globals = {
    _: false, // 禁用具体的
    async: true
}
```


## 日志（Logging）
> `sails`内建一个日志输出，可以在`/config/logs.js`中配置日志输出等级。
> 详情参看[sails内建日志](http://sailsjs.com/documentation/concepts/logging)

## 原则（Policies）
> 该文件夹中定义的脚本主要用来处理一些`权限认证`，`第三方单点登录`等具有一些通用逻辑，有点类似于`spring`中的`AOP`。
> `policies`只应该在`controller`的`actions`中使用，不应该在`views`中使用。如果是在`config/routes.js`中直接定义的视图，那么就无法使用`policies`了。如果想要继续使用使用`policies`,因该使用`controller`+`.`+`action`的方式。
如下:

```
// routes.js

module.exports.routes = {
    // 这种形式无法使用policies
    '/': 'homepage', 

    // 可以这种方式
    'POST /article/comment': 'ArticleController.comment'
}
```

### Policies的定义
> 定义在`api/policies`目录下，每个`policy`应该对应一个文件，只处理一件事情，导出为单一的函数。
> 事实上，每个`policies`都是作为`Connect/Express`中间件的函数，在`controller`之前执行。

```
// 只处理一件事情，导出为单一函数
module.exports = function canWrite(req, res, next){

}
```

### `api/policies`和`config/policies.js`的关系
> 在`config/policies.js`中配置`controller`和`policies`之间的映射关系。就是说哪些`controller`使用哪些`policies`来做权限控制。

```
module.exports.policies = {
    CommentController: { // controller名称
        "*": 'isLoggedIn', // 对controller中所有的action生效
        create: 'isLoggedIn',  // key: action名称， value: policies
        tag: ['isLoggedIn', 'isAdmin']
    }
}
```

```
module.exports.policies = {
    "*": 'isLoggedIn', // 映射到所有的controller中的actions
    CommentController: {
        // 如果某一个action显式的声明了policy, 那么全局的`isLoggedIn`不会映射到该action上
        create: 'isAdmin' 
    }
}
```

## Services
> 一个导出各种函数的纯对象，对象中的每个对象被称为`helper`。
> 因为是全局的，所以可以在各个地方使用：`controller`的`actions`, 其他的`services`, 自定义的`model`方法中，甚至在命令行脚本中。

### Service的创建
> 在`api/services`文件夹中创建，文件名必须以`Service.js`结尾。

### Service函数参数说明
```
var Mailgun = require('machinepack-mailgun');

module.exports = {
  sendWelcomeEmail: function (options, done) {
    Mailgun.sendHtmlEmail({
      toEmail: options.emailAddress,
      toName: options.firstName
    }).exec(function (err) {
      if (err) { return done(err); }
      return done();
    });
  }
}
```

`sendWelcomeEmail`方法中`option`,`done`参数说明：
- option: 一个自定义属性的对象。
- done: 一个函数。这个一个可选的参数，当`helper`为一个异步方法时，那么当`helper`被调用时，必须传入`done`回调函数作为第二个参数。
- 按照nodejs的约定，`done`中第一个参数为一个`error`对象，第二个参数为需要的数据结果。


## Session
在`sails`中，session主要由一下3部分要素组成：
- `session store`: 保存信息
- 管理`session`的中间件
- 每次请求都会携带`cookie`,并且`session id`（默认的`sails.sid`）都会被存储到`cookie`中
> `session store`既可以是内存（`sails`中默认使用内存存储）,也可以是数据库。`sails`在`Connect`中间件的最顶层管理`session`，包括将`session id`保存到`cookie`中。

## Views
`views`的使用,一般有2种方法：
- res.view(), 由于可以在各个都可以使用`res`对象，所以可以用这种方式方式将`view`编译成功`html`返回给客户端
- 在`/config/routes.js`中对路由进行配置

### locals
> 在模板引擎中使用的变量称为`locals`, `sails`默认传入一些变量作为`locals`,比如`lodash`。如果某些数据是通过硬编码的方式填充到模板中，那么可以在`config/routes.js`中配置：

```
module.exports.routes = {
    'get /profile': {
        view: 'backOffice/profile',
        locals: { // 硬编码的数据，可以直接通过locals配置
          user: {
            name: 'Frank',
            emailAddress: 'frank@enfurter.com'
          },
          corndogs: [
            { name: 'beef corndog' },
            { name: 'chicken corndog' },
            { name: 'soy corndog' }
          ]
        }
      }
}
```

### 在模板中使用动态数据
> 大多数时候，数据都是动态获取到的（通过action从model中获取），所以大多时候是按照如下方式进行渲染数据的：

```
// in api/controllers/UserController.js...

  profile: function (req, res) {
    // ...
    return res.view('backOffice/profile', {
      user: theUser,
      corndogs: theUser.corndogCollection
    });
  },
  // ...
```

### Partials(模板包含)
> 支持模板包含，及在一些模板中，将另外一些模板包含进来，达到模板的复用。在`sails`中使用模板包含，需要注意的就是路径都是相对于`view`文件夹的。如

```
// views/partials/widget.ejs

// views/pages/dashboard/user-profile.ejs
<%- partial('../../partials/widget.ejs') %>
```


## 关于`EJS`模板
> 在`ejs`中，模板的标签就以下3种：
- `<%= %>`: 转义输出
- `<%- %>`: 不转义输出
- `<% %>`: 里面直接写js代码


## models文件夹
>全局访问

## services文件夹
>全局访问

## responses文件夹
>里面的方法都会挂载到`controller`的`req`对象上