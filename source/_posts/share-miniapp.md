---
title: share-miniapp
date: 2018-10-20 14:22:57
tags:
  - 小程序
  - Hybrid开发
categories:
  - 前端
---

## [小程序架构](https://www.jianshu.com/p/4e8ed26d3b7a)

{% asset_img miniapp-structure.png 小程序架构 %}

## JSBridge
> JavaScript 是运行在一个单独的 JS Context 中（例如，WebView 的 Webkit 引擎、JSCore）。由于这些 Context 与原生运行环境的天然隔离，我们可以将这种情况与 RPC（Remote Procedure Call，远程过程调用）通信进行类比，将 Native 与 JavaScript 的每次互相调用看做一次 RPC 调用。
> 在 JSBridge 的设计中，可以把前端看做 RPC 的客户端，把 Native 端看做 RPC 的服务器端，从而 JSBridge 要实现的主要逻辑就出现了：通信调用（Native 与 JS 通信） 和 句柄解析调用。（如果你是个前端，而且并不熟悉 RPC 的话，你也可以把这个流程类比成 [JSONP](#JSONP实现原理) 的流程）

{% asset_img jsbridge.png js桥接 %}

JavaScript 调用 Native 的方式，主要有两种：注入 API 和 拦截 URL SCHEME。

### 注入API

注入 API 方式的主要原理是，通过 WebView 提供的接口，向 JavaScript 的 Context（window）中注入对象或者方法，让 JavaScript 调用时，直接执行相应的 Native 代码逻辑，达到 JavaScript 调用 Native 的目的。

IOS:

``` objectivec
JSContext *context = [uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

context[@"postBridgeMessage"] = ^(NSArray<NSArray *> *calls) {
    // Native 逻辑
};
```

前端调用

``` js
window.postBridgeMessage(message);
```

Android
``` java
public class JavaScriptInterfaceDemoActivity extends Activity {
  private WebView Wv;

  @Override
  public void onCreate(Bundle savedInstanceState){
      super.onCreate(savedInstanceState);

      Wv = (WebView)findViewById(R.id.webView);     
      final JavaScriptInterface myJavaScriptInterface = new JavaScriptInterface(this);    	 

      Wv.getSettings().setJavaScriptEnabled(true);
      Wv.addJavascriptInterface(myJavaScriptInterface, "nativeBridge");

      // TODO 显示 WebView

  }

  public class JavaScriptInterface {
        Context mContext;

        JavaScriptInterface(Context c) {
            mContext = c;
        }

        public void postMessage(String webMessage){	    	
            // Native 逻辑
        }
    }
}
```

前端调用：

``` js
window.nativeBridge.postMessage(message);
```

``` java
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical" >
    <WebView
      android:id="@+id/webView"
      android:layout_width="fill_parent"
      android:layout_height="fill_parent"
  />
</LinearLayout>
```

### 拦截URL SCHEMA
> URL SCHEME：URL SCHEME是一种类似于url的链接，是为了方便app直接互相调用设计的，形式和普通的 url 近似，主要区别是 protocol 和 host 一般是自定义的，例如: qunarhy://hy/url?url=ymfe.tech，protocol 是 qunarhy，host 则是 hy。
> 拦截 URL SCHEME 的主要流程是：Web 端通过某种方式（例如 iframe.src）发送 URL Scheme 请求，之后 Native 拦截到请求并根据 URL SCHEME（包括所带的参数）进行相关操作。

### JSBridge雏形

``` js
(function () {
    var id = 0,
        callbacks = {};

    window.JSBridge = {
        // 调用 Native
        invoke: function(bridgeName, callback, data) {
            // 判断环境，获取不同的 nativeBridge
            var thisId = id ++; // 获取唯一 id
            callbacks[thisId] = callback; // 存储 Callback
            nativeBridge.postMessage({
                bridgeName: bridgeName,
                data: data || {},
                callbackId: thisId // 传到 Native 端
            });
        },
        receiveMessage: function(msg) {
            var bridgeName = msg.bridgeName,
                data = msg.data || {},
                callbackId = msg.callbackId; // Native 将 callbackId 原封不动传回
            // 具体逻辑
            // bridgeName 和 callbackId 不会同时存在
            if (callbackId) {
                if (callbacks[callbackId]) { // 找到相应句柄
                    callbacks[callbackId](msg.data); // 执行调用
                }
            } elseif (bridgeName) {

            }
        }
    };
})();
```

## JSONP实现原理
> 听者作答

``` js
window._callback = function (data) {
  // your logic
}

var script = document.createElement('script')
script.src = `${url}&_callback=_callback`

// ...
```

## JavaScript 与 Objective-C 交互

主要通过以下2种方式：

- Block: 第一种方式是使用block，block也可以称作闭包和匿名函数，使用block可以很方便的将OC中的单个方法暴露给JS调用，具体实现我们稍后再说。
- JSExport 协议: 第二种方式，是使用JSExport协议，可以将OC的中某个对象直接暴露给JS使用，而且在JS中使用就像调用JS的对象一样自然。

栗子：通过Block形式

``` objectivec
context[@"makeNSColor"] = ^(NSDictionary *rgb){
  float r = [colors[@"red"] floatValue];
  float g = [colors[@"green"] floatValue];
  float b = [colors[@"blue"] floatValue];
  return [NSColor colorWithRed:(r / 255.0)
    green: (g / 255.0f)
    blue: (b / 255.0f)
    alpha: 1.0
  ];
};
```

``` js
const colorForWord = function (word) {
  if (!colorMap(word)) return

  return makeNSColor(colorMap(word))
}

const colorMap = {
  orange: { red: 255, green: 255, blue: 0 },
  cyan: { red: 255, green: 155, blue: 0 }
}
```

{% asset_img js-oc-call.png js和oc的相互调用 %}

{% asset_img js-oc-type.png js和oc的类型对应关系 %}

## 原生小程序开发痛点：

- 仅支持大部分es2015语法，无法使用es2016+语法（async/await等）
- 对于背景图片，无法使用本地路径，需要上传图片至服务器以使用远程地址或者转化为base64编码
- 对于直接使用iconfont，需要转换成base64编码
- 不支持css预处理器（less, scss, stylus等）
- 无法使用eslint等代码检查工具
- 对于第三方依赖，需要手动拷贝源代码到项目中，无法直接使用npm包
- ...
- 总结起来就是无法*工程化*


## 优化

- 代码压缩
- 及时清理无用代码和资源文件（这条已经变得不是很重要了，因为现在没用到的资源并不会被打包）
- 减少代码包中的图片等资源文件的大小和数量
- 提前请求，但是请求的数据不立即发送到视图层渲染，而是在合适的时机在渲染（`setData`）
- 缓存，利用 storage API 对异步请求数据进行缓存，二次启动时先利用缓存数据渲染页面，在进行后台更新
- 分包加载

### 分包优点以及限制

{% asset_img sub-package.png 分包加载 %}

优点：
> 对开发者而言，能使小程序有更大的代码体积，承载更多的功能与服务
> 对用户而言，可以更快地打开小程序，同时在不影响启动速度前提下使用更多功能

限制：
> 整个小程序所有分包大小不超过 8M
> 单个分包/主包大小不能超过 2M

### 避免不当使用setData

{% asset_img miniapp-render.png 小程序的渲染机制 %}

- 使用 data 在方法间共享数据，可能增加 setData 传输的数据量。。data 应仅包括与页面渲染相关的数据。
- 使用 setData 传输大量数据，**通讯耗时与数据正相关，页面更新延迟可能造成页面更新开销增加。**仅传输页面中发生变化的数据，使用 setData 的特殊 key 实现局部更新。
- 短时间内频繁调用 setData，**操作卡顿，交互延迟，阻塞通信，页面渲染延迟。**避免不必要的 setData，对连续的setData调用进行合并。
- 在后台页面进行 setData，**抢占前台页面的渲染资源。**页面切入后台后的 setData 调用，延迟到页面重新展示时执行。

### 避免不当使用onPageScroll

- 只在有必要的时候监听 pageScroll 事件。不监听，则不会派发。
- 避免在 onPageScroll 中执行复杂逻辑
- 避免在 onPageScroll 中频繁调用 setData
- 避免滑动时频繁查询节点信息（SelectQuery）用以判断是否显示，部分场景建议使用节点布局橡胶状态监听（inersectionObserver）替代

## 小程序开发框架比较

{% asset_img framework-comparison.png 小程序开发框架比较 %}

## 各大框架的转化原理（以taro为例）

{% asset_img taro-build.png taro转化原理 %}

## 各大框架相关链接

### [Taro](https://nervjs.github.io/taro/doc/router.html)
> [官方仓库](https://github.com/NervJS/taro/issues)

- [Related](https://aotu.io/notes/2018/06/07/Taro/index.html)

### [nanachi](https://rubylouvre.github.io/nanachi/index.html)
> [官方仓库](https://github.com/RubyLouvre/anu/tree/master/packages/cli)

### [mpvue](http://mpvue.com/)
> [官方仓库](https://github.com/Meituan-Dianping/mpvue/issues)

### [megalo](https://kaola-fed.github.io/megalo-docs/#/)
> [官方仓库](https://github.com/kaola-fed/megalo/issues)

