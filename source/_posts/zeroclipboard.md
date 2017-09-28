---
title: zeroclipboard
date: 2017-07-30 13:57:51
tags:
    - js
categories: js
---

<style type="text/css" media="screen">
    .main-view{
        display: flex;
    }
    .label{
        border-bottom: 1px solid #AECDE9;
    }
    .one-half{
        flex: 1;
        display: inline-block;
        padding-left: 10px;
        padding-right: 10px;
    }
    textarea{
        width: 100%;
        border-radius: 8px;
        color: #4A4A4A;
        padding: 10px;
        border: 1px solid #979797;
        outline: none;
        box-sizing: border-box;
    }
    textarea:hover, textarea:focus{
        border: 1px solid #20a0ff;
    }

    .btn-clipboard{
        background-color: #fff;
        color: #5D9CD4;
        border: 1px solid #979797;
        border-radius: 8px;
        padding: 8px 20px;
        font-weight: 400;
        outline: none;
        cursor: pointer;
    }
    .btn-clipboard.zeroclipboard-is-hover
    {
        background: #3077B5;
        border: 1px solid #3077B5;
        color: #fff;
        text-decoration: none;
    }
    .btn-container{
        text-align: right;
    }
</style>

<script src="{% asset_path ZeroClipboard.js %}"></script>

## ZeroClipboard.js简介
> 是一个非常好用的用于复制文本到剪切板的，它的工作原理就是在你要点击的按钮上覆盖一个透明的flash。
> 所以你点击复制按钮，其实点击的是透明的flash，先将要拷贝的文本复制到flash，在将flash中的文本复制到剪切板。

注意：
- 由于考虑到安全性问题，`ZeroClipboard`需要工作在服务器上，也就是说你必须启动一个服务器（不管是本地服务，还是远程服务）。
<br>
- 引入`ZeroClipboard.js`的同时，需要在相同的文件夹下放置`ZeroClipboard.swf`。如果`ZeroClipboard.swf`没有放在和`ZeroClipboard.js`相同的文件夹下，需要手动配置。
<br>
- 当你hover要点击的按钮时，`ZeroClipboard`默认会在按钮上添加`zeroclipboard-is-hover`样式
<br>
- 当你激活按钮时，`ZeroClipboard`默认会在按钮上添加`zeroclipboard-is-active`样
<br>
- 所以当你需要为按钮添加hover或者active样式时，可以重写这两个样式。

```
ZeroClipboard.config({
    swfPath: "../path/new/"    
})
```

<div class="main-view">
    <div class="one-half">
        <h2 class="label"><label for="input">要拷贝的文本</label></h2>
        <textarea type="text" id="input" rows="6">copy me</textarea>
        <p class="btn-container">
            <button class="btn-clipboard" type="button" data-clipboard-target="input" id="btn-clipboard">拷贝文本</button>
        </p>
    </div>
    <div class="one-half">
        <h2 class="label"><label for="textarea">黏贴到这里</label></h2>
        <textarea id="textarea" rows="6"></textarea>
        <p class="btn-container">
            <button class="btn-clipboard" type="text" id="btn-clear">清空</button>
        </p>
    </div>
</div>

<script>
    var client = new ZeroClipboard(document.getElementById('btn-clipboard'))
    client.on('ready', function(readyEvent){
        alert('ZeroClipboard SWF is ready!')
    })

    document.getElementById('btn-clear').addEventListener('click', function(){
        document.getElementById('textarea').value = ''
    })
</script>


<p>
[详细用法参考这里](https://github.com/zeroclipboard/zeroclipboard/blob/master/docs/instructions.md)
</p>