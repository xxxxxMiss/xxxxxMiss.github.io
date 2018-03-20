---
title: DOM元素的坐标，大小相关API梳理
date: 2018-01-07 22:47:43
tags: 
    - dom
categories:
    - js
---

## getBoundingClientRect()
> 该API返回元素的大小及其相对于视口的位置。
> 需要注意的是：不论该元素是普通的元素，还是相对定位、绝对定位，还是fixed定位，亦或被定位（相对，绝对，fixed）元素包裹的元素，返回的对象中坐标(x,y)，top,left都是相对于视口的坐标。
> 如果该元素是可以滚动或者滑动的，那么坐标会立即改变的。
> 如果需要得到文档坐标，可以[参看这里](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/getBoundingClientRect)

Note: 该API返回的对象包含如下几个属性，并且这些属性的值可以包含浮点数：
```js
{   top: '',
    right: '',
    bottom: ''
    left: '',
    width: '', // 该width是content+padding+border的宽度
    height: '',
    x: '',
    y: ''
}
```

---
以下的这些API返回的都是整数的像素值，不带单位的

## clientWidth
> 只读属性，返回一个`block`或者`inline-block`元素的`content + padding`的像素值。
> 如果有滚动条存在，那么`clientWidth = content + padding - 垂直滚动条的宽度`

## clientLeft
> 只读属性，返回一个`block`或者`inline-block`元素的边框的宽度（border-width）的像素值。
> 如果有滚动条存在，那么该宽度是包含滚动条在内的宽度。

## scrollHeight
> 只读属性，包括元素的整个高度（溢出导致在视野之外的部分）
> 这个整个高度也是`content + padding`的高度，不包括`border`和`margin`的高度。

## scrollTop
> 读取或者设置垂直滚动条的高度

## offsetHeight
> 该属性返回一个元素的`content + padding + border + 滚动条（如果有）`的高度，不论该元素是`inline`还是`block`类型的元素。

## offsetLeft
> 只读属性，返回当前元素左上角相对于`offsetParent`节点的左边界偏移的像素值。
> 详细信息可[参看这里](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/offsetLeft)

## offsetParent
> 只读属性，返回一个**最近的**的包含该元素的定位元素。如果没有定位元素，那么`offsetParent`为**最近的**`table`,`table cell`或者根元素`html`。
