---
title: Object类方法之keys()
date: 2017-05-20 19:55:45
tags: js
categories: js
---

## Object.keys()
> 返回一个由给定对象的自身可枚举属性组成的数组，数组中属性名的排列顺序和使用 for...in 循环遍历该对象时返回的顺序一致 （两者的主要区别是 一个 for-in 循环还会枚举其原型链上的属性）。

通过例子来看下什么叫“和for...in”顺序一致：
```javascript
// 注意，这并不是类数组
var obj = {
    100: 'a',
    2: 'b',
    7: 'c'
}
for(var key in obj) console.log(key) // '2' '7' '100'

Object.keys(obj) // ['2', '7', '100']
```

在通过例子看看什么叫Object.keys()不会列出原型上的属性:
```javascript
var target = {
  name: 'js',
  price: 100
}

target.__proto__ = {
  ISBN: 2017,
  publish: 'construction house'
}

for(var key in target){
  console.log(key) // 会输出'name', 'price', 'ISBN', 'publish'
}

console.log(Object.keys(target)) // 会输出 ['name', 'price']
```

在通过例子看看什么叫Object.keys()只会列出对象**自身可枚举**的属性：
```javascript
var target = {
  name: 'js',
  price: 100
}
Object.defineProperty(target, 'ISBN', {
  value: 2017
})

console.log(target.propertyIsEnumerable('ISBN')) // false

// for...in循环也只会列出自身和原型上的可枚举属性
for(var key in target){
  console.log(key) // 'name', 'price'
}

// 因为'ISBN'通过Object.defineProperty()添加的，默认是不可枚举的
console.log(Object.keys(target)) // ['name', 'price']
```

