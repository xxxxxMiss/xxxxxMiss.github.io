---
title: flex布局
date: 2017-05-14 11:59:30
tags: 
    - css
categories: css
---

## 伸缩性flex
> 用来控制伸缩容器额外空间如何沿着伸缩容器的布局轴成比例的分配给各个伸缩项目。

```
flex: none;
等价于
flex-grow: 0;
flex-shrink: 0;
flex-basis: auto;

flex: 0 auto;
或者
flex: 0 1 auto;
或者
flex: initail;
等价于(也就是说他们单属性的默认值值分别是)
flex-grow: 0;
flex-shrink: 1;
flex-basis: auto;
```


```
flex: auto;
等价于
flex-grow: 1;
flex-shrink: 1;
flex-basis: auto;
```


```
flex: 1;
等价于
flex-grow: 1;
flex-shrink: 1;
flex-basis: 0%;
```

```
flex: 2 100px;
等价于
flex-grow: 2;
flex-shrink: 1;
flex-basis: 100px;
````