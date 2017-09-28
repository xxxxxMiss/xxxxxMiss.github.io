---
title: share-vue
date: 2017-08-12 12:30:54
tags: 
    - js
    - frontend-framework
categories:
    - vue
---

### 目录结构
```
├── README.md
├── build
│   ├── build.js
│   ├── check-versions.js
│   ├── dev-client.js
│   ├── dev-server.js
│   ├── utils.js
│   ├── vue-loader.conf.js
│   ├── webpack.base.conf.js
│   ├── webpack.dev.conf.js
│   ├── webpack.prod.conf.js
│   └── webpack.test.conf.js
├── config
│   ├── dev.env.js
│   ├── index.js
│   ├── prod.env.js
│   └── test.env.js
├── deploy.sh
├── dist
│   ├── email_tpl
│   │   ├── template.html
│   │   ├── template_h5.html
│   │   └── template_h5_2.html
│   ├── index.html
│   └── static
│       ├── css
│       ├── fonts
│       ├── img
│       └── js
├── index.html
├── npm-debug.log
├── package-lock.json
├── package.json
├── src
│   ├── App.vue
│   ├── assets
│   │   └── js
│   ├── components
│   │   └── modal
│   ├── config.js
│   ├── filters
│   │   └── index.js
│   ├── main.js
│   ├── router
│   │   └── index.js
│   ├── views
│   │   ├── Edm-Item.styl
│   │   ├── Edm-Item.vue
│   │   ├── EdmProgress-Item.styl
│   │   ├── EdmProgress-Item.vue
│   │   ├── EdmProgress.styl
│   │   ├── EdmProgress.vue
│   │   ├── H5Progress-Item.styl
│   │   ├── H5Progress-Item.vue
│   │   ├── Index.styl
│   │   ├── Index.vue
│   │   ├── Share-Item.styl
│   │   ├── Share-Item.vue
│   │   ├── Signin.styl
│   │   ├── Signin.vue
│   │   ├── Tags-Item.styl
│   │   ├── Tags-Item.vue
│   │   ├── Task-H5.styl
│   │   ├── Task-H5.vue
│   │   ├── Task-Send.styl
│   │   ├── Task-Send.vue
│   │   ├── Task.styl
│   │   ├── Task.vue
│   │   ├── Tpl-H5.styl
│   │   ├── Tpl-H5.vue
│   │   ├── Uploadlogo-Item.styl
│   │   └── Uploadlogo-Item.vue
│   └── vuex
│       ├── getters.js
│       ├── mutations.js
│       └── store.js
├── static
│   ├── css
│   │   └── base.css
│   ├── email_tpl
│   │   ├── template.html
│   │   ├── template_h5.css
│   │   ├── template_h5.html
│   │   ├── template_h5_2.css
│   │   └── template_h5_2.html
│   └── img
│       
├── test
│   ├── e2e
│   │   ├── custom-assertions
│   │   ├── nightwatch.conf.js
│   │   ├── runner.js
│   │   └── specs
│   └── unit
│       ├── index.js
│       ├── karma.conf.js
│       └── specs
├── test.txt
├── yarn-error.log
└── yarn.lock
```

### 一个快速查看文档的npm命令
```
npm docs <package-name>
```

### 环境配置
- 开发环境
```js
process.env.NODE_ENV === 'development'
```

- 测试环境
```js
process.env.NODE_ENV === 'test'
```

- 生产环境
```js
process.env.NODE_ENV === 'production'
```

