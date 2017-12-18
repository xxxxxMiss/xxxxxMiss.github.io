---
title: vue-base
date: 2017-09-06 11:11:27
tags:
---

## vm.$mount( [elementOrSelector] )
> 该方法返回vue实例本身。`.vue`文件，基本写法都是`export default {}`, 这导出的是一个构造配置选项。
> Vue构造函数如下

```
function Vue (options) {
  if (process.env.NODE_ENV !== 'production' &&
    !(this instanceof Vue)) {
    warn('Vue is a constructor and should be called with the `new` keyword')
  }
  this._init(options)
}
```

所以我们.vue导出的就是构造函数需要的`options`。

如果`options`提供了`el`选项，那么vm实例会挂载到`el`对应的dom元素上（el所对应的元素被vm生成的html字符串替换掉）。如果`options`选项为提供`el`选项，那么生成的vm实例处于未挂载的状态。

但是我们.vue文件中，并未提供`el`选项，但是vm生成的html字符串依然可以正常的渲染在文档流中，为什么？

> 因为我们在搭配路由使用的时候，需要指定`<router-view>`组件，其实该组件就是一个挂载点。

TODO：经常看到`new Vue(options).$mount().$el`, 其实`new Vue(options).$el`返回同样的结果，有什么区别？

## 响应式
> 


## Vue.util
> Vue.util上挂载了一些有用的工具方法

```
var util = Object.freeze({
  defineReactive: defineReactive$$1,
  _toString: _toString,
  toNumber: toNumber,
  makeMap: makeMap,
  isBuiltInTag: isBuiltInTag,
  remove: remove$1,
  hasOwn: hasOwn,
  isPrimitive: isPrimitive,
  cached: cached,
  camelize: camelize,
  capitalize: capitalize,
  hyphenate: hyphenate,
  bind: bind$1,
  toArray: toArray,
  extend: extend,
  isObject: isObject,
  isPlainObject: isPlainObject,
  toObject: toObject,
  noop: noop,
  no: no,
  identity: identity,
  genStaticKeys: genStaticKeys,
  looseEqual: looseEqual,
  looseIndexOf: looseIndexOf,
  isReserved: isReserved,
  def: def,
  parsePath: parsePath,
  hasProto: hasProto,
  inBrowser: inBrowser,
  UA: UA,
  isIE: isIE,
  isIE9: isIE9,
  isEdge: isEdge,
  isAndroid: isAndroid,
  isIOS: isIOS,
  isServerRendering: isServerRendering,
  devtools: devtools,
  nextTick: nextTick,
  get _Set () { return _Set; },
  mergeOptions: mergeOptions,
  resolveAsset: resolveAsset,
  get warn () { return warn; },
  get formatComponentName () { return formatComponentName; },
  validateProp: validateProp
});
```

isServerRendering的实现：
```js
var _isServer;
var isServerRendering = function () {
  if (_isServer === undefined) {
    /* istanbul ignore if */
    if (!inBrowser && typeof global !== 'undefined') {
      // detect presence of vue-server-renderer and avoid
      // Webpack shimming the process
      _isServer = global['process'].env.VUE_ENV === 'server';
    } else {
      _isServer = false;
    }
  }
  return _isServer
};

// vm.$isServer，调用getter，执行isServerRendering函数
Object.defineProperty(Vue$3.prototype, '$isServer', {
  get: isServerRendering
});
```

camelize实现：
> 将连字符变量名转化为驼峰命名

```js
var camelizeRE = /-(\w)/g;
var camelize = cached(function (str) {
  return str.replace(camelizeRE, function (_, c) { return c ? c.toUpperCase() : ''; })
});
```

capitalize实现：
> 将一个单词（变量名）的首字母转化为大写

```js
var capitalize = cached(function (str) {
  return str.charAt(0).toUpperCase() + str.slice(1)
});
```

extend实现：
> 将第二个对象的属性全部拷贝到第一个对象上并返回该对象.
> to上的同名属性会被_from覆盖

```js
function extend (to, _from) {
  for (var key in _from) {
    to[key] = _from[key];
  }
  return to
}
```

## Vue中props的校验

```
/**
 * Use function string name to check built-in types,
 * because a simple equality check will fail when running
 * across different vms / iframes.
 */
// 直接利用正则匹配出函数名
function getType (fn) {
  var match = fn && fn.toString().match(/^\s*function (\w+)/);
  return match && match[1]
}
```

## 默认子路由
> 当一个命名路由需要显示一个默认的子路由时，那么当从一个路由跳转到该路由时，必须使用`path`或则`redirect`来跳转，不能使用路由的名字导航，否则默认子路由无法渲染。

```js
routes: [
  {
    path: '/user', 
    component: User,
    name: 'user'
    children: [
      { path: '', component: UserArticle },
      { path: 'article', component: UserArticle },
      { path: 'follower', component: UserFollower }
    ]
  }
]
```

```html
<!-- 这种情况下是无法渲染默认子路由 article的 -->
<router-link :to="{name: 'user' }"></router-link>

<!-- 必须使用路径，这样就正确了 -->
<router-link :to="{path: '/user/article'}"></router-link>
```

或则在路由配置中使用`redirect`选项:
```js
routes: [
  {
    path: '/user', 
    component: User,
    redirect: '/user/article'
    children: [
      { path: 'article', component: UserArticle },
      { path: 'follower', component: UserFollower }
    ]
  }
]
```

源码参看：line:95 vue-router/src/create-route-map.js