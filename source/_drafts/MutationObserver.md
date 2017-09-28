---
title: MutationObserver
tags:
---
3396689840----qwey998---
## MDN描述
> MutationObserver给开发者们提供了一种能在某个范围内的DOM树发生变化时作出适当反应的能力.

## 使用
```
new MutationObserver(callback: Function)
```
> callback: 每当dom节点发生变化时，就会触发callback回调。

## 实例方法
### observe(target: Node, options: MutationObserverInit): void
> 给一个元素添加observe方法，跟使用`addEventListener`相似。
> 就是说对同一个元素多次添加相同的`observe`, 并不会触发多次回调。
> 可以对一个元素添加多个不同的`observe`。

- target: 要检测的dom节点
- options: 一个对象，指出了需要记录dom节点哪些东西的改变

 MutationObserverInit 介绍

 |  属性 | 描述 | 
 | -------- | ----- |
 | childList | 如果需要监测目标节点的子节点(新增或者删除某个子节点)，那么就可以设置为true |
 | attributes | 如果需要监测目标节点的属性节点(新增或者删除某个属性以及某个属性的值发生改变)，那么就可以设置为true | 
 | characterData | 如果目标节点为characterData节点(一种抽象接口，具体可以为文本节点，注释节点，以及处理指令节点)时，也要监测其变化，那么就设置该属性为true |
 | subtree | 除了目标节点,如果还需要观察目标节点的所有后代节点(观察目标节点所包含的整棵DOM树上的上述三种节点变化),则设置为true |
 | attributeOldValue | 在attributes属性已经设为true的前提下,如果需要将发生变化的属性节点之前的属性值记录下来(记录到下面MutationRecord对象的oldValue属性中),则设置为true |
 | characterDataOldValue | 在characterData属性已经设为true的前提下,如果需要将发生变化的characterData节点之前的文本内容记录下来(记录到下面MutationRecord对象的oldValue属性中),则设置为true |
 | attributeFilter | 一个属性名数组(不需要指定命名空间),只有该数组中包含的属性名发生变化时才会被观察到,其他名称的属性发生变化后会被忽略 |

下面就来看看`MutationObserver`在Vue中`nextTick`方法中使用
```
/**
 * Defer a task to execute it asynchronously.
 */
export const nextTick = (function () {
  const callbacks = []
  let pending = false
  let timerFunc

  function nextTickHandler () {
    pending = false
    const copies = callbacks.slice(0)
    callbacks.length = 0
    for (let i = 0; i < copies.length; i++) {
      copies[i]()
    }
  }

  if (typeof Promise !== 'undefined' && isNative(Promise)) {
    var p = Promise.resolve()
    var logError = err => { console.error(err) }
    timerFunc = () => {
      p.then(nextTickHandler).catch(logError)
     
      if (isIOS) setTimeout(noop)
    }
  } else if (typeof MutationObserver !== 'undefined' && (
    isNative(MutationObserver) ||
    // PhantomJS and iOS 7.x
    MutationObserver.toString() === '[object MutationObserverConstructor]'
  )) {
    // use MutationObserver where native Promise is not available,
    // e.g. PhantomJS IE11, iOS7, Android 4.4
    var counter = 1
    var observer = new MutationObserver(nextTickHandler)
    var textNode = document.createTextNode(String(counter))
    observer.observe(textNode, {
      characterData: true
    })
    timerFunc = () => {
      counter = (counter + 1) % 2
      textNode.data = String(counter)
    }
  } else {
    // fallback to setTimeout
    /* istanbul ignore next */
    timerFunc = () => {
      setTimeout(nextTickHandler, 0)
    }
  }

  return function queueNextTick (cb?: Function, ctx?: Object) {
    let _resolve
    callbacks.push(() => {
      if (cb) cb.call(ctx)
      if (_resolve) _resolve(ctx)
    })
    if (!pending) {
      pending = true
      timerFunc()
    }
    if (!cb && typeof Promise !== 'undefined') {
      return new Promise(resolve => {
        _resolve = resolve
      })
    }
  }
})()
```


### disconnect()
> 不再监听dom元素的改变。如果需要再次观察该元素的改变，必须再次调用`observe`方法

### takeRecords(): Array
> 清空`MutationObserver`实例的消息队列，并返回这个这个消息队列的数组

