---
title: 词法作用域VS动态作用
date: 2017-05-28 23:54:27
tags: 
    - js
categories: js
---

## 词法作用域(lexical scoping)
> js中有2种作用域，词法作用域和动态作用域。下面用例子来解释这2种作用域的概念。

```javascript
var outerFunction  = function(){

   if(true){
      var x = 5;
      //console.log(y); //line 1, ReferenceError: y not defined
   }

   var nestedFunction = function() {

      if(true){
         var y = 7;
         console.log(x); //line 2, x will still be known prints 5
      }

      if(true){
         console.log(y); //line 3, prints 7
       }
   }
   return nestedFunction;
}

var myFunction = outerFunction();
myFunction();
```

在上面的例子中，变量`x`可以在`outerFunction`中各个地方访问，变量`y`可以在`nestedFunction`中各个地方访问，但是变量`x`,`y`不能在他们所在的函数的外部访问。这种行为可以通过**词法作用域**来解释：
> 词法作用域：变量的作用域是由他们被定义时处在源代码中的位置决定。为了去解析这些变量，js从最内层作用域向外层作用域查找，直到查找到该变量为止。

再来看一个典型的例子：
```javascript
function foo(){
  console.log(a) // 2
}

function bar(){
  var a = 3
  foo()
}
var a = 2
bar()
```
> 这个例子中，会输出2。我们按照词法作用来分析下：首先foo在自己的作用域中寻找变量a, 没有找到，那么到父级作用域中查找，本例子中foo的父级作用域就是全局作用域。因为foo函数定义时处在全局环境中有个变量a，所以在bar函数中调用foo时，会输出2。如果寻找到顶级作用域都没有找到变量a, 那么就抛出一个`Uncaught ReferenceError: a is not defined`
> 如果按照动态作用域来分析：foo执行时所在的作用域是bar函数的作用域，那么此时输出的就是3了。

词法作用域很清晰明了，但是动态作用域就不是这么清晰明了了，动态作用域是由运行时的环境决定的。为了说明说明什么叫动态作用域，先来看什么叫闭包。

## 闭包(closures)
我们看上面的例子，事实上对于为什么在`nestedFunction`中可以访问变量`x`依然是模糊的。因为我们知道：通常一个函数中的本地变量，会随着函数的执行完毕而销毁。那么我们调用函数`outerFunction`并将它的返回值赋值给`myFunction`, 为什么`outerFunction`函数已经执行完毕而变量`x`依然存在？

MDN上对闭包的定义如下:
> A closure is a special kind of object that combines two things: a function, and the environment in which that function was created. The environment consists of any local variables that were in-scope at the time that the closure was created.
意思就是：
> 闭包是一种特殊的函数，该函数可以记住当时创建时的环境。

那上面的例子来解释就是：`nestedFunction`被创建时，是在`outerFunction`作用域中，该作用域中有变量`x`, 那么当`outerFunction`函数执行完毕时，返回的`nestedFunction`是可以记住变量`x`的。换句话说，就是原本随函数执行完毕而销毁的变量，因为有别人对他的引用，因此当函数执行完毕时该变量并不会被销毁。

## 函数的执行上下文(this，动态作用域)
> 上面对于闭包的解释，一种可以记住当时被创建时的环境，这个环境主要是指各种本地变量。但是一种特殊的变量`this`，他的行为和普通变量完全不同，看下面的例子：

```javascript
var cat = {
 
   name: "Gus",
   color: "gray",
   age: 15,
 
   printInfo: function() {
      console.log("Name:", this.name, "Color:", this.color, "Age:", this.age); //line 1, prints correctly
 
      nestedFunction = function() {
          console.log("Name:", this.name, "Color:", this.color, "Age:", this.age); //line 2, loses cat scope
      }
 
      nestedFunction();
   }
}
cat.printInfo(); //prints Name: '' Color: undefined Age: undefined
```

> 上面的例子，第一处的`console`语句能正常的输出,但是对于`nestedFunction`中的输出语句，却未能按照预期输出。

对于第二个`console`输出，当一个函数处在另一个函数的内部时，js会丢失`this`作用域，一旦丢失，默认情况下`this`会指向全局的`window`对象。所以上面的例子，`nestedFunction`中的`this.color`和`this.age`输出`undefined`, 而`this.name`会输出空字符串, 是因为`window`对象默认有个`name`属性，默认值就是空。

