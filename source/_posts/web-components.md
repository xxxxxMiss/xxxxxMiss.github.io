---
title: web-components
date: 2017-08-13 00:07:36
tags: 
    - js
categories:
    - js
---

## Web Components(web组件)
> web组件是一种可以复用的html单元，他是浏览器的一部分，所以不需要引入额外的库来使用他。
> Web Components技术主要由以下4部分组成，但是每一部分都可以单独使用

- Custom Elments(自定义元素)
- HTML Templates(html模板)
- Shadow DOM
- HTML Imports
```
<link rel="import" href="myfile.html">
```

## Custom Elements
> 自定义元素提供了一种可以让你创建自定义html元素的能力。它也是web componnets技术的组成部分，但是你也可以独立使用它们。
> 自定义元素有着自己的生命周期，这就意味着你可以在不同的生命周期阶段通过脚本绑定不同的行为。
> 例如，当它们被插入到dom中（connected），当它们从dom中移除时（disconnected），又或者它们的特性发生改变的时候（attributeChanged），你都可以在相应的时期做你想做的事情。

### 自定义元素的方法
constructor()
> 当元素被创建或者更新的时候调用

connectedCallback()
> 当元素被插入到文档流中或者被插入到shadow dom中的时候调用

disconnectedCallback()
> 当元素从文档流中移除的时候调用

attributeChangedCallback(attributeName, oldValue, newValue, namespace)
> 当元素**被观察的特性**被改变，被追加，被移除，被取代的时候调用

adoptedCallback(oldDocument, newDocument)
> 当元素被插入到一个新的文档流中的时候调用

自定义元素更多的时候我们采用es6类语法来进行创建：
```html
<template id="custom">
    <div>第一行</div>
    <div>第二行</div>
</template>

<my-element name="test" id="test"></my-element>
```

```js
class MyElement extends HTMLElement{
    constructor(){
        // 一定要记得先调用父类构造器,因为我们在子类的构造器中使用了this
        // 否则就报错
        super()
        
        var tplContent = document.getElementById('custom').content
        var shadowRoot = this.attachShadow({ mode: 'open' })
        shadowRoot.appendChild(tplContent)
    }

    connectedCallback(){
        console.log('自定义元素被插入到shadow dom中')
    }
}

customElements.define('my-element', MyElement)
```

### Observed attributes
> 如果要使用自定义元素的attributeChangedCallback来观察自定义元素特性的变化，那么必须在初始化自定义元素的构造器中列出需要观察的特性--在类中使用静态的get存取器列出需要观察的特性。

改造上面的例子：
```js
class MyElement extends HTMLElement{
    constructor(){
        // 一定要记得先调用父类构造器,因为我们在子类的构造器中使用了this
        // 否则就报错
        super()
        
        var tplContent = document.getElementById('custom').content
        var shadowRoot = this.attachShadow({ mode: 'open' })
        shadowRoot.appendChild(tplContent)
    }

    static get observedAttributes(){ return ['name'] }

    attributeChangedCallback(attr, oldValue, newValue){
        console.log('oldValue: ', oldValue)
        console.log('newValue: ', newValue)

        if('name' === attr){
            this.textContent = `Hello, ${newValue}`
        }
    }

    connectedCallback(){
        console.log('自定义元素被插入到shadow dom中')
    }
}

customElements.define('my-element', MyElement)

setTimeout(function(){
    document.getElementById('test').setAttribute('name', 'ggsmd')
}, 5000)
```

控制台输出如下：
```
// 初始化的时候输出
oldValue: test
newValue: null

// 5s之后输出
oldValue: test
newValue: ggsmd
```

## HTML Templates
> <template>元素中的内容在页面加载的时候并不会渲染，但是你可以通过js来操作其中的内容。
> 你可以认为<template>元素中保存了你接下来要使用的内容片段，在页面加载的时候，解析引擎并不处理<template>中内容，也不做任何渲染，引擎只确保<template>中的内容是否有效。

```html
<table id="producttable">
  <thead>
    <tr>
      <td>UPC_Code</td>
      <td>Product_Name</td>
    </tr>
  </thead>
  <tbody>
    <!-- existing data could optionally be included here -->
  </tbody>
</table>

<template id="productrow">
  <tr>
    <td class="record"></td>
    <td></td>
  </tr>
</template>
```

