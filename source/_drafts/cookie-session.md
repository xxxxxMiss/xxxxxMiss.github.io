---
title: cookie-session
tags: 
 - cookie 
 - session
category: nodejs
---
## cookie和session的区别
1. `cookie` 存储在浏览器（有大小限制），`session` 存储在服务端（没有大小限制）
2. 通常 `session` 的实现是基于 `cookie` 的，即 `session id` 存储于 `cookie` 中