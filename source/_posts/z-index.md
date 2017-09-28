---
title: 深入理解z-index
date: 2017-04-05 14:25:57
tags: css
toc: true
categories: css
---

### z-index基本规则
1. 如果定位元素`z-index`没有发生嵌套（就是说一个定位元素的子元素的`position`都是`static`）,那么此时遵守的规则为：
- 后来居上的准则
- 哪个大，哪个上
2. 如果定位元素发生了嵌套
    - 祖先优先原则（z-index的值非`auto`）
    - 如果`z-index: auto`,那么就不遵守祖先优先的原则了   


```
// z-index的值非auto
<div style="position: relative; z-index: 1">
    <img src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" style="position: absolute; z-index: 2"> // z-index: 2
</div>

<div style="position: relative; z-index: 1">
    <img src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" style="position: absolute; left: 100px; z-index: 1"> // z-index: 1
</div>
```

> 上面的例子，虽然第一个图片的`z-index:2`，第二个图片的`z-index: 1`，但是由于发生了嵌套，祖先元素都是`z-index: 1`，所以第二个图片覆盖在第一个图片上面。



```
// z-index的值为auto
<div style="position: relative; z-index: auto">
    <img src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" style="position: absolute; z-index: 2"> // z-index: 2
</div>

<div style="position: relative; z-index: 1">
    <img src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" style="position: absolute; left: 100px; z-index: 1"> // z-index: 1
</div>
```

> 上面的例子，同第一个例子一样，唯一不同的地方就是第一个图片祖先元素的`z-index:auto`, 那么此时第一个图片在覆盖第二个图片。
> 解释：`z-index: auto`当前层叠上下文生成的盒子层叠水平是***0***。盒子（除非是根元素）不会创建一个新的层叠上下文。

### z-index中涉及到的重要概念
- 层叠上下文（stacking context）：html中元素在z轴上的堆叠顺序。
    - 页面根元素（可以理解为html或者为body）天生具有层叠上下文，称之为”根层叠上下文“。
    - z-index为数值的定位元素具有层叠上下文。
    - 一些其他属性的元素
{% asset_img stacking-props.png 其他属性的元素 %}

- 层叠水平（stacking level）：层叠上下文中的每个元素都有一个层叠水平，层叠水平决定了***同一个层叠上下文***中的元素在z轴上的堆叠顺序。
- 层叠顺序（stacking order）：元素发生层叠时有着特定的垂直显示顺序。

### 层叠上下文的几个特性
- 层叠上下文可以嵌套，组合成一个分层次的层叠上下文。
- 每个层叠上下文和兄弟元素独立：当进行层叠变化或者渲染的时候，只需要考虑后代元素。
- 每个层叠上下文是自成体系的：当元素的内容被层叠后，整个元素被认为是在父层的层叠顺序中。

### 7阶层叠水平(stacking level)
{% asset_img stacking-level.png 7阶层叠水平图 %}
为什么层叠顺序是这样的？
>可以这样理解：`background,border`等主要用来装饰元素，`block`盒子`float`元素主要用来布局，而`inline, inline-block`主要用来展示内容，而内容是页面中最重要的实体，所以应该让其层叠水平更高。

```
.block, .inline-block{
    height: 200px;
}
.block{
    width: 300px;
    background-color: rgba(37,148,233, .4);
    margin-top: -13px;
}

.inline-block{
    display: inline-block;
    width: 200px;
    background-color: #ff8200;
}

<div class="inline-block">
    display: inline-block
</div>
<div class="block">
    display: block
</div>
```
>上面的例子: `inline-block`的元素会覆盖在`block`元素的上面，但是`block`元素中的文字并没有被覆盖。因为文字是属于`inline`元素，对照7阶层叠上下文可以知道`inline`的堆叠顺序和`inline-block`是一个等级的，并且`block`元素出现在`inline-block`元素的后面，按照***后来居上***的规则，`inline-block`元素并不会覆盖`block`元素中的文字。