关于window对象的`name`属性，可以参看[这里](https://developer.mozilla.org/en-US/docs/Web/API/Window/name)

## 控制上下文(context)
> 我们无法改变词法作用域在js中的工作机制，但是我们可以改变一个函数的执行问下文。
> **js中的上下文是由函数运行时决定的，并且他总是被绑定到调用该函数的对象上**,但是唯一不适用这条规则的就是上面出现的函数嵌套的情况。

换句话说，改变上下文就是改变`this`的指向。看个简单的例子：
```javascript
var obj1 = {
   printThis: function() {
      console.log(this);
   }
};
 
var func1 = obj1.printThis;
obj1.printThis(); //line 1
func1(); //line 2
```

line1会输出`ojb1`, line2会输出`window`。

## Call, Bind, Apply
> 我们可以有多种方式来控制`this`的指向，常见的有以下几种：

- 存储`this`的引用到另外一个变量
- call()
- apply()
- bind()

存储`this`的引用到另外一个变量:
```javascript
var cat = {
   name: "Gus",
   color: "gray",
   age: 15,
 
   printInfo: function() {
      var that = this;
      console.log("Name:", this.name, "Color:", this.color, "Age:", this.age); //prints correctly
 
      nestedFunction = function() {
         console.log("Name:", that.name, "Color:", that.color, "Age:", that.age); //prints correctly
      }
   nestedFunction();
   }
}
cat.printInfo();
```


```javascript
var cat = {
   name: "Gus",
   color: "gray",
   age: 15,

   printInfo: function() {
      console.log("Name:", this.name, "Color:", this.color, "Age:", this.age);
      nestedFunction = function() {
         console.log("Name:", this.name, "Color:", this.color, "Age:", this.age);
      }
      nestedFunction.call(this);
      nestedFunction.apply(this);

      var storeFunction = nestedFunction.bind(this);
      storeFunction();
    }
}
cat.printInfo();
```

关于`call`, `apply`, `bind`详细使用方法，这里不讲解了。
这里说下他们三者的区别：
- call, apply, 主要的不同就是传递额外参数的方式不同。call传递一个以逗号分割的列表，bind也是用这样的方式传递额外参数。apply需要传递的是一个数组。
- 相对于call, apply，bind的使用要更加的灵巧一些：因为bind不但可以改变`this`的指向，而且他会返回一个新的函数，那么我们可以将这个新函数保存到另外一个变量中，在需要使用的地方再调用。
但是call和apply会立即调用函数，返回函数的结果。

## 关于setTimeout中的this
> 我们知道，可以使用call, apply, 来改变函数的执行上下文，那么他们是否也适用于setTimeout呢？

看例子：
```javascript
myArray = ["zero", "one", "two"];
myArray.myMethod = function (sProperty) {
    alert(arguments.length > 0 ? this[sProperty] : this);
};

myArray.myMethod(); // prints "zero,one,two"
myArray.myMethod(1); // prints "one"
setTimeout(myArray.myMethod, 1000); // prints "[object Window]" after 1 second
setTimeout(myArray.myMethod, 1500, "1"); // prints "undefined" after 1,5 seconds

// let's try to pass the 'this' object
setTimeout.call(myArray, myArray.myMethod, 2000); // Uncaught TypeError: Illegal invocation
setTimeout.call(myArray, myArray.myMethod, 2500, 2); // same error
```

我们知道，正常情况下setTimeout/setInterval中的`this`是指向`window`对象的，我们还知道`call`方法可以改变`this`的指向，但是上面的例子中，使用setTimeout.call抛出错误。至于为什么这样，目前还不知道。。。？

一种解决setTimeout中`this`指向不正确的方案就是重写原生的setTimeout,如下
```javascript
var __nativeST__ = window.setTimeout
window.setTimeout = function(callback, delay){
    var self = this, args = [].slice.call(arguments, 2)
    return __nativeST__(callback instanceof Function ? function(){
            callback.apply(self, args)
        } : callback, delay)
}
```

经过上面的处理之后，此时再来调用发现就正确了：
```javascript
myArray = ["zero", "one", "two"];
myArray.myMethod = function (sProperty) {
    alert(arguments.length > 0 ? this[sProperty] : this);
};

setTimeout(alert, 1500, "Hello world!"); // the standard use of setTimeout and setInterval is preserved, but...
setTimeout.call(myArray, myArray.myMethod, 2000); // prints "zero,one,two" after 2 seconds
setTimeout.call(myArray, myArray.myMethod, 2500, 2); // prints "two" after 2,5 seconds
```

[参考文章链接](https://spin.atomicobject.com/2014/10/20/javascript-scope-closures/)
[参考文章链接](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/setTimeout)