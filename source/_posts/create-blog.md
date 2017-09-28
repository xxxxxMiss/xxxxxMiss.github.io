---
title: 使用hexo搭建自己的博客
date: 2017-09-28 23:17:08
tags: 
    - js
    - frontend-framework
---
## 环境
- Node
- [github](https://github.com/)
- [git-pages](https://pages.github.com/)
- git或者其他的版本控制工具
- [Hexo](https://github.com/hexojs/hexo)或者其他的SSG

## Hexo相关配置
> [Hexo](https://hexo.io/)

### 几个主要命令
- hexo new post/draft &lt;file-name&gt;

> 会在source目录下的_posts或则_drafts下生成file-name.md。
> 也就是说你在使用`hexo new`创建文件的时候，不需要带文件扩展名，默认生成markdown文件

- hexo clean

> 清楚缓存，一般在使用`hexo deploy`命令时，先执行该命令。

- hexo deploy

> 推送到仓库到远程


## markdown语法
> [markdown](http://www.appinn.com/markdown/)

注意：
- 在hexo中使用markdown时，引用外部资源的时候，需要按照hexo提供的语法来引用。
比如引用图片：
```
{% asset_img stacking-props.png 其他属性的元素 %}
```

上面的`{% asset_img %}`是固定语法，`stacking-props.png`是对应的资源文件，`其他属性的元素`是鼠标hover时候显示的字符。当然了，你也可以不传该参数，那么hover的时候就显示`stacking-props.png`

- 按照上一步引用资源，需要在`_config.yml`中将`post_asset_folder`选项设置为`true`。一旦开启该选项，那么在每次使用`hexo new`创建文章的时候，都会在对于的目录下生成和文件名相同的目录，你的静态资源就放到该目录下。

比如：
```bash
$ hexo new post hexo-blog
```

那么在`source/_posts`下就会生成`hexo-blog.md`文件和`hexo-blog`文件夹。

- markdown中的一些特殊字符需要转义
比如：`<`需要写成`&lt;`

更多选项参考[官方文档这里](https://hexo.io/docs/asset-folders.html)

## yaml语法
> [yaml](http://www.ruanyifeng.com/blog/2016/07/yaml.html?f=tt)

