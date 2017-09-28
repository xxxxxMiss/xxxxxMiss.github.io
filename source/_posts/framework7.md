---
title: Framework7
date: 2017-04-29 16:31:38
tags: 
  - framework7
  - hybrid
categories: 前端框架
---

## 启动
> 由于所有的页面都是通过ajax的形式拉取到主页面中显示，所以必须将启动一个服务器将工程部署到服务器上。
> framework7默认使用gulp构建项目的，所以可以如下进行本地开发：

```
// 在工程的根路径下安装依赖
npm/yarn install 

// 启动服务
gulp server 
```

## 视图布局
### 单视图布局
> 使用最广泛的布局，使用单一视图 + 路由 + 头部导航(navbar) + 底部导航(toolbar) + 侧边栏(panel)

### tabbar切换
> 这种方式的视图布局，每个tabbar都有自己独立的“单视图布局”

### 分屏布局
> 这种方式一般使用在屏幕比较大的时候，比如`ipad`，最大优点是可以同时显示多个视图（一般左右两边）

### 内联页面
> 这种方式下，页面不需要通过ajax加载过来，其他页面直接写在dom中

### 内建的模板引擎加载视图
> 使用f7内置的模板引擎来加载指定的视图

## View
> `<div class="view">`, 视图是app独立的可视化部分，每个view都可以有自己的设置,导航，不同的样式，布局等。这种功能可以让你很容易的在app中插入各种各样的视图。

## Views
> `<div class="views"></div>`, 是所有`view`的容器，也就是app容器，在任何时候该容器都是可见的。
> 一个app当然只能有一个容器，即只允许有一个`views`。

## page
> `<div class="page"></div>`, `page`跟`view`不同，`page`没有`navbar`,`tabbar`等导航，它主要用来显示页面的内容部分。

## Pages
> `<div class="pages">`, 是`page`的容器，一个`pages`可以包含多个`page`,就相当于一个页面中的内容可以被分成多个部分的内容来显示。
> 所有`page`的过渡动画都是在`pages`上实现的。
> Note: 在主`views`中，总是应该包含一个`view`，在这个`view`中总是应该包含一个`pages`。

### data-page
> 在每个`page`上，你都应该指定一个`data-page`属性，虽然这不是必须的，但是极其推荐都加上他。
> 因为在`page events`和`page callbacks`中非常有用，他帮助我们操作去加载指定的页面和操作指定的页面。


### page-content
> 所有可见的内容都应该放在`<div class="page-content">`中，并且将该元素作为`<div class="page" data-page="index">`的子元素。
> 列表的滚动就是在改元素上实现的。

一个基本的视图骨架
```
<body>
    ...
    //这些面板可以理解为全局性的，不管你如何切换视图，他们都是保持不变的
    // 被覆盖的面板
    <div class="panel panel-lef panel-reveal">
        <div class="view view-panel">...</div>
    </div>
    // 覆盖别人的面板
    <div class="panel panel-right panel-cover">
        <div class="view view-panel">...</div>
    </div>
    <!-- views -->
    <div class="views">
        <!-- main view -->
        <div class="view view-main">
            <!-- Navbar -->

            <!-- Pages -->
            <div class="pages">
                <div class="page" data-page="home">
                    ... page contents goes here ...
                </div>
            </div>
            <!-- Toolbar -->
        </div>
        <!-- other view -->
        <div class="view another-view">
            <!-- Navbar -->

            <!-- Pages -->
            <div class="pages">
                <div class="page" data-page="home-another">
                    ... page contents goes here ...
                </div>
            </div>
            <!-- Toolbar -->
        </div>
    </div>
    ...
</body>
```

## 初始化View
> `views`已经在html中准备完毕，那么接下来就需要在js中对其初始化。
> 需要注意的是，并不是所有的`views`都是需要初始化的，我们应该只初始化那些需要导航的视图。
> 像这些`panel`,`popup`等,我们并不需要初始化的，只需要保证一个正确的布局就可以了。

## 初始化app和view
```
var myApp = new Framework7({
    //....
})
```
这个`myApp`实例上有一系列的方法让我们来操作app的各个视图，其中初始化视图的方法为：
```
var view = myApp.addView(selector, params)
```
- selecotr: css选择器或者Dom节点
- params: 一个控制视图参数的对象
- return: 返回初始化的视图实例

