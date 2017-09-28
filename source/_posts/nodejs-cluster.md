---
title: nodejs-cluster
date: 2017-07-16 00:44:48
tags: 
    - nodejs
categories: 
    - nodejs
---

# Cluster
> 一个Node实例运行在一个单线程中。为了高效的利用多核系统，用户有时候需要启动一个Node进程的集群去处理负载。
> 通过cluster模块很容易的创建一些共享服务端口的子进程。

# How It Works(它是如何工作的)
> work进程通过`child_process.fork()`方法复制而来，因此它可以和父进程之间通过IPC信道交流，并且在他们之间来来回回的传递服务句柄。
> cluster模块支持2种方法分发到来的连接。
> 第一种方法（默认的方法，支持所有的平台，除了windows平台），轮询法，由master进程监听一个端口，接受新的连接，然后将这些连接分发到work进程。在分发中使用了一些内置的技巧防止work进程人任务过载。
> 第二种方法就是master进程创建监听的socket，然后发送到感兴趣的work进程，work进程直接接收到来的连接。
> 理论上，第二种方法有着更好的性能。但是在实践中，由于操作系统的调度机制的变化莫测，分发极度的不平衡。

由于已经发布了[官方的中文文档](http://nodejs.cn/api/cluster.html)，接下来的文档不在翻译了...