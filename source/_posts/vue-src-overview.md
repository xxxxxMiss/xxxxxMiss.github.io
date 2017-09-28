---
title: vue-src-overview
date: 2017-05-28 19:12:10
tags:
---
## 源码目录总览
```
├── src
│   ├── compiler
│   │   ├── codegen
│   │   │   ├── events.js
│   │   │   └── index.js
│   │   ├── directives
│   │   │   ├── bind.js
│   │   │   ├── index.js
│   │   │   └── model.js
│   │   ├── error-detector.js
│   │   ├── helpers.js
│   │   ├── index.js
│   │   ├── optimizer.js
│   │   └── parser
│   │       ├── entity-decoder.js
│   │       ├── filter-parser.js
│   │       ├── html-parser.js
│   │       ├── index.js
│   │       └── text-parser.js
│   ├── core
│   │   ├── components
│   │   │   ├── index.js
│   │   │   └── keep-alive.js
│   │   ├── config.js
│   │   ├── global-api
│   │   │   ├── assets.js
│   │   │   ├── extend.js
│   │   │   ├── index.js
│   │   │   ├── mixin.js
│   │   │   └── use.js
│   │   ├── index.js
│   │   ├── instance
│   │   │   ├── events.js
│   │   │   ├── index.js
│   │   │   ├── init.js
│   │   │   ├── inject.js
│   │   │   ├── lifecycle.js
│   │   │   ├── proxy.js
│   │   │   ├── render-helpers
│   │   │   │   ├── bind-object-props.js
│   │   │   │   ├── check-keycodes.js
│   │   │   │   ├── render-list.js
│   │   │   │   ├── render-slot.js
│   │   │   │   ├── render-static.js
│   │   │   │   ├── resolve-filter.js
│   │   │   │   └── resolve-slots.js
│   │   │   ├── render.js
│   │   │   └── state.js
│   │   ├── observer
│   │   │   ├── array.js
│   │   │   ├── dep.js
│   │   │   ├── index.js
│   │   │   ├── scheduler.js
│   │   │   └── watcher.js
│   │   ├── util
│   │   │   ├── debug.js
│   │   │   ├── env.js
│   │   │   ├── error.js
│   │   │   ├── index.js
│   │   │   ├── lang.js
│   │   │   ├── options.js
│   │   │   ├── perf.js
│   │   │   └── props.js
│   │   └── vdom
│   │       ├── create-component.js
│   │       ├── create-element.js
│   │       ├── helpers
│   │       │   ├── index.js
│   │       │   ├── merge-hook.js
│   │       │   ├── normalize-children.js
│   │       │   └── update-listeners.js
│   │       ├── modules
│   │       │   ├── directives.js
│   │       │   ├── index.js
│   │       │   └── ref.js
│   │       ├── patch.js
│   │       └── vnode.js
│   ├── entries
│   │   ├── web-compiler.js
│   │   ├── web-runtime-with-compiler.js
│   │   ├── web-runtime.js
│   │   ├── web-server-renderer.js
│   │   ├── weex-compiler.js
│   │   ├── weex-factory.js
│   │   └── weex-framework.js
│   ├── platforms
│   │   ├── web
│   │   │   ├── compiler
│   │   │   │   ├── directives
│   │   │   │   │   ├── html.js
│   │   │   │   │   ├── index.js
│   │   │   │   │   ├── model.js
│   │   │   │   │   └── text.js
│   │   │   │   ├── index.js
│   │   │   │   ├── modules
│   │   │   │   │   ├── class.js
│   │   │   │   │   ├── index.js
│   │   │   │   │   └── style.js
│   │   │   │   └── util.js
│   │   │   ├── runtime
│   │   │   │   ├── class-util.js
│   │   │   │   ├── components
│   │   │   │   │   ├── index.js
│   │   │   │   │   ├── transition-group.js
│   │   │   │   │   └── transition.js
│   │   │   │   ├── directives
│   │   │   │   │   ├── index.js
│   │   │   │   │   ├── model.js
│   │   │   │   │   └── show.js
│   │   │   │   ├── modules
│   │   │   │   │   ├── attrs.js
│   │   │   │   │   ├── class.js
│   │   │   │   │   ├── dom-props.js
│   │   │   │   │   ├── events.js
│   │   │   │   │   ├── index.js
│   │   │   │   │   ├── style.js
│   │   │   │   │   └── transition.js
│   │   │   │   ├── node-ops.js
│   │   │   │   ├── patch.js
│   │   │   │   └── transition-util.js
│   │   │   ├── server
│   │   │   │   ├── directives
│   │   │   │   │   ├── index.js
│   │   │   │   │   └── show.js
│   │   │   │   ├── modules
│   │   │   │   │   ├── attrs.js
│   │   │   │   │   ├── class.js
│   │   │   │   │   ├── dom-props.js
│   │   │   │   │   ├── index.js
│   │   │   │   │   └── style.js
│   │   │   │   └── util.js
│   │   │   └── util
│   │   │       ├── attrs.js
│   │   │       ├── class.js
│   │   │       ├── compat.js
│   │   │       ├── element.js
│   │   │       ├── index.js
│   │   │       └── style.js
│   │   └── weex
│   │       ├── compiler
│   │       │   ├── directives
│   │       │   │   ├── index.js
│   │       │   │   └── model.js
│   │       │   ├── index.js
│   │       │   └── modules
│   │       │       ├── append.js
│   │       │       ├── class.js
│   │       │       ├── index.js
│   │       │       ├── props.js
│   │       │       └── style.js
│   │       ├── framework.js
│   │       ├── runtime
│   │       │   ├── components
│   │       │   │   ├── index.js
│   │       │   │   ├── transition-group.js
│   │       │   │   └── transition.js
│   │       │   ├── directives
│   │       │   │   └── index.js
│   │       │   ├── index.js
│   │       │   ├── modules
│   │       │   │   ├── attrs.js
│   │       │   │   ├── class.js
│   │       │   │   ├── events.js
│   │       │   │   ├── index.js
│   │       │   │   ├── style.js
│   │       │   │   └── transition.js
│   │       │   ├── node-ops.js
│   │       │   ├── patch.js
│   │       │   └── text-node.js
│   │       └── util
│   │           └── index.js
│   ├── server
│   │   ├── create-bundle-renderer.js
│   │   ├── create-bundle-runner.js
│   │   ├── create-renderer.js
│   │   ├── render-context.js
│   │   ├── render-stream.js
│   │   ├── render.js
│   │   ├── source-map-support.js
│   │   └── write.js
│   ├── sfc
│   │   └── parser.js
│   └── shared
│       └── util.js
```