```js
// 检查浏览器是否支持template元素
if('content' in document.createElement('template')){
    var t = document.querySelector('#productrow')
    , td = t.content.querySelectorAll('td')
    td[0].textContent = 'AAAA'
    td[1].textContent = 'BBBB'

    var tbody = document.querySelector('tbody')
    , clone = document.importNode(t.content, true)
    tbody.appendChild(clone)

    // 复用template元素中的内容
    td[0].textContent = '1111'
    td[1].textContent = '2222'
    var clone2 = document.importNode(t.content, true)
    tbody.appendChild(clone2)
}else{
    // 不支持的浏览器可以引入polyfill
}
```

### HTMLTemplateElement接口
> 通过HTMLTemplateElement接口，我们可以操作<template>元素中的内容

{% asset_img element-template.png HTMLTemplateElement接口 %}

> 上图是HTMLTemplateElement接口的继承图，也就是说HTMLTemplateElement继承了HTMLElement上所有的属性和方法。

#### HTMLTemplateElement特有的一个属性
HTMLTemplateElement.content：只读的属性
返回值：返回<template>元素中的内容，是一个DocumentFragment

```html
<template id="test">
    <div></div>
</template>
```

```js
document.querySelector('#test').content.nodeType === 11
// true
```


## Shadow DOM
> Shadow DOM为Web Components中的DOM, CSS提供了一个包装。
> Shadow DOM将Web Components中的DOM, CSS和文档流中的dom进行了一个隔离。因为一个大型网页，如果前期css组织的不合理，就会导致css各种覆盖，从而使网页样式变得难以把控。通过shadow dom，可以进行一个隔离。
> 它是Web Components技术的一部分，但是你也可以单独使用它们。

### 基本的使用
> shadow dom必须被绑定到某一个存在的元素上，这个元素可以是html文档流中已经存在的元素，也可以是通过js创建的元素(包括自定义元素)。

```html
<body>
    <p id="hostElement"></p>
    <script>
        // 此时shadow dom还是空的，没有内容
        var shadow = document.querySelector('#hostElement')
            .attachShadow({ mode: 'open' })
        // 往shadow dom中添加内容
        shadow.innerHTML = '<span>Here is some new text</span>'
    </script>
</body>
```

### shadow dom的样式
> 继续接着上面的例子，如果我们需要给shadow dom添加样式。就跟我们平时使用内联样式一样，只不过将style标签极其里面的样式全部作为shadow dom的innerHTML。如下： 


```
shadow.innerHTML = '<style>span { color: red; }</style>'
```


### shadow dom相关API
```
var shadowRoot = element.attachShadow(shadowRootInit)
```

> 绑定一个shadow dom树到一个指定的元素上，并且返回ShadowRoot的引用。
> shadowRoot也是一个文档片段。 `shadowRoot.nodeType === 11`

shadowRootInit是一个如下的对象：
```
{
    mode: 'open'
    // mode: 'closed'
}
```

- open: 指定开放的包裹模式，这就意味着在外面可以使用`element.shadowRoot`来访问shadow dom中的内容。

```
element.shadowRoot === shadowRoot(通过attachShadow返回的shadowRoot的引用)
// true
```

- closed: 指定为闭合的包裹模式，这就意味着在外面无法使用任何方法来访问shadow dom中的内容。

```
element.shadowRoot === shadowRoot(通过attachShadow返回的shadowRoot的引用)
// false
element.shadowRoot === null
// true
```

### ShadowRoot接口
ShadowRoot.mode
> 只读，返回值为'open'或者'closed'

ShadowRoot.host
> 只读，返回shadow dom的宿主元素

ShadowRoot.innerHTML
> 返回ShadowRoot内部的dom树

### slot元素
> slot, 翻译为“插槽”。slot元素也是web components技术的一个组成单元：他是web components内的一个占位符，通过这个占位符，你可以在接下来使用的web组件内插入自己想要的标签。
> slot元素一般情况下和template元素组合使用。

### Attributes（特性）
> slot元素和其他的html元素一样，有着一些通用的属性，比如`style`,`class`等，具体有哪些，可以[参看这里](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes)

#### Attributes之name特性
> 给slot元素添加一个名字，因为一个web组件内部可能有多个slot,可以用name特性加以区分。没有添加name特性的slot元素，可以理解为`name=""`。
> 在Vue框架中，也有内置的slot组件，它实现的功能和标准web components中的slot元素是一样的。但在Vue中，没有添加name特性的slot组件，相当于`name="default"`。

```html
<template id="slot-template">
    <div>这是一段文本<slot></slot></div>
    <p><slot name="another"></slot>这是另外一段文本</p>
</template>
```

```js
var slots = document.querySelector('#slot-template')
    .content.querySelectorAll('slot')
Array.from(slots).forEach(s => console.log(s.name))
// ""
// another
```


