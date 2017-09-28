---
title: nodejs学习之module模块
date: 2017-03-22 10:55:52
tags: nodejs
categories: nodejs
---

> nodejs有一个简单的模块加载系统。在nodejs中，文件和模块是一对一的关系（每个文件都被视为一个模块）

[TOC]

先看一个例子
foo.js
```
const circle = require('./circle.js')
console.log(`The area of a circle of radius 4 is ${circle.area(4)`}
```

circle.js
```
const PI = Math.PI

exports.area = (r) => PI * r * r

exports.circumference = (r) => 2 * PI * r
```

说明：

- circle.js导出了2个方法`area()`, `circumference()`, 导出一个模块中的方法或者对象，你可以将他们挂载到`exports`对象上
- 如果没有导出一个模块中的方法或则对象，那么他么都是私有的，因为在解析的时候，这些模块都会被一个函数包裹起来。在上面的例子中，`PI`变量就是私有的，因为他没有挂载到`exports`对象上。
- 如果你想导出的就是一个函数，那么重写`module.exports`即可。因为默认导出的是`module.exports`, `module.exports`是一个对象。

看下面的例子
bar.js
```
const square = require('./square.js');
// 因为square.js导出的就是一个函数，所以直接调用。
var mySquare = square(2);  // 如果导出的是一个对象，那么此处应该这样调用square.square(2)
console.log(`The area of my square is ${mySquare.area()}`);
```

square.js
```
// assigning to exports will not modify module, must use module.exports
module.exports = (width) => {
  return {
    area: () => width * width
  };
}
```

## 核心模块
> 如果一个模块中引入了核心模块，那么核心模块总是被优先加载。
> 例如，`require(http)`, 总是会加载nodejs的`http`模块，即使你有一个模块也叫`http`

// 始终返回核心模块的实现
```
exports.builtinLibs = [
  'assert', 'buffer', 'child_process', 'cluster', 'crypto', 'dgram', 'dns',
  'domain', 'events', 'fs', 'http', 'https', 'net', 'os', 'path', 'punycode',
  'querystring', 'readline', 'repl', 'stream', 'string_decoder', 'tls', 'tty',
  'url', 'util', 'v8', 'vm', 'zlib'
];

function addBuiltinLibsToObject(object) {
  // Make built-in modules available directly (loaded lazily).
  exports.builtinLibs.forEach((name) => {
    // Goals of this mechanism are:
    // - Lazy loading of built-in modules
    // - Having all built-in modules available as non-enumerable properties
    // - Allowing the user to re-assign these variables as if there were no
    //   pre-existing globals with the same name.

    const setReal = (val) => {
      // Deleting the property before re-assigning it disables the
      // getter/setter mechanism.
      delete object[name];
      object[name] = val;
    };

    Object.defineProperty(object, name, {
      get: () => {
        const lib = require(name);

        // Disable the current getter/setter and set up a new
        // non-enumerable property.
        delete object[name];
        Object.defineProperty(object, name, {
          get: () => lib,
          set: setReal,
          configurable: true,
          enumerable: false
        });

        return lib;
      },
      set: setReal,
      configurable: true,
      enumerable: false
    });
  });
}
```

## 循环加载
> 指的是一个模块a依赖模块b,而模块b又依赖模块a。

下面通过nodejs官方文档的例子来说明nodejs是如何处理模块的循环加载

a.js
```
console.log('a starting');
exports.done = false;
const b = require('./b.js');  // ①
console.log('in a, b.done = %j', b.done);
exports.done = true;
console.log('a done');
```

b.js
```
console.log('b starting');
exports.done = false;
const a = require('./a.js');  // ②
console.log('in b, a.done = %j', a.done);
exports.done = true;
console.log('b done');
```

main.js
```
console.log('main starting');
const a = require('./a.js');
const b = require('./b.js');
console.log('in main, a.done=%j, b.done=%j', a.done, b.done);
```

说明：

- main.js加载a.js, 进入a.js, 执行到`require('./b.js')`，进入b.js, 执行到`require('./a.js')`
- 此时发生了循环加载，为了阻止这种无限的循环，nodejs会将a.js中执行过的部分生成一个副本模块返回给b.js
- 相当于执行a.js执行到①这个地方暂停了，此时a.js中导出的`exports.done = false`
- 等到b.js全部执行完毕，在从①暂停的地方继续执行a.js, 此时b.js中`exports.done = true`
- 最后执行main.js中为执行的部分

所以最终输出的结果如下
```
index starting
a starting
b starting
in b, a.done = false
b done
in a, b.done = true
a done
in main, a.done = true, b.done = true
```

## nodejs(CommonJS)模块循环加载  VS  ES2015模块循环加载

