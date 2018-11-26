---
title: event-loop(事件循环)
date: 2017-07-14 10:58:29
tags:
  - js
  - nodejs
categories:
  - js
---

<style type="text/css" media="screen">
  .list li{
    list-style-type: decimal;
  }
</style>

## 2 个名词

- microtask: 称之为小型任务
- macrotask（task queue）: 称之为大型任务

## 事件循环模型

> 当执行栈（call stack）为空时，一个事件循环会按照下面的步骤进行：

<ol class="list">
  <li>从macrotask队列中选择最老一个任务taskA</li>
  <li>如果taskA不存在，即macrotask队列是空的，那么进行步骤6</li>
  <li>设置当前运行的任务为taskA</li>
  <li>运行taskA(即执行taskA它的回调函数)</li>
  <li>设置当前运行的任务为空，并从macrotask中移除taskA</li>
  <li>开始处理microtask
    <ul>
      <li>(a)从microtask中选择最老的任务taskX</li>
      <li>(b)如果taskX不存在，即microtask是空的，那么跳到步骤(g)</li>
      <li>(c)设置当前运行的任务为taskX</li>
      <li>(d)运行taskX(即执行taskX的回调函数)</li>
      <li>(e)设置当前运行的任务为空，并从microtask中移除taskX</li>
      <li>(f)从microtask选择下一个最老的任务，步骤(b)</li>
      <li>(g)重复以上步骤，直到microtask中的任务全部执行完毕</li>
    </ul>
  </li>
  <li>继续回到步骤1</li>
</ol>

精简的概括就是：

- 先从 macrotask 队列中选择最老的一个任务开始执行，然后移除这个最老的任务
- 再执行 microtask 队列中所有的任务，然后移除他们
- 继续下一轮，重复以上 2 步

## 需要知道的一些事情：

<ol class="list">
  <li>当一个macrotask任务正在运行的时候，新的事件可以被注册，也即创建新的任务。例如：
    <ul>
      <li>promiseA.then()的回调是一个任务
        <ul>
          <li>promiseA如果处于resolve/reject状态时，那么该任务被推到事件循环的当前轮次的microtask中</li>
          <li>promiseA处于pending状态时，那么该任务将会被推到事件循环的下一个轮次的microtask中。</li>
        </ul>
      </li>
      <li>setTimeout(callback, n)的回调是一个任务，将会被推到macrotask中，及时n=0。</li>
    </ul>
  </li>
  <li>如果事件循环正在执行microtask中的任务，那么你可以继续往microtask中添加任务，这些任务都会在本轮次的循环中执行。</li>
  <li>只有等到本轮次的microtask中的所有任务执行完毕，才会执行下一轮的macrotask任务。</li>
  <li>常见的microtask任务：`process.nextTick`,`Promise`, `Object.observe`, `MutationObserver`</li>
  <li>常见的macrotask任务：`setTimeout`,`setInterval`, `setImmediate`,Dom事件（click, scroll, mouseup等）， `ajax`，I/O, UI rendering等。还需要注意的是，整个的脚本也是一个macrotask任务。</li>
</ol>

经过上面的分析，可以看如下例子输出：

```js
console.log('script start')

const interval = setInterval(() => {
  console.log('setInterval')
}, 0)

setTimeout(() => {
  console.log('setTimeout1')

  Promise.resolve()
    .then(() => {
      console.log('promise3')
    })
    .then(() => {
      console.log('promise4')
    })
    .then(() => {
      setTimeout(() => {
        console.log('setTimeout2')

        Promise.resolve()
          .then(() => {
            console.log('promise5')
          })
          .then(() => {
            console.log('promise6')
          })
          .then(() => {
            clearInterval(interval)
          })
      })
    })
})

Promise.resolve()
  .then(() => {
    console.log('promise1')
  })
  .then(() => {
    console.log('promise2')
  })

// script start
// promise1
// promise2
// setInterval
// setTimeout1
// promise3
// promise4
// interval
// setTimout2
// promise5
// pormise6
```

## call stack(执行栈)与 event loop(事件循环)之间的关系

> 为了形象的表示，可以参看下图：

{% asset_img event-loop.png 事件循环与函数调用栈的关系 %}

关于他们之间的关系的说明，此处就不在叙述了，具体可以[参看这里](http://www.ruanyifeng.com/blog/2014/10/event-loop.html)

参考文章如下：
[microtask and macrotask](https://stackoverflow.com/questions/25915634/difference-between-microtask-and-macrotask-within-an-event-loop-context)
[event loop](https://blog.risingstack.com/node-js-at-scale-understanding-node-js-event-loop/)
[task-queue spec](https://html.spec.whatwg.org/multipage/webappapis.html#task-queue)
[call stack](https://vimeo.com/96425312)