### z-index元层叠上下文的关系
- 定位元素默认`z-index:auto`可以看成是`z-index: 0`。
- `z-index`不为`auto`的定位元素创建层叠上下文。
- `z-index`层叠顺序的比较止步于父级层叠上下文。

```
.box{
    position: absolute;
    background-color: blue;
    /*z-index: 0;*/
    width: 200px;
    height: 100px;
    display: inline-block;
}
.img{
    position: relative;
    margin-left: -100px;
    z-index: -1;
    width: 200px;
}

<div class="box">
    <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">    
</div>
```
> 上面的例子，如果`box`不加上`z-index:0`,那么此时的层叠上下文就是`body`元素，那么`z-index:-1`的元素会处于`body`元素的下面，所以`box`元素覆盖图片。
> 但是如果`box`元素加上`z-index:0`, 那么此次层叠上下文就变成了`box`元素，那么按照***7阶层叠水平***, `background`是处于最底层的，所以`z-index:-1`的图片会覆盖背景。


```
.box1{
    position: relative;
    z-index: 0;
}
.box1 img{
    position: absolute;
    z-index: 99999;
}

.box2{
    position: relative;
    z-index: 1;
}
.box2 img{
    position: absolute;
    left: 250px;
    z-index: -1;
}

<div class="box1">
    <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
</div>
<div class="box2">
    <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
</div>
```
>上面的例子，虽然`box1`中的`img`图片的`z-index:99999`很大，但是其父元素的`z-index: 0`没有第二个图片的父元素`box2`的`z-index:1`大，所以依然是第二个图片覆盖第一个图片。

### 其他参与层叠上下文的属性
- `z-index`值不为`auto`的flex项（父元素display:flex|inline-flex）
```
// 设置为flex的父元素，可以改变子元素z-index不为auto的元素参数参与堆叠上下文
.box{
    /*display: flex;*/
    background-color: blue;
}
.box > div {
    z-index: 1;
}
.box > div > img{
    position: relative;
    z-index: -1;
}

<div class="box">
    <div>
        <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
    </div>
</div>
```
>当没有为`box`设置`display: flex`时，此时层叠上下文为根元素（html或者body），所以`img`设置为`z-index:-1`会堆叠在根元素下面，也就是背景会覆盖图片。但如果设置`box`为`display: flex`,那么此时`display:flex`的***子元素***`z-index`不为`auto`的元素参与堆叠顺序，那么按照***7阶堆叠顺序***，`z-index`为负值的会堆叠在`background`上面。

- `opacity != 1`
```
.box{
    background-color: blue;
    /*opacity: .9;*/
}
.box > img{
    position: relative;
    z-index: -1;
}

<div class="box">
    <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
</div>
```

>当没有给`box`元素设置`opacity:.9`时，那么此时`box`为非层叠上下文元素，那么`img`会层叠到根层叠上下文元素的下面，所以`box`会覆盖`img`。一旦设置了`box`的`opacity: .9`是，此时层叠上下文为`box`元素，那么按照***7阶堆叠顺序***, 负的`z-index`会覆盖在`background`的上面。

- 剩下的`transform != none`, `mix-blend-mode != normal`, `filter != none`, `isolation: isolation`, `position: fixed`, `will-change: 任意支持过渡的元素`, `-webkit-overflow-scrolling: touch`同理。

### 非定位元素层叠上下文和`z-index`的关系
- 不依赖`z-index`的层叠上下文元素的层叠顺序均是`z-index:auto`级别。（可以查看上面的”其他属性创建层叠上下文的图“, 需要注意的是`flex`, 他是依赖`z-index`的）
- 依赖`z-index`的层叠上下文元素的层叠顺序取决于`z-index`的值。
```
.a{
    position: absolute;
    z-index: 1;
    top: 10px;
    left: 40px;
}
.box{
    display: flex; /*普通元素*/
    background-color: blue;
}
.box > img{
    z-index: 1;  /*flex项是层叠上下文元素*/
}

<img class="a" class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
<div class="box">
    <img class="img" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png" alt="">
</div>
```