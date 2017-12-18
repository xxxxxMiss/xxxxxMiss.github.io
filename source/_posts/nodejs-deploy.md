---
title: centos7部署nodejs+mongodb工程
date: 2017-10-14 14:13:20
tags: 
    - nodejs
    - mongodb
---

## 通过ssh登录阿里云主机
> ssh username@公网ip

```
bin
boot
dev
etc
home
lib
lib64
lost+found
media
mnt
opt
proc
root    [使用ssh root@公网ip成功登录后进入的目录]
run
sbin
srv
sys
tmp
usr
var
```
当使用root用户登录以后，会进入root目录，当你切换到上一层目录后，会看到如上所示的目录结构。

## 安装nvm
> 通过上一步的登录阿里云主机之后，你可以直接在root目录下，也可以新建其他的目录，然后安装nvm。
> `nvm`是node版本管理工具，通过该工具可以很方便的管理Node版本。

具体的安装步骤参考官方文档：
[nvm](https://github.com/creationix/nvm)

## 安装nodejs
> 一旦`nvm`成功安装以后，我们就可以通过`nvm`来安装nodejs。比如：

```
nvm install node // 安装最新版的nodejs
```

## 安装mongodb
> 具体的安装细节可以参照[mongodb官方文档](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)。

注意： 下面以在**64-bit systems**安装最新版的**mongdb3.4**为例：

### 配置包管理系统(yum)
> 新建/etc/yum.repos.d/mongodb-org-3.4.repo文件，然后将以下代码拷贝到该文件中.

```
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
```

### 安装mongodb包和相关的工具
> sudo yum install -y mongodb-org

默认情况下，mongodb存储数据在`/var/lib/mongo`，日志文件在`/var/log/mongodb`。当然，这些配置都是可以在`/etc/mongod.conf`中修改。

### 启动mongodb
> sudo service mongod start

### 查看mongodb是否成功启动
> 在日志文件中查看是否有这样的一行：[initandlisten] waiting for connections on port <port>

port：默认端口27017，可以在`/etc/mongod.conf`中修改。

### 停止mongodb
> sudo service mongod stop

### 重启mongodb
> sudo service mongod restart

### 卸载mongodb
> 卸载mongodb，会将mongodb程序本身，他的配置文件，以及所有的数据删除，并且该过程是不可逆的。所以在卸载之前，确保已经备份。

#### 停止mongodb
> sudo service mongod stop

#### 移除包
> sudo yum erase $(rpm -qa | grep mongodb-org)

#### 移除数据
> sudo rm -r /var/log/mongodb
> sudo rm -r /var/lib/mongo

## 安装nginx
> 可以直接从官网下载压缩包，也可以通过源码构建。因为nginx还依赖一些其他的包来扩展功能，所以还需要安装一些其他的依赖包。具体选择安装哪些依赖包，看你需要什么功能。

### 安装nginx所需的几个依赖包
> yum install gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel

### 通过源码构建
> [build nginx from source](http://nginx.org/en/docs/configure.html)

### 启动nginx
> service nginx start

### 重启nginx
> service nginx restart

## 安装git
> yum install git

更多git信息[传送门](https://git-scm.com/download/linux)

## 安装pm2
> npm install pm2 -g

更多pm2信息[传送门](https://github.com/Unitech/pm2)

## 开始部署项目
> 当上面的准备工作全部成功的完成以后，我们就可以部署我们的nodejs工程了。

### 克隆nodejs工程到阿里云主机
> git clone ...

### 安装工程依赖
> npm install

### 启动工程
> pm2 start app.js
