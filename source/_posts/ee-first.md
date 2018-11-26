---
title: ee-first模块源码解读
date: 2018-11-26 21:51:16
tags:
  - nodejs
  - events
  - ee-first
categories:
  - nodejs
---

## ee-first

> 从一个事件列表中触发一个事件，一旦触发了该事件之后，就会移除该事件及其他所有的事件。

## API

```js
const first = require('ee-first')
```

### first(arr, listener)

```js
const ee1 = new EventEmitter()
const ee2 = new EventEmitter()
first(
  [[ee1, 'end', 'finish'], [ee1, 'error', 'end']],
  (error, ee, event, args) => {
    // listener invoked
  }
)
```

```js
// 核心代码

function first(stuff, done) {
  // stuff类型校验，略去
  var cleanups = []

  for (var i = 0; i < stuff.length; i++) {
    var arr = stuff[i]

    // arr类型校验，略去
    var ee = arr[0] // EventEmitter实例

    for (var j = 1; j < arr.length; j++) {
      var event = arr[j] // 事件名
      var fn = listener(event, callback)

      // listen to the event
      // 此处只要触发了一个事件，结合下面`listener`的分析得知，
      // 那么最终会执行callback，而该callback就是清除所有的EventEmitter实例上的所有事件
      ee.on(event, fn)
      // push this listener to the list of cleanups
      cleanups.push({
        ee: ee,
        event: event,
        fn: fn
      })
    }
  }

  // 这个callback就是`listener`函数中的done
  // 执行该函数会传递进来`err`, `ee`, `event`, `args`
  function callback() {
    cleanup()

    // 所有此处执行入口函数中的done, 并传入上面的4个参数
    done.apply(null, arguments)
  }

  function cleanup() {
    var x
    for (var i = 0; i < cleanups.length; i++) {
      x = cleanups[i]
      x.ee.removeListener(x.event, x.fn)
    }
  }

  function thunk(fn) {
    done = fn
  }

  thunk.cancel = cleanup

  // 此处返回一个thunk函数，通过该函数上的cancel方法，
  // 可以直接清除所有EventEmitter实例上的所有事件
  return thunk
}

function listener(event, done) {
  // 因为返回的onevent会作为指定事件的监听器
  // 当执行该事件监听器是，`this`指向该EventEmitter实例
  // 如果使用箭头函数，那么`this`就不指向EventEmitter实例了
  return function onevent(arg1) {
    var args = new Array(arguments.length)
    var ee = this
    // 如果监听的是一个error事件，那么第一个参数就是执行该监听器传递进来的参数（一个错误对象）
    // 监听的其他事件，那么该参数设置为null
    var err = event === 'error' ? arg1 : null

    // copy args to prevent arguments escaping scope
    for (var i = 0; i < args.length; i++) {
      args[i] = arguments[i]
    }

    // 最终会执行传递进来的done
    done(err, ee, event, args)
  }
}
```

### .cancel()

> 直接移除所有`EventEmitter`实例上的所有监听器