对`params`中的2个选项进行下分析:
- preroute: function(view, options),该选项类似于`Vue`中路由钩子函数`beforeRouteEnter`, 允许在进入某个路由的前做一些操作。
- preprocess: function(content, url, next), 该选项类似于`Vue`中的生命周期函数`beforeMount`, 允许在视图渲染到dom前做最后的一些操作。

[关于`params`中的其他的选项，可参看官方文档](http://framework7.io/docs/views.html)

## 默认视图url
> 可以在`view`元素上设置`data-url`或则在初始化视图的时候指定`url`选项来指定默认的视图。

```
<div class="view" data-url="index.html"></div>
```

## 访问视图实例
> myApp.views[name] | myApp[nameView]

```
var myApp = new Framework7()

myApp.addView('.left-view', {})

// 访问视图实例
myApp.views.left
// 或者
myApp.leftView
```
> 需要注意的是，主视图的实例的访问一定是这样的`myApp.mainView`或者`myApp.views.main`。
> 即使你初始化视图的时候，指定了其他的名字也是无效的。

## 通过dom元素来得到指定的视图实例
> 在视图初始化之后，F7会在`<div class="view">`的元素上增加一个特殊的链接属性，所以我们在js中任何时候都可以这样来获取视图实例：

```
var viewEl = $$('.main-view')[0]
var viewInstance = viewEl.f7View
```

> 同时，所有视图的实例都会挂载到app实例的views属性上，而对于主视图又是很特殊，所有我们也可以通过下面的方式来后去主视图：

```
var views = myApp.views
for(var i = 0; i < views.length; i++){
    var view = views[i]
    if(view.main) myApp.alert('I found the main view')
}
```

## 页面事件
> 关于页面最重要的部分就是页面事件，通过执行js代码来操作指定的页面。

示例:
```
// 方式一
$$(document).on('page:init', function(e){
    // do something here when page loaded and initialized
})

// 方式二
$$(document).on('page:init', '.page[data-page="about"]', function(e){
    // do something here when page with data-page=about attribute loaded and initialized
})
```

## page data
> 上面的关于页面事件的使用很简单，但是使用一个事件处理函数来处理页面的加载，那么如何处理页面加载的优先级？这就是page data排上用场的时候了。。。

实例:
```
// in page callbacks:
myApp.onPageInit('about', function(page){
    // "page" variable contains all required information about loaded and initialized page
})

// in page events
$$(document).on('page:init', function(e){
    // "page" variable contains all required information about loaded and initialized page
    var page = e.details.page
})
```
> `page`是一个对象，关于该对象包含了页面的哪些信息，参看[官方文档](http://framework7.io/docs/pages.html#page-data)

## page callbacks
> 为指定的页面执行指定的代码，使用page callbacks更加的方便友好，他比page events有以下几点好处：

- page callbacks不是事件，这就意味着更少的内存利用和更少出现内存溢出
- 因为不是事件，所以你无需担心需要解绑他们
- 使用page callbacks可以更好的组织代码结构

关于一些page callbacks的说明：
- myApp.onPageBeforeInit(pageName, callback(page))
> 仅仅当F7将含有`data-page=pageName`的页面插入到DOM中时触发回调，此时仅能保证`page`元素已经插入到DOM，并不能保证该`page`中的其他组件插入到DOM中。

- myApp.onPageInit(pageName, callback(page))

> 和`onPageBeforeInit`的区别是`page`和`page`中的其他组件也都插入到DOM中了。

- myApp.onPageReInit(pageName, callback(page))

> 该回调只适用于**开启缓存**的**内联**的模板页面。

Note: 我们可以为`page callbacks`传入多个以空格分割的`pageName`和多个`callback`，还可以为`pageName`传入通配符.
```
// 因为某些页面可能有一些相同的逻辑
myApp.onPageInit('about services', function(page){

})

// 为同一个页面增加多个回调
myApp.onPageInit('about', function(page){
    console.log('a')    
})
myApp.onPageInit('about', function(page){
    console.log('b')    
})

// 通过通配符为所有页面添加相同的回调
myApp.onPageInit('*', function(page){
    console.log('all pages')
})
```

[page callbacks具体api可以参看官方文档](http://framework7.io/docs/page-callbacks.html#callbacks-methods)

## 路由API
> F7中常见的4中路由方式:

- ajax加载页面（默认使用的方式）：从其他文件中加载页面
- 使用js api创建动态的页面
- 使用内联页面，就是这些页面已经存在在DOM中，不需要通过额外的加载。就相当于是静态的页面，只需要控制显示隐藏而已
- 使用Template7模板加载页面

> 在一个app中，你可以灵活的组合使用这些方式。因为视图`view`是一个app中独立的可视化部分，所以当你使用路由之前，一定要先初始化视图，初始化视图之后，就可以使用视图提供的方法导航到app中的各个部分（`pages`, `popup`, `panels`）等。

[具体的路由方法，参看官方文档](http://framework7.io/docs/router-api.html#view-navigation-shortcuts-methods)

## F7中使用ajax加载页面
> 在F7中，默认情况下所有的链接都使用ajax加载，除了指定了`external`的链接或则没有正确的href属性的链接（href="#"或则为空）。
> 这种行为当然是可以改变的，可以通过在初始化app的时候指定`ajaxLinks`选项来改变这种行为。
例子：

```
new Framework7({
    // 这个属性的值是一个css选择器
    ajaxLinks: 'a.ajax' //含有ajax类名的a链接才会使用ajax加载
})
```

## 返回上一步
> 在F7中，返回上一步只要在指定的a链接上增加一个`back`类名就可以了。但是关于返回链接有几点需要注意的：

```
<a href="index.html" class="back"></a>
```
> 当导航历史中已经有了记录的时候，`href`属性的值是被忽略掉的。
> 当导航历史中没有记录的时候，才会使用`href`属性的值，比如首页的时候。
> 这种行为是不可改变的，因为通常情况下，用户点击返回就是返回上一步，并不需要做一些额外额操作。
> 也就是说，对于回退链接而言，`href`属性并不是必须的。

## IOS主题下的swipeback
> 在iOS主题下，你可以配置`swipeback`选项来滑动切换页面，但是有时候你可能需要禁用这种行为，那么可以这样：

```
// 在page上增加一个no-swipeback即可
<div class="page no-swipeback">
    
</div>
```

## 加载、回退时禁用过渡效果
> 取消加载，回退时的过渡效果，可以设置全局的`noAnimate`或者配置`animatePages`选项。
> 当你想局部禁用或者开启某些页面的过渡效果时，可以这样：

```
<a href="about.html" class="no-animation"></a>
<a href="about.html" class="back no-animation"></a>
```
当开启全局禁用，但是想局部开启过渡时：
```
<a href="about.html" class="with-animation"></a>
<a href="about.html" class="back with-animation"></a>
```

关于导航还有一些其他的选项，可以通过配置`data-`前缀来控制，具体参看[官方文档](http://framework7.io/docs/pages-ajax.html)

## 动态加载页面
> 动态加载的页面url遵循如下规则: `#content-{{index}}`,这个`{{index}}`占位符会被导航历史中的索引替换。当然在app初始化的选项中通过`dynamicPageUrl`来改变默认的规则。

示例：
```
// 可以将字符串提取到单独的模板中，方便书写
// <script type="text/template" id="contentTpl"><div>...</div></script>
var newContent = `
    <div>
        <div>
            //...
        </div>
    </div>
`
mainView.router.loadContent(newContent)
或者
mainView.router.load({
    content: newContent, // $$('#contentTpl').html()
    animatePages: false
})
```

## 内联页面
> 使用这一特征，你可以将所有的页面都放在DOM中，这样app一次性加载全部页面。
> 默认情况下，内联页面的行为是禁止的，你可以在初始化view的时候使用`domCache: true`来激活。

内联页面结构一般如下：
```
<div class="views">
    <div class="view view-main">
        <div class="navbar">
        <!-- 当需要动态的navbar时，这样布局 -->
        <!-- home-navbar -->
        <!-- data-page属性需要和对应的page一致 -->
            <div class="navbar-inner" data-page="index">
                <div class="center">home</div>
            </div>
        <!-- about-navbar -->
            <div class="navbar-inner cached" data-page="about">
                <div class="center">about</div>
            </div>
        <!-- services-navar -->
            <div class="navbar-inner cached" data-page="services">
                <div class="center">services</div>
            </div>
        </div>
        <!-- 动态navbar的时候，需要navbar-through -->
        <div class="pages navbar-through">
        <!-- home page -->
            <div class="page" data-page="index">
                <div class="page-content"></div>
            </div>

        <!-- about page -->
            <div class="page cached" data-page="about">
                <div class="page-content"></div>
            </div>

        <!-- services page -->
            <div class="page cached" data-page="services">
                <div class="page-content">
                </div>
            </div>
        </div>
    </div>
</div>
```
> 由上面的结构可以看出，内联页面布局和一般的页面布局没有什么太大的差异，唯一的不同点就是所有需要的页面已经存在于DOM中，非激活页面含有一个`cached`类名。

### 关于内联页面的其他配置
> ajax加载页面中的选项如返回导航，`data-`配置等，都可以在内联页面中使用。同时，内联页面也可以通过ajax来加载，内联页面的其他配置不需要做改动，唯一需要改变的就是增加js代码：

```
mainView.router.load({
    pageName: 'test'
})
```
### 通过js来控制内联页面的返回
```
mainView.router.back()
```

## Template7模板引擎
> F7已经内置了Template7模板引擎，所以你需要额外安装，当然你可以单独的安装Template7。
> Template7模板引擎的语法类似`handlebars`模板引擎的语法。
> Template7模板引擎轻量高效，最慢的地方就是使用`Template7.compile()`将字符串模板解析为原生的js函数，所以一定要记得缓存编译后的js函数，不要对一个相同的模板多次编译。

## F7自动编译Template7模板
> 在F7中，可以自动编译Template7模板，只需要做如下4件事：
> 1,将模板字符串放在`script`标签中
> 2,设置`type="text/template7"`
> 3,给`script`标签一个唯一的`id`
> 4,初始化app的时候配置选项`precompileTemplates: true`

---

> 编译后的模板函数都会挂载到`Template7.templates`和`myApp.templates`对象上，所以你可以将所需数据传入编译后的函数，调用函数获取html字符串。

实例：
```
// 模板
<script type="text/template7" id="personTemplate">
    <div>hello, my name is {{name}}, i am {{age}} years old</div>
</script>

// 初始化app
var myApp = new Framework7({
    precompileTemplates: true
})

// 获取编译函数并调用
// Template7.templates[id], id为script标签中指定的id
var personHtml = Tempate7.templates.personTemplate({
    name: 'f7',
    age: 10
})
```

## Template7 pages
> F7提供了一系列方式允许我们渲染ajax页面和动态页面作为Template7模板。
> 激活这一功能，必须在初始化app的时候配置`template7Pages: true`。

## F7和Template7的使用
> 在F7中使用Template7，常用的几种方式如下：

index.html
```
<div class="pages">
    <!-- 首页 -->
    <div class="page" data-page="index">
        <!-- about页面 -->
        <a href="#" data-template="about" data-context-name="about"></a>
        <!-- services页面 -->
        <a href="services.html" data-context-name="services"></a>
        <!-- cars页面 -->
        <a href="cars.html"></a>
    </div>
</div>

<script type="text/template7" id="about">
    <div class="navbar">
        <div class="navbar-inner">
            <div class="left"> </div>
            <div class="center"> about page </div>
        </div>
    </div>
    <div class="pages">
        <div class="page" data-page="about">
            <span>My name is {{name}}, i am {{age}} years old!</span>
        </div>
    </div>
</script>
```

cars.html(services.html结构一样，不再列出)
```
<div class="navbar">
    <div class="navbar-inner">
        <div class="left">
            <a href="#" class="back link">
                <i class="icon icon-back"></i><span>返回</span>
            </a>
        </div>
        <div class="center">services page</div>
    </div>
</div>
<div class="pages">
    <div class="page" data-page="services">
        <ul>
        {{#each this}}
            <li>{{this}}</li>
        {{/each}}
        </ul>
    </div>
</div>
```


JS代码：
```
var myApp = new Framework7({
    animateNavBackIcon: true, // 开启返回按钮的icon动画效果
    precompileTemplates: true, // 开启自动编译模板    
    template7Pages: true, // 开启使用ajax，动态页面作为template7模板
    template7Data: { // 模板数据
        'url: services.html': { // 通过url匹配页面

        },
        'page:cars': ['', '', ''], // 通过data-page匹配页面
        about: { // 简单的数据，页面中需提供data-context-name来指定模板的上下文
            name: 'F7',
            age: 2
        }
    },
    //.... 其他的配置项
})
```