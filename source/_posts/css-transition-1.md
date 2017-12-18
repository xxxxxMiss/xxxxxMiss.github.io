---
title: css动画常见案例
date: 2017-10-10 20:28:18
tags:
    - css
categories:
    - frontend
---

<style type="text/css" media="screen">
   .container{
     margin: 15px auto;
   }
   .btn{
     position: relative;
     display: inline-block;
     box-sizing: border-box;
     outline: none;
     border: 1px solid #ebebeb;
     padding: 0 15px;
     height: 30px;
     line-height: 30px;
     border-radius: 4px;
     user-select: none;
     cursor: pointer;
     text-align: center;
     color: #fff;
     background-color: #00c1de;
   }
   .btn.btn-blink:after{
     position: absolute;
     content: "";
     top: -1px;
     left: -1px;
     bottom: -1px;
     right: -1px;
     border: 0 solid #00c1de;
     border-radius: 4px;
     box-shadow: 0 0 2px 0 #00c1de;
     animation: blink .3s cubic-bezier(.645,.045,.355,1);
   }
   @keyframes blink{
     from {
       opacity: 1;
       transform: scale(1);
     }
     to {
       opacity: 0;
       transform: scale3d(1.1, 1.2, 0);
     }
   }

   .btn-round-blink{
     font-size: 30px;
     font-weight: 500;
     margin: 0 30px;
     height: 30px;
     width: 30px;
     border-radius: 50%;
   }
   .btn-round-blink:before,
   .btn-round-blink:after{
     position: absolute;
     content: "";
     top: 0;
     left: 0;
     right: 0;
     bottom: 0;
     border: 1px solid #00c1de;
     border-radius: 50%;
   }
   .btn-round-blink:before{
     animation: round-blink 2s infinite;
   }
   .btn-round-blink:after{
     animation: round-blink 1s infinite;
   }

   @keyframes round-blink{
     from {
       opacity: 1;
       transform: scale(1);
     }
     to {
       opacity: 0;
       transform: scale(1.88);
     }
   }

   .progress{
     position: absolute;
     left: -100%;
     top: 0;
     background-color: #00c1de;
     width: 100%;
     height: 3px;
   }
   .progress.fade-in{
     animation: fade-in 1s ease-in;
   }

   @keyframes fade-in{
     from {
       transform: translate3d(0, 0, 0);
     }
     to {
       transform: translate3d(200%, 0, 0);
     }
   }

   .progress-grow{
     position: absolute;
     left: 0;
     top: 0;
     width: 0;
     height: 3px;
     background-color: #00c1de;
     animation: grow-in 1s infinite;
   }
   @keyframes grow-in{
     from {
       width: 0;
     }
     to{
       width: 100%;
     }
   }
</style>

<div class="progress" id="progress"></div>
<div class="container">
    <button class="btn" id="btn">显示进度条</button>
</div>
<div class="container">
    <button class="btn btn-round-blink"></button>
</div>

<script>
  var btn = document.getElementById('btn')
    , progress = document.getElementById('progress')
  btn.addEventListener('mouseup', function () {
    this.classList.add('btn-blink')
  })
  btn.addEventListener('animationend', function () {
    this.classList.remove('btn-blink')
  })
  btn.addEventListener('click', function () {
    progress.classList.add('fade-in')
  })
  progress.addEventListener('animationend', function () {
    progress.classList.remove('fade-in')
  })
</script>

> 本篇主要内容是如何自己实现各种网站，UI框架的一些过渡效果

## 按钮
> 之前看到[ant design](https://ant.design/components/button-cn/)上按钮的那种点击效果，于是按照自己的思路来模拟下。

这种效果其实有多种实现方式，我们这里提供一种:

```css
// 按钮的样式
.btn{
  position: relative;
  display: inline-block;
  box-sizing: border-box;
  outline: none;
  border: 1px solid #ebebeb;
  padding: 0 15px;
  height: 30px;
  line-height: 30px;
  border-radius: 4px;
  user-select: none;
  cursor: pointer;
  text-align: center;
  color: #fff;
  background-color: #00c1de;
}
// 一闪而过的矩形
.btn.btn-blink:after{
  position: absolute;
  content: "";
  top: -1px;
  left: -1px;
  bottom: -1px;
  right: -1px;
  border: 1px solid #00c1de;
  border-radius: inherit;
  box-shadow: 0 0 2px 0 #00c1de;
  // 合理执行时间和缓动函数可以使动画看起来更加的舒适。。。
  // 所以需要自己慢慢的调试
  animation: blink .3s cubic-bezier(.645,.045,.355,1);
}
// 一闪而过的动画
@keyframes blink{
  from {
    opacity: .5;
    transform: scale(1);
  }
  to {
    opacity: 0;
     // y轴的放大应该比x轴大一些，因为一般按钮情况下按钮的宽度都是大于高度的
     // 如果不这样做，动画就不是很理想了
    transform: scale3d(1.1, 1.2, 0);
  }
}
```

## 闪烁效果
> 这种效果就跟水波一样，一层一层的像远处散开然后消失。
> 最简单的用before和after伪类就可以实现，当然了这也只是一种实现。如果觉得不够逼真，那么就需要你慢慢的调试，改动缓动函数以及动画执行的事件。

```css
.btn{
    // 同上 
}
.btn-round-blink{
  font-size: 30px;
  font-weight: 500;
  margin: 0 30px;
  height: 30px;
  width: 30px;
  border-radius: 50%;
}
.btn-round-blink:before,
.btn-round-blink:after{
  position: absolute;
  content: "";
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border: 1px solid #00c1de;
  border-radius: 50%;
}
.btn-round-blink:before{
  animation: round-blink 2s infinite;
}
.btn-round-blink:after{
  animation: round-blink 1s infinite;
}
```

## 进度条
> 进入条一般用在异步请求中。

```css
// 可以用这种效果
.progress{
  position: fixed;
  left: -100%;
  top: 0;
  background-color: #00c1de;
  width: 100%;
  height: 3px;
}
.progress.fade-in{
  animation: fade-in 1s ease-in infinite;
}
@keyframes fade-in{
  from {
    transform: translate3d(0, 0, 0);
  }
  to {
    transform: translate3d(200%, 0, 0);
  }
}

// 也可以用这种效果
.progress-grow{
  position: fixed;
  left: 0;
  top: 0;
  width: 0;
  height: 3px;
  background-color: #00c1de;
  animation: grow-in 1s infinite;
}
@keyframes grow-in{
  from {
    width: 0;
  }
  to{
    width: 100%;
  }
}
```