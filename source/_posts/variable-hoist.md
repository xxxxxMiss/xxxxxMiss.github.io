---
title: JS中变量提升
date: 2017-04-05 23:05:04
tags: js
categories: js
---

### 变量的生命周期
- 声明阶段：这一阶段在作用域中注册一个变量。
- 初始化阶段：这一阶段分配了内存并在作用域中让内存与变量建立了一个绑定。这一步变量自动被初始化为`undefined`。
- 赋值阶段：这一阶段为初始化的变量分配一个具体的值。

### `var`变量生命周期
{% asset_img var-lifecycle.png var变量生命周期 %}

>当 `JavaScript` 遇到了一个函数作用域，其中包含了 `var variable` 的语句。则在任何语句执行之前，这个变量在作用域的开头就通过了声明阶段并马上来到了初始化阶段（步骤一）。

同时 `var variable` 在函数作用域中的位置并不会影响它的声明和初始化阶段的进行。

在声明和初始化阶段之后，赋值阶段之前，变量的值便是 `undefined` 并已经可以被使用了。

在赋值阶段 `variable = 'value'` 语句使变量接受了它的初始化值（步骤二）。

这里的变量提升严格的说是指变量在函数作用域的开始位置就完成了声明和初始化阶段。在这里这两个阶段之间并没有任何的间隙。

```javascript
(function(){
    // 在这之前，就已经完成了变量的提升（经过了声明和初始化阶段，此时变量已经可以使用了，并且值为undefined）
    console.log(a) // undefined
    var a
    a = 10 // 赋值
    console.log(a) // 10
})()
```


### 函数声明的生命周期
{% asset_img fun-lifecycle.png 函数声明的生命周期 %}

>声明、初始化和赋值阶段在封闭的函数作用域的开头便立刻进行（只有一步）。 `funName()`可以在作用域中的任意位置被调用，这与其声明语句所在的位置无关（它甚至可以被放在程序的最底部）。

```javascript
(function sumArray(array) {
  return array.reduce(sum) //9
  function sum(a, b) {
    return a + b
  }
})([1, 3, 5])
```


### `let`变量的生命周期
> `let` 变量的处理方式不同于 `var`, 它的主要区分点在于***声明***和***初始化***阶段是分开的。
{% asset_img let-lifecycle.png let变量生命周期 %}
>当解释器进入了一个包含 `let variable `语句的块级作用域中。这个变量立即通过了声明阶段，并在作用域内注册了它的名称（步骤一）。

然后解释器继续逐行解析块语句。

在这个阶段尝试访问 `variable`，JavaScript 将会抛出 `ReferenceError: variable is not defined`。因为这个变量的状态依然是未初始化的。

此时 `variable` 处于***临时死区***(从块的开始到声明这段)中。

当解释器到达语句 `let variable `时，此时变量通过了初始化阶段（步骤二）。现在变量状态是初始化的并且访问它的值是 `undefined`。

同时变量在此时也离开了***临时死区***。

之后当到达赋值语句 `variable = 'value'` 时，变量通过了赋值阶段（步骤三）。

如果 JavaScript 遇到这样的语句 `let variable = 'value'` ，那么变量会在这一条语句中同时经过初始化和赋值阶段。
```javascript
let condition = true;
if (condition) {
    // 一但进入if块作用域中，number变量立即通过了声明阶段，此时number变量处于暂存死区中
    // 此时试图访问该变量会抛出 ReferenceError: number is not defined.
  // console.log(number); // => Throws ReferenceError
  let number;
  console.log(number); // => undefined
  number = 5;
  console.log(number); // => 5
}
```

### 例子
```javascript
(function(){
    const a = 5
    console.log(a)
    let a 
    console.log(a)
})()
```
> 上面的例子不会有任何的输出，会抛出`Identifier 'a' has already been declared`。抛出了这个错误是由于已经用`const`定义了一个变量`a`, 再次用`let`声明变量`a`抛出的错误。但是这个错误也说明了使用`let`声明的变量会存在***变量提升***

### `let`,`var`比较
|  | let | var |
| --- | --- | --- |
| 定义变量 | ✅ | ✅ | 
| 可被释放 | ✅ | ✅ |
| 可被提升(hoist) | ✅(注意暂存死区) | ✅ |
| 重复定义检查 | ✅ | ❎ |
| 可被用于块状作用域 | ✅ | ❎ |
```javascript
(function(){
    var i = 1
    console.log(i)
    // 会提升到var语句下面，但是由于已经声明了变量i
    // 所以抛出Identifier 'i' has already been declared
    let i = 1
    console.log(i)
})()
```

### 循环定义中的let作用域
> 循环体中是可以引用在for声明时用let定义的变量，尽管let不是出现在大括号之间.

```javascript
var i = 0;
for (let i = i; i < 10; i++) {
  console.log(i);  // 抛出`ReferenceError: i is not defined`。
}
```

#### 域作用规则
```javascript
for (let expr1; expr2; expr3) statement
```

>在for循环中，`expr1, expr2, expr3, statement`都被包含在一个隐藏的块作用域中。
所以上面的例子推荐写成如下：

```javascript
var i = 0; 
for (let l = i; l < 10; l++) {  
　console.log(l); 
}
```