### 跨域处理
- 浏览器同源策略：同源策略限制从一个源加载的文档或脚本如何与来自另一个源的资源进行交互。这是一个用于隔离潜在恶意文件的关键的安全机制。
- 一个*源*的定义：如果协议，端口（如果指定了一个）和域名对于两个页面是相同的，则两个页面具有相同的源
- [一个URL的组成部分](https://nodejs.org/dist/latest-v8.x/docs/api/url.html)
{% asset_img url-part.png url组成部分 %}

#### 使用jsonp跨域
> 只能发送GET请求，但是支持老的浏览器

#### 使用html5 CORS跨域
- Access-Control-Allow-Origin: '*'(required)

> 可设置为origin或者origin下具体的某一个path

- Access-Control-Allow-Credentials: true(optional)

> 表示是否允许发送cookie

- Access-Control-Expose-Headers: X-Field(optional)

> CORS请求时，XMLHttpRequest对象的getResponseHeader()方法只能拿到6个基本字段：Cache-Control、Content-Language、Content-Type、Expires、Last-Modified、Pragma。如果想拿到其他字段，就必须在Access-Control-Expose-Headers里面指定。上面的例子指定，getResponseHeader('X-Field')可以返回X-Field字段的值。

client:
``` js
    var myRequest = new Request('http:127.0.0.1:8080/get-list', {
        method: 'GET',
        // no-cors, cors, same-origin, navigate
        mode: 'same-origin' // 默认值，所以不是同源策略就会出现跨域
    })

    fetch(myRequest).then(res => {
        return res.json()
    }).then(json => {
        console.log(json)
    })
```

server:
```
const http = require('http')
const server = http.createServer((req, res) => {
   // res.setHeader('Access-Control-Allow-Origin', '*')    
   res.end(JSON.stringify({
        name: 'javascript',
        price: 50
    }))
})
server.listen(8080, _ => {
    console.log('server has setup, listening at port: 8080')    
})
```

#### 代理
```
proxyTable: {
    '/api': 'http://edmserver.cheng95.com'
}
```

### js设计模式之publish/subscribe
> 解耦具体的业务代码和组件/插件内部的代码。
> 一个弹出层，有确定，取消2个按钮，组件内部帮我们实现好的效果是：点击确定，取消2个按钮，弹出层都会消失，但是点击确定按钮的时候，我们要实现一些自己的业务逻辑。比如点击确定的时候，发送一个请求到后台。通过publish/subscribe就可以很好的实现这种组件/插件内部的代码和我们自己具体的业务代码相分离。

vue源码位置：src/core/instance/events.js

### vue组件通信
#### 父子组件通信
> 因为vue使用的单向数据流（数据只能从父组件流向子组件），所以子组件不能直接修改从父组件传递过来的props，如果要修改，必须通过事件的形式。
- `vm.$on`
- `vm.$once`
- `vm.$emit`
- `vm.$off`

#### 兄弟组件通信
> 组件之间没有父子关系，常用解决方案：Event Bus(事件总线)，就是通过一座桥梁将没有关系的组件联系起来。
> 其实根组件就是他们之间的这座桥梁，但是根组件上默认已经挂载了很多东西，所以一般情况下会使用一个空的Vue实例来充当这个事件总线。

例如2个兄弟组件，一个按钮，一个段落，通过点击按钮来修改段落中的文字
```html
<div id="app">
    <x-button></x-button>
    <c></c>
</div>
```

```js
const vm = new Vue()
Vue.component('x-button', {
    data(){
        return {
            count: 1
        }
    },
    template: '<button @click="setMsg">测试按钮</button>',
    methods: {
        setMsg(){
            vm.$emit('set-msg', `count is: ${this.count++}`)
        }
    }
})

Vue.component('c', {
    data(){
        return {
            msg: '这是默认值'
        }
    },
    template: '<p>{{msg}}</p>',
    created(){
        vm.$on('set-msg', msg => {
            this.msg = msg    
        })
    }
})

const app = new Vue({
    el: '#app'
})
```

#### 使用vuex来管理app数据
> vuex是用来管理整个应用的数据，vuex中的数据可以被任何组件访问。所以vuex也是组件之间通讯的一种方案，至于到底用不用vuex，哪些数据要放到vuex中管理，取决于具体情况。

### .native修饰符
> vue组件之间的通信，可以通过事件系统，但这些事件并不是原生的事件。dom操作离不开原生事件，vue提供了`.native`修饰符来绑定原生事件（内部使用addEventListener）。对于刚刚接触vue的人来说，可能思想难以转变，喜欢直接操作dom。通过`.native`修饰符，我们可以像`vm.$on`一样来绑定原生事件。

假如在登录的时候，既可以通过点击登录按钮进行登录，也可以通过敲击`enter`键进行登录, html代码如下：
```html
<el-form-item>
  <el-input type="password"
    ref="password"
    v-model="password" placeholder="请输入密码"></el-input>
</el-form-item>
<el-form-item>
  <el-button type="primary" size="large"
    @click.prevent="signin"
    :disabled="!signinBtnActive">登录</el-button>
</el-form-item>
```

很多时候，你可能会这样来绑定事件
```js
this.$refs.password.$el.addEventListener('keyup', e => {
    if(e.keyCode === 13){
        this.signin() // 登录操作
    }
})
```

其实vue提供了`.native`修饰符来绑定原生事件，提供了`.enter`修饰符来表示按的键是`enter`键，所以我们可以用更加优雅的方式来书写：
```html
<el-input type="passowd" v-model="password"
    @keyup.native.enter="signin"></el-input>
```

### ES6

### 代码风格
[npm推荐的代码风格](https://docs.npmjs.com/misc/coding-style)

### documents
- [vue](https://cn.vuejs.org/v2/guide/installation.html)
- [vue-router](https://router.vuejs.org/zh-cn/)
- [vuex](https://vuex.vuejs.org/zh-cn/)
- [stylus](http://stylus-lang.com/)
- [axios](https://github.com/mzabriskie/axios)
- [webpack2](https://webpack.js.org/concepts/)
- [ElementUI](http://element.eleme.io/#/zh-CN/component/installation)
- [http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)
- [CORS跨域](http://www.ruanyifeng.com/blog/2016/04/cors.html)