关于Object.defineProperty()和obj.propertyIsEnumerable()的详细说明可要参看这里。
[Object.defineProperty()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
[obj.propertyIsEnumerable()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/propertyIsEnumerable)

### 类数组
> 通过上面的例子，我们看出`for...in`迭代这个对象的属性和我们平常迭代一个通过对象的属性不一样，造成这个原因就是因为这个对象的属性是数字。
> 我们知道，js迭代一个对象的顺序是无法保证按我们书写先后顺序一样，如果要保证顺序我们可以使用类数组。
> 类数组的定义：就是一个普通的对象，但是该对象必须保证2点：
> ①每个属性的值必须是一个数字
> ②必须有lenth属性。

NOTE: 将一个类数组转化为正真的数组，如果类数组的`length`属性的值和数字属性的个数不一致，那么会出现以下几种情况:
- length的值和数字属性的个数一致：

```javascript
var arrlike = {
    0: 'a',
    1: 'b',
    2: 'c',
    length: 3
}
console.log([].slice.call(arrlike)) // [ 'a', 'b', 'c' ]
```

- length的值大于数字属性的个数，会出现稀疏数组

```javascript
var arrlike = {
    0: 'a',
    1: 'b',
    2: 'c',
    length: 5
}
console.log([].slice.call(arrlike)) // [ 'a', 'b', 'c', ,  ]
```

- length的值小于数字属性的个数，会截断数组

```javascript
var arrlike = {
    0: 'a',
    1: 'b',
    2: 'c',
    length: 2
}
console.log([].slice.call(arrlike)) // [ 'a', 'b' ]
```

## 兼容性
> 在es5中，如果该方法的参数不是一个对象，那么会造成`TypeError`。
> 在es2015中，非对象的参数将会被强制转换为一个对象。如果转化失败，则会抛出转化类型错误。

```javascript
// ES5
Object.keys('foo')
// TypeError: 'foo' is not an object

// ES2015
Object.keys('foo')
// ['0', '1', '2']

Object.keys(null)
Object.keys(undefined)
// Uncaught TypeError: Cannot convert undefined or null to object

Object.keys(3) // []
Object.keys(new Date()) // []
Object.keys(function(){}) // []
```
所以可以简单做如下总结(在es2015中)
- 参数为null,undefined，抛出转换失败错误
- 原始类型返回空数组
- 引用类型返回空的数组
- symbol类型返回空数组
- 数组，类数组, 非空的字符串，都返回他们的索引组成的数组
- 只有纯对象才返回属性名组成的字符串数组

### 什么叫纯对象
```javascript
Object.prototype.toString.call(obj) === '[object Object]'
```
满足这个条件的对象就叫纯对象。

## Object.keys简单的polyfill

```javascript
if(!Object.keys) Object.keys = function(o){
    if(o !== Object(o)) 
        throw new TypeError('Object.keys called on a non-object')
    var k = [], p
    for(p in o) if(Object.prototype.hasOwnProperty.call(o, p)) k.push(p)
    return k
}
```

## Object的使用之一
> 在上面的polyfill中，判断类型时，使用了`o !== Object(o)`, 直接调用`Object`构造函数，可以将一个原始类型转化为引用类型。还有其他的类似的构造函数`Number`, `String`, `Boolean`等也是将对应的原始类型转化为引用类型。
> 也就是说可以利用Object构造函数来判断一个变量引用类型还是原始类型

通过例子看下是不是这么回事：
```javascript
var n = 1
console.log(typeof n) // 'number'
console.log(typeof Object(n)) // 'object'
```
需要注意的是：使用`Object`构造函数来判断是原始类型还是引用类型的时候，一定要使用`===`全等判断符号

再来看例子
```javascript
var str = 'hello'
console.log(Object(str)) // {0: "h", 1: "e", 2: "l", 3: "l", 4: "o", length: 5, [[PrimitiveValue]]: "hello"}
```
- 通过`Object(str)`将一个字符串转化为类数组对象了，其实这也就是为什么平时我们可以对一个原始类型的字符串使用`length`属性，其实真正的是将该字符串转化为对应的引用类型，再去使用该引用类型上的`length`属性。
- 一般情况下，我们取字符串某个位置上的字符，可能会这样`str.charAt(index)`。通过上面的例子可以看出还可以按照数组取值的方式来。比如`hello[0]`。

## symbol作为对象的属性
> js中对象的定义就是：一些属性的集合。这个属性，包括2种，一种是普通的字符串（包括空字符串），另一种就是symbol。这里需要注意的就是：当使用symbol作为对象的属性时，那么`for in`循环和`Object.keys`是不会列出这些symbol属性的。如果要获取symbol属性的值，那么可以通过以下2种方法：

- Object.getOwnPropertySymbols()
- Reflect.ownKeys()

### Object.getOwnPropertySymbols
> 返回一个对象自有的symbol属性组成的数组。因为所有的对象都没有初始化的symbol属性，所以默认情况下它会返回一个空数组。

```javascript
var obj = {}
console.log(Object.getOwnPropertySymbols(obj)) // []

var symbol = Symbol('s')
obj[symbol] = 'ss'
console.log(Object.getOwnPropertySymbols(obj)) // [Symbol(s)]
```

### Reflect.ownKeys
> 返回一个对象所有的自有属性组成的数组。
> 其实就相当于Object.getOwnPropertyNames(target).cancat(Object.getOwnPropertySymbols())

```javascript
Reflect.ownKeys({z: 3, y: 2, x: 1}); // [ "z", "y", "x" ]
Reflect.ownKeys([]); // ["length"]

var sym = Symbol.for('comet');
var sym2 = Symbol.for('meteor');
var obj = {[sym]: 0, 'str': 0, '773': 0, '0': 0,
           [sym2]: 0, '-1': 0, '8': 0, 'second str': 0};
Reflect.ownKeys(obj);
// [ "0", "8", "773", "str", "-1", "second str", Symbol(comet), Symbol(meteor) ]
// Indexes in numeric order, 
// strings in insertion order, 
// symbols in insertion order
```
> 观察上面的例子，需要注意的是：当一个对象的属性由各种类型的字符串和symbol组成时，返回的数组元素按照这样的顺序来排列：索引字符串（从0开始，-1被列入字符串属性）属性按照从小到大，其次是字符串属性按照最初插入的顺序，最后才是symbol属性按照最初插入的顺序。

## Object.getOwnPropertyNames(obj)
> 该方法会返回obj自身（不包括原型链上的属性）所有的属性（包括不可枚举的属性）组成的字符串数组。
> 返回的数组的元素的顺序和for...in遍历时的顺序一致。

包括不可枚举的属性
```js
var obj = Object.create(null, {
  getFoo: {
    value: function(){
      return this.foo
    },
    enumerable: false
  }
})
obj.foo = 1
console.log(Object.getOwnPropertyNames(obj))
// prints: ["getFoo", "foo"]
```

不包括原型链上的属性
```javascript
function Foo(){
  this.foo = 'foo'
}
Foo.prototype.getFoo = function(){
  return this.foo
}
console.log(Object.getOwnPropertyNames(new Foo()))
// prints: ['foo']
```