### 生命周期
> src/core/instance/lifecycle.js

```js
export function callHook (vm: Component, hook: string) {
  const handlers = vm.$options[hook]
  if (handlers) {
    // 从此处可以看出一个钩子，可以对应多个处理器
    for (let i = 0, j = handlers.length; i < j; i++) {
      try {
        handlers[i].call(vm)
      } catch (e) {
        handleError(e, vm, `${hook} hook`)
      }
    }
  }
  if (vm._hasHookEvent) {
    vm.$emit('hook:' + hook)
  }
}
```


就是说你可以这样：
```
new Vue({
    created: [
        function(){ console.log('hook-created-1') },
        function(){ console.log('hook-created-2') }
    ]    
})
```

### data, props, computed, methods, watch相关
> src/core/instance/state.js

```
function initComputed (vm: Component, computed: Object) {
  const watchers = vm._computedWatchers = Object.create(null)

  for (const key in computed) {
    const userDef = computed[key]
    // 如果计算属性不是函数，那么应该是一个对象，并且应该提供一个get方法
    const getter = typeof userDef === 'function' ? userDef : userDef.get
    // create internal watcher for the computed property.
    watchers[key] = new Watcher(vm, getter, noop, computedWatcherOptions)

    // component-defined computed properties are already defined on the
    // component prototype. We only need to define computed properties defined
    // at instantiation here.
    if (!(key in vm)) {
      defineComputed(vm, key, userDef)
    }
  }
}
```

在通过下面定义的`defineComputed`, 可以知道我们还可以这样定义计算属性：

```
new Vue({
    computed: {
        name: {
            cache: true,
            get(){
                return 'xxx'
            },
            set(){
                
            }
        }
    }    
})
```