---
title: docker
date: 2018-03-06 23:58:01
tags:
categories:
---

## docker简介
> docker是一个开发，运输，运行程序的一个平台。docker将你的程序和基础设施隔离开来，以便于快速的运输，测试，开发。

## docker引擎
> [官方传送门](https://docs.docker.com/engine/docker-overview/#the-docker-platform)

## docker架构（体系结构）
> 使用`client-server`架构，docker客户端告诉daemon(docker后台常驻进程)去做一个**构建，运行，分发**docker容器。
> docker客户端和daemon的交流通信使用`rest api`，基于一个`unix socket`或者`network interface`之上。

### 几个术语（glossary）
- `Docker registries`: docker镜像源，docker默认被配置为去`docker hub`上下载镜像。

- `images`: 镜像，一个镜像是带有一系列指令的只读的模板(包)，用来创建docker容器。当你创建自己的镜像的时候，你需要在`Dockerfile`中按照一定的简单的语法去定义一些步骤去创建镜像并运行它。
一个镜像包含了运行一个程序所需要的各种依赖（代码，运行时，库，环境变量，配置文件）。
`Dockerfile`中的每一条指令都会生成一个**层**。

- `containers`: 容器，一个容器是一个镜像的可运行的实例。可以通过`docker api`或则`CLI`对实例进行`CRUD`等操作。

- `services`: 服务，服务允许你跨多个daemon扫描容器，这些daemon相互协作称之为一个集群（swarm）。

## docker基本开发环境搭建
### 容器（containers）

- 使用`Dockerfile`定义容器

Dockerfile
```
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

app.py
```
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

- 构建docker镜像

```
$ docker build -t friendlyhello .
```

- 查看上一步构建的镜像

```
$ docker image ls
```

- 运行app

```
$ docker run -p 4000:80 friendlyhello
```

- 查看app.py的输出
在浏览器访问`http://localhost:4000`或者
在终端使用curl查看：
```
$ curl http://localhost:4000
```

- 查看运行中的容器

```
$ docker container ls
```

- 停止运行一个容器

```
$ docker container stop <IMAGE_ID>
```

### 服务（services）
> 一个服务只会运行一个镜像，但是它定义了镜像运行的法规：比如该使用什么端口，产生多少个容器的复制品。
> 关于服务的概念比较的抽象，可以查看[官方例子对于服务的解释](https://docs.docker.com/get-started/part3/#about-services)

task:
> 一个service中运行的一个容器叫做task。task被给予一个自增的id,增加到`replicas`的数量位置。
查看service中的tasks

>一个`docker-compose.yml`文件定义了docker容器在产品模式下应该具有的行为。

```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "80:80"
    networks:
      - webnet
networks:
  webnet:
```

运行我们的服务：

```
$ docker stack deploy -c docker-compose.yml getstartedlab
```
在使用上面的命令来启动一个服务的时候，必须先设置一个`swarm manager`（集群leader）, 不然会抛出一个错误提示。后面解释为什么要这样做：
```
$ docker swarm init
```

查看启动的服务：
```
$ docker service ls
# 通过该命令查看，可以看出该服务的名称为 getstartedlab_web
# getstartedlab是你在上一个命令中定义的app的名称
# web是你在docker-compose.yaml中定义的服务名称
```

列出一个服务中有多少个任务：
```
docker service ps getstartedlab_web
```

请求服务：
```
$ curl -4 http://localhost
# 或者在浏览器中打开并刷新几次，可以看到Hostname在改变
```

扫描app: 可以改变`docker-compose.yml`中的相关配置，然后重新运行发布命令
```
$ docker stack deploy -c docker-compose.yml getstartedlab
```

拆卸app和swarm

```
$ docker stack rm getstartedlab
$ docker swarm leave --force
```

### Stacks(栈)
> 栈是一组相互关联的服务，这些服务可以共享依赖关系,被组织和缩放。一个栈有着定义和协调整个应用的能力。

## Dockerfile常用指令（选项）
[官方传送门](https://docs.docker.com/engine/reference/builder/)
> `Dockerfile`中的指令大小写不敏感，但是按照约定都使用大写，以便于和指定的参数区分。
> `Dockerfile`中的指令按顺序一条一条的执行，并且`Dockerfile`文件必须以`FROM`开始

### 构建上下文context
> `docker build`命令基于`Dockerfile`文件和`context`构建镜像。
> `context`是一个`PATH`或则`URL`指定的文件集合。
> `PATH`是一个本地文件系统的一个目录，`URL`是一个git仓库。

### `.dockerignore`
> 为了增加构建的性能，可以将不需要的文件添加到`.dockerignore`

一般情况下，`Dockerfile`放置在`context`的根目录下，可以使用`-f`选项指定`Dockerfile`文件的位置：
```
$ docker build -f /path/to/a/Dockerfile .
```

可以为一个镜像指定多个仓库标签:
```
$ docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest .
```

### 解析器指令（parser directives）
> `Dockerfile`中的注释已`#`开头，但是解析器指令时一种特殊的注释，必须出现在`Dockerfile`中的开头部分。
> 语法：# directive=value

### FROM
> 初始化一个新的构建时期，为接下来的指令设置一个[基本镜像](https://docs.docker.com/glossary/)。
> 常用的3种形式：

```
FROM <image> [AS <name>]
FROM <image>[:<tag>] [AS <name>]
FROM <image>[@<digest>] [AS <name>]
```

### RUN
> 在当前镜像的顶部新的层里运行任何指令，并将结果提交到下一步中。
> 层运行指令并且生成提交信息符合`Docker`的核心概念：这个提交是非常便宜的，容器可以基于一个镜像的任何历史点创建。
> 2种使用形式：shell形式和exec形式

```
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
# exec形式必须使用双引号（""）
RUN ["/bin/bash", "-c", "echo hello"]
```

### CMD
> 一个`Dockerfile`中只能出现一个`CMD`,如果出现了多个，那么只有最后一个起作用。
> 3种使用形式：

```
# exec形式，最受欢迎的形式
CMD ["executable","param1","param2"]

# 作为默认值传递到 entrypoint
CMD ["param1","param2"]

# shell形式
CMD command param1 param2
```

### LABEL
> 为镜像添加一些元数据，可以使用`docker inspect`查看label的值。使用形式:

```
LABEL <key>=<value> <key>=<value> <key>=<value> ...
```

一些常用情况的例子
```
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
```

### ~~MAINTAINER~~
> 已过期，使用`LABEL`代替。

### EXPOSE
> 指定docker容器在运行的时候监听那个网络端口，可以指定使用TCP还是DUP。如果没有指定协议，默认使用TCP。使用形式：

```
EXPOSE <port> [<port>/<protocol>...]
```

### ENV
> 可以使用`docker inspect`查看它的值，
> 可以使用`docker run --env <key>=<value>`改变值。
> 环境变量持久化可能会带来一些副作用，所以可以通过`RUN <key>=<value> <command>`来设置单个指令变量。
> 使用形式：

```
# 设置单个值的形式，key后面的第一个空格后面的所有字符（包括空格，引号等）都被设置为<value>
ENV <key> <value>

# 可以设置多个值
ENV <key>=<value> ...
```

如：

```
ENV myName="John Doe" myDog=Rex\ The\ Dog \
    myCat=fluffy
```

等价于
```
ENV myname John Doe
ENV myDog Rex The Dog
ENV myCat fluffy
```

### ADD
> 该指令将`src`中的文件，文件夹或者远程文件拷贝到镜像所在的文件系统的`dest`目录。
> `src`中的路径被解析为相对于构建上下文`context`的路径，路径中可包含通配符。
> `dest`路径必须是一个绝对路径或者相对于`WORKDIR`的路径。
> 使用形式：

```
ADD [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

关于该指令的详细说明，请参看[官方文旦](https://docs.docker.com/engine/reference/builder/#add)

### COPY
> 该指令和`ADD`指令类似。区别是`ADD`支持`src`是一个`URL`，而`COPY`不支持。

### ENTRYPOINT
> 2种使用形式：shell形式和exec形式

```
ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
ENTRYPOINT command param1 param2 
```

### VOLUME
> 用指定的名称创建一个挂载点。使用形式：

```
VOLUME ["/var/log/"]
VOLUME /var/log /var/db
```

### USER
> 设置docker镜像跑在哪个用户或者用户ID下，也可以设置一个可选的组或者组ID下。
> 如果没有设置组，默认使用`root`组。
> 其他的指令`RUN, CMD, ENTRYPOINT`也遵守这一规则。

```
USER <user>[:<group>]
USER <UID>[:<GID>]
```

### WORKDIR
> 为`Dockerfile`中的`RUN, CMD, ENTRYPOINT, ADD, COPY`指令提供工作目录。
> `WORKDIR`可以在`Dockerfile`中出现多次，那么后面的路径时相对于前面的。

TODO: 类似于nodejs中的resolve方法？解析到一个绝对路径为止？

```
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
=> /a/b/c
```

> `WORKDIR`可以使用`Dockerfile`中已经定义的环境变量。

```
ENV DIRPATH /path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
=> /path/$DIRNAME
```

## `compose`文件结构

```yml
services:
    webapp:
        # 引用顶层的networks
        networks:
            - some-network
            - other-network
        depends_on:
          - db
          - redis
        build:
            # 包含Dockerfile的目录或者一个git仓库
            # 如果是一个相对路径，那么是相对于compose file文件的路径
            context: './dir'
            dockerfile: Dockerfile-alternate
            # 既可以是一个对象，也可以是一个数组
            # 该选项指定在Dockerfile ARG选项中定义的参数
            # 第一种使用形式
            args:
                - buildno=1
                - password=secret
            # 第二种使用形式
            args:
                buildno: 1
            # 一个镜像列表指定docker引擎使用的缓存
            cache_form:
                - alpine:latest
                - corp/web_app:3.14
            # 添加元数据到结果镜像中
            # 第一种使用形式
            labels:
                # 推荐使用reverse-DNS命名规则，避免和其他软件使用的标签冲突
                com.example.description: "Accounting webapp"
                com.example.department: "Finance"
                com.example.label-with-empty-value: ""
            # 第二种使用形式
            labels:
                - "com.example.description=Accounting webapp"
                - "com.example.department=Finance"
                - "com.example.label-with-empty-value"
            # 为构建的容器设置/dev/shm设置大小
            shm_size:
                shm_size: '2gb'
                # 第二种使用形式，单位为byte
                shm_size: 10000000
            # 构建在Dockerfile中指定的时期
            target: prod
        # 为服务指定部署和运行时的相关配置
        deploy:
            update_config:
                # 同一时间更新容器的数量
                parallelism: 2
                delay: 10s
                # 默认值stop-first，start-first
                order: stop-first
                # 当一个更新失败的时候后续的动作
                # 默认值pause, continue, rollback
                failure_action: continue
                # 配置在一个更新期间所能容忍的失败率
                max_failure_ratio: '0.20'
            # 重启策略
            restart_policy:
                # any(默认值), none, on-failure
                condition: on-failure
                # 重启时间间隔, 默认值0
                delay: 5s
                max_attempts: 3
                window: 120s
            # 只为这个服务设定标签
            labels:
                com.example.description: "This label will appear on the web service"
            # 默认值replicated
            mode: global
            # 如果mode被设置为replicated,那么可以通过replicas来指定容器复制数量
            replicas: 6
            placement:
                constraints:
                  - node.role == manager
                  - engine.labels.operatingsystem == ubuntu 14.04
                preferences:
                  - spread: node.labels.zone
            # 配置资源约束
            resources:
                limits:
                  cpus: '0.50'
                  memory: 50M
                reservations:
                  cpus: '0.25'
                  memory: 20M
# 增加或者移除容器的能力
cap_add:
    - ALL
cap_drop:
  - NET_ADMIN
  - SYS_ADMIN
# 重写默认的命令
command: bundle exec thin -p 3000
configs:
# 为容器指定一个父组
cgroup_parent: m-executor-abcd
# 为容器指定自定义名称，docker容器名称必须唯一
container_name: my-web-container
# 定义设备映射
devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
# 自定义dns服务
dns:
- 8.8.8.8
- 9.9.9.9
# 可以是单个值
dns: 8.8.8.8
# 自定义dns搜索域
dns_search: example.com
dns_search:
  - dc1.example.com
  - dc2.example.com
# 在容器内部临时挂载一个文件系统
tmpfs: /run
tmpfs:
- /run
- /tmp
# 重写默认的entrypoint
entrypoint:
    - php
    - -d
    - zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so
    - -d
    - memory_limit=-1
    - vendor/bin/phpunit
# 增加环境变量来自一个文件
env_file: .env
env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
networks
volumes
```


## 网络（network）
### 桥接网络（bridge networks）
> 一个桥接可以是一个硬件设备或者是运行在一个主机内核中的软件。

用户自定义桥接网路的好处：
1. 提供更好的隔离和互通性。
2. 在容器间提供自动化`DNS`解析。
3. 随时绑定或者解绑一个容器到自定义网络。
4. 每个用户自定义网络可以创建一个可配置的网络。

创建用户自定义的网络：
```
$ docker network create my-net
```

移除一个自定义网络：
```
$ docker network rm my-net
```
如果一个容器当前正在使用这个网络，那么必须选断开：
```
$ docker network disconnect my-net my-nginx
```

## 宗卷（Volumes）
> docker中挂载数据的3种方式：

- bind mount：利用机器的文件系统。
- volumes：在文件系统中开辟一块区域来持久化数据，专门由docker管理。
- tmpfs： 在内存中挂载数据，并不能持久化，当容器停止，数据丢失。

关于以上3种的数据挂载方式，具体的介绍查[看官方文档](https://docs.docker.com/storage/#choose-the-right-type-of-mount)

最推荐的方式是使用Volumes（实际还是视具体情况而定），此处只讲Volumes。

创建Volumes:

```
$ docker volume create my-vol
```

列出所有的Volumes:

```
$ docker volume ls
```

## 发布镜像
1. [创建docker仓库](https://cloud.docker.com/)

> 在`docker cloud`上只能免费创建一个私有仓库，无限制多个公有仓库。

2. 创建镜像

```
$ docker build -t username/tag .
```

3. 登录

```
docker login
```

4. 推送镜像

```
$ docker push
```


