---
title: http-redirection
date: 2018-11-18 14:51:13
tags:
  - http
  - redirection
categories: http
---

## Permanent Redirection(永久重定向)

| statusCode | 含义 | 处理方法 | 场景 |
| -- | -- | -- | -- |
| 301 | 	Moved Permanently | GET 方法不会发生变更，其他方法有可能会变更为 GET 方法 | - |
| 308 | Permanent Redirect | 方法和消息主体都不发生变化 | - |

## Temporary Redirection(临时重定向)

| statusCode | 含义 | 处理方法 | 场景 |
| -- | -- | -- | -- |
| 302 | Found | GET 方法不会发生变更，其他方法有可能会变更为 GET 方法 | - |
| 303 | See Other | GET 方法不会发生变更，其他方法会变更为 GET 方法（消息主体会丢失) | - |
| 307 | Temporary Redirect | 方法和消息主体都不发生变化 | - |

## Special Redirection(特殊重定向)

| statusCode | 含义 | 场景 |
| -- | -- | -- | -- |
| 300 | Multiple Choice | 不会太多：所有的选项在消息主体的 HTML 页面中列出。也可以返回 200 OK 状态码。 |
| 304 | Not Modified | 缓存刷新：该状态码表示缓存值依然有效，可以使用。|

## 重定向的3种方法
> 当这3种方式同时存在时，优先级由高到低：http > html meta > js。

- 使用http协议重定向（上面介绍的3种重定向）

``` js
res.statusCode = 307
res.setHeader('Location', '/doc-new')
```

- 使用html`meta`标签

``` html
<head> 
  <meta http-equiv="refresh" content="0;URL=http://www.example.com/" />
</head>
```

> `content` 属性的值开头是一个数字，指示浏览器在等待该数字表示的秒数之后再进行跳转。建议始终将其设置为 0 来获取更好的可访问性。

- 使用js

``` js
window.location.href = 'http://www.example.com/'
```

## 对于不安全请求的临时响应节
不安全请求会修改服务器端的状态，应该避免用户无意的重复操作。一般地，你并不想要你的用户重复发送 `PUT`、`POST` 或 `DELETE` 请求。假如你仅仅为该类请求返回响应的话，简单地点击刷新按钮就会（可能会有一个确认信息）导致请求的重复发送。

在这种情况下，服务器可以返回一个 303 (See Other) 响应，其中含有合适的响应信息。如果刷新按钮被点击的话，只会导致该页面被刷新，而不会重复提交不安全的请求。

## 对于耗时请求的临时响应节
一些请求的处理会需要比较长的时间，比如有时候 DELETE 请求会被安排为稍后处理。在这种情况下，会返回一个 303 (See Other)  重定向响应，该响应链接到一个页面，表示请求的操作已经被列入计划，并且最终会通知用户操作的进展情况，或者允许用户将其取消。

## Nginx中配置重定向

``` nginx
server {
  listen 80;
  server_name example.com;
  return 301 $schema://www.example.com$request_uri;
}
```

可以使用 rewrite 指令来针对一个文件目录或者一部分页面应用重定向设置：

``` nginx
rewrite ^/images/(.*)$ http://images.example.com/$1 redirect;
rewrite ^/images/(.*)$ http://images.example.com/$1 permanent;
```
