---
title: nodejs-process
date: 2017-07-12 23:00:05
tags:
    - nodejs
categories:
    - nodejs
---

## Process Events(进程事件)
> `process`对象是`EventEmitter`的一个实例

### beforeExit
> 当Node清空事件队列并且没有额外的任务加入到事件队列中，触发该事件。通常情况下，当没有额外的任务加入到事件队列中时，Node进程会自动退出。
> 但是如果'beforeExit'事件绑定的监听器的回调函数中，含有一个可以进行异步调用的操作，那么Node.js进程会继续运行。

> process.exitCode 作为唯一的参数值传递给'beforeExit'事件监听器的回调函数。

> 如果进程由于显式的原因而将要终止，例如直接调用process.exit()或抛出未捕获的异常，'beforeExit'事件不会被触发。

>除非本意就是需要添加额外的工作(比如通过监听器进行异步调用)到事件循环数组，否则不应该用'beforeExit'事件替代'exit'事件。



### disconnect
> 如果一个进程是通过`IPC`信道的方式spawned出来的，那么当`IPC`信道关闭的时候触发该事件。


### exit
> 当Node进程是由于以下2中情况之一导致退出的时候，会触发该事件：

- 显示的调用`process.exit()`
- 事件循环队列中不再有额外的任务去做的时候

> 一旦到达Node进程即将退出这个点的时候，是没有办法去阻止进程退出的。当`exit`事件上所有的监听器都执行完毕的时候，进程就会自动退出。
> 该事件的监听器会接受唯一的一个参数, 该参数来自`process.exitCode`或者来自传入到`process.exit()`中的code

```
process.on('exit', code => {
    console.log(`About to exit with code: ${code}`)    
})
```

> 因为一旦到达Node进程即将退出这个点，是没有办法阻止进程退出的。所有该事件的监听器中所做的操作都应该是**同步**的操作，任何在事件循环中排队的工作都会被强制丢弃。例如在下例中，timeout操作永远不会被执行(因为不是同步操作)。

```
process.on('exit', code => {
    // 异步任务是不会被执行的
    setTimeout(() => {
        console.log('This will not run')    
    })
})
```

### message
> 当一个Node进程是通过`IPC`信道的方式spawned出来的，那么当父进程通过`childprocess.send()`方法发送信息到该子进程的时候，就会触发该事件。

```
process.on('message', (message, sendHandle) => {})
```

回调会接受2个参数：
- message：一个解析过的JSON对象或者一个原始值
- sendHandle： net.Socket或者net.Server或者undefined

### uncaughtException
> 当事件队列在循环的过程中，遇到一个未能捕获的JS异常的时候，沿着代码调用路径反向传递回event loop，就会触发该事件。
> 默认情况下，Node处理这样的异常是将追踪栈中的信息打印到标准的错误流中，然后退出。
> 如果给该事件添加了自己的监听器，那么会改写默认行为。

```
// 回调接受唯一的一个Error对象
process.on('uncaughtException', err => {
    fs.writeSync(1, `Caught Exception: ${err}\n`)    
})

setTimeout(() => {
    console.log('This will still run')
}, 500)

nonexistentFun()
console.log('This will not run')
```

Warning: 正确的使用`uncaughtException`事件
> 该事件一般仅用着处理异常的最后的手段，因为它处理异常的机制是非常粗糙的。
>  此事件不应该当作出了`错误就恢复让它继续`的等价机制。 未处理异常本身就意味着应用已经处于了未定义的状态。如果基于这种状态，尝试恢复应用正常进行，可能会造成未知或不可预测的问题。
> <br>
> 此事件的监听器回调函数中抛出的异常，不会被捕获。为了避免出现无限循环的情况，进程会以非`0`的状态码结束，并打印堆栈信息。
> <br>
> 正确的使用`uncaughtException`应该是在进程关闭之前做一些相关的资源清理工作（比如文件描述符，句柄等），而不应该是出现了`uncaughtException`异常之后做一些让应用恢复工作的事情，因为这样是不安全的。
> 
> 想让一个已经崩溃的应用正常运行，更可靠的方式应该是启动另外一个进程来监测/探测应用是否出错， 无论uncaughtException事件是否被触发，如果监测到应用出错，则恢复或重启应用。

## Signal Events（信号事件）
> 当Node进程接受到信号时，就会触发相应的信号事件。
> 每个事件名称，以信号名称的大写表示 (比如事件'SIGINT' 对应信号 SIGINT).

```
process.stdin.resume()

process.on('SIGINT', () => {
    console.log('Received SIGINT.  Press Control-D to exit.')
})
```

> 在大多数的终端上发出`SIGINT`信号最简单的方式就是按下`Ctrl+C`键。
所以上面的例子中，当你按下`Ctrl+C`后，就会触发`SIGINT`事件，输出'Received SIGINT.  Press Control-D to exit.'，当你在按下`Ctrl+D`时，进程退出。

以下有很重要的几点需要牢记：
- `SIGUSR1`是Node用来启动debugger程序的。可以为此事件绑定一个监听器，但是即使这样做也不会阻止调试器的启动。
<br>
- `SIGTERM`和`SIGINT`在非windows平台上，有默认的监听器，这样进程在携带`128 + signal number`退出码退出之前，可以重置终端模式。如果给他们添加了自己的监听器，那么默认行为就会被移除。（Node进程不会退出）
<br>
- `SIGPIPE`默认是被忽略的，但是你也可以给它添加监听程序。
<br>
- `SIGHUP`,在windows平台上，当console窗口被关闭时，触发该事件。在其他平台上有着不同的行为，可以参看[这里](http://man7.org/linux/man-pages/man7/signal.7.html)。可以对该信号添加监听器，及时添加了监听器，在windows平台上，大约10秒之后Node会无条件的终止。在非windows平台上个，`SIGHUP`信号默认行为是终止Node,如果添加了自己的监听器，那么默认行为就会被移除。
<br>
- `SIGTERM`,windows平台不支持，可以给其添加监听器。
<br>
- `SIGINT`,所有的平台都支持。一般情况下按下`Ctrl+C`（当然你可以配置成其他快捷方式是）就会发出该信号。但是如果终端的raw模式被激活，那么就不会发出该信号。
<br>
- `SIGBREAK`,在windows平台上按下`Ctrl+Break`就会传递该信号。在非windows平台上，可以对其添加监听器，但是没有方式触发或发送此事件。
<br>
- `SIGWINCH`,当console窗口大小发生改变的时候，就会触发该信号。在windows平台上，仅仅发生在当在console有写入并且光标发生移动的时候才会触发该信号，或者一个可读tty被用在raw模式。
<br>
- `SIGKILL`，无法对其添加监听器，在所有的平台上，他都会无条件终止Node。
<br>
- `SIGTOP`，无法对其添加监听器。<br>

Note:
windows平台不支持发射信号，但是Node通过`process.kill()`,`ChildProcess.kill()`提供了某些模拟机制。
- 发射信号`0`可以用来测试一个进程的存在与否。
- 发射`SIGINT`,`SIGTERM`,`SIGKILL`可以无条件的终止目标进程。

## process.abort()
> 该方法可以迅速的终止Node进程，并且产生一个core file

## prcess.arch(architecture)
return: &lt;string&gt;
> 该属性返回当前正在运行的Node进程的处理器结构标识，如`arm`,`ia32`,`x64`

## process.argv
return: &lt;Array&gt;
> 返回当Node进程启动的时候在命令行传入的参数的数组。
> 数组的第一个元素就是`process.execPath`的值。
> 数组的第二个元素是被执行的文件的绝对路径。
> 余下的参数就是传入命令的其他的参数。

process-args.js
```
process.argv.forEach((val, index) => {
    console.log(`${index}: ${val}`)    
})
```

这样启动：
```
$ node process-args.js one two=three four
```

输出结果如下：
```
0: /usr/local/bin/node
1: /Users/qsch/workspace/tools/process-args.js
2: one
3: two=three
4: four
```

## process.execPath
> 返回启动Node进程的可执行程序的绝对路径, `'/usr/local/bin/node'`


## process.argv0
return: &lt;string&gt;

## process.channel
> 如果一个进程是通过`IPC`spawned出来的，那么`process.channel`属性返回IPC信道的引用。如果没有IPC信道存在，那么返回undefined。

## process.chdir(directory)
directory: &lt;string&gt;
> `process.chdir()`方法改变当前Node进程所在的工作目录。
> 如果操作失败（如指定的`directory`不存在），那么抛出一个异常。

```
console.log(`Starting directory: ${process.cwd()}`);
try {
  process.chdir('/tmp');
  console.log(`New directory: ${process.cwd()}`);
} catch (err) {
  console.error(`chdir: ${err}`);
}
```

## process.connected
return: &lt;boolean&gt;
> 如果一个Node进程是通过IPC信道spawned出来的，那么只要主进程和spawned出来的进程的IPC信道是链接的，那么返回true。如果调用`process.disconnect()`那么该属性就返回false.
> 一旦`process.connected`返回false，那么就不能再通过`process.send()`基于IPC信道发送消息。

## process.cpuUsage([previousValue])
previousValue: 上一次调用此方法`process.cpuUsage()`的返回值
return: &lt;Object&gt;
- user: &lt;integer&gt;
- system: &lt;integer&gt;
> `process.cpuUsage()`方法返回包含当前进程的用户CPU时间和系统CPU时间的对象。此对象包含user和system属性，属性值的单位都是微秒(百万分之一秒)。 user和system属性值分别计算了执行用户程序和系统程序的时间，如果此进程在执行任务时是基于多核CPU，值可能比实际花费的时间要大。

上一次调用process.cpuUsage()方法的结果，可以作为参数值传递给此方法，得到的结果是与上一次的差值。

```
const startUsage = process.cpuUsage();
// { user: 38579, system: 6986 }

// spin the CPU for 500 milliseconds
const now = Date.now();
while (Date.now() - now < 500);

console.log(process.cpuUsage(startUsage));
// { user: 514883, system: 11226 }
```

## process.cwd()
> 返回当前Node进程所在的工作目录。

## prcess.disconnect()
> 如果一个Node进程是通过IPC信道spawned出来的，那么该方法会关闭该进程和父进程之间的IPC信道。当没有更多的链接时，当前子进程就会优雅的退出。
> 调用当前进程的`process.disconnect()`方法和调用父进程的`ChildProcess.disconnect()`起到的想过是一样的。
<br>
> 如果某个进程不是通过IPC信道spawned出来的，那么`process.disconnect`属性是undefined。

## process.env
return: &lt;Object&gt;
> 返回一个包含当前用户环境的对象

这个对象的形式看起来可能如下：
```
{
  TERM: 'xterm-256color',
  SHELL: '/usr/local/bin/bash',
  USER: 'maciej',
  PATH: '~/.bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
  PWD: '/Users/maciej',
  EDITOR: 'vim',
  SHLVL: '1',
  HOME: '/Users/maciej',
  LOGNAME: 'maciej',
  _: '/usr/local/bin/node'
}
```

Note:
分配到`process.env`上的任何属性都会隐式的转化为字符串。

```
process.env.test = null
console.log(process.env.test) // 'null'

process.env.test = undefined
console.log(typeof process.env.test) // 'string'
```

可以通过`delete`操作符来删除`process.env`上的属性：
```
process.env.TEST = 1
delete process.env.TEST
console.log(process.env.TEST) // undefined
```

在windows平台上，环境变量大小写不敏感：
```
process.env.TEST = 1
console.log(process.env.test) // '1'
```

## process.execArgv
return: &lt;Object&gt;
> 返回当Node进程启动的时候传入到命令行中的Node.js特定的命令行选项。这些特定选项不会出现在`process.argv`属性返回的数组中。`process.execArgv`返回的数组不包括Node可执行程序，执行当前脚本的名称和跟随在脚本名称后面的选项。
> 这些选项非常的有用，当spawned一个进程的时候，可以通过它保证spawned出来的子进程和父进程保持一致的环境。

```
$ node --harmony script.js --version
```

那么process.execArgv返回：
```
['--harmony']
```

而process.argv返回：
```
['/usr/local/bin/node', 'script.js', '--version']
```

## process.exit([code])
code: &lt;integer&gt; ,退出码，默认为0
> 该方法告诉Node同步的终止进程并且携带一个退出码。如果没有传入code参数，那么默认使用代表成功的code`0`，或者使用`process.exitCode`(如果你曾经设置过)。当`exit`上的监听器全部执行完毕后，Node终止。

Note: 调用`process.exit()`强制进程尽可能快的退出，即使有一些异步的工作还没有完全执行完毕，包括`process.stdout`, `process.stderr`的I/O操作。
<br>

在大多数的时候，，没有必要显示的调用`process.exit()`。Node进程会自动退出，当事件循环中没有更多的工作加入。可以通过设置`process.exitCode`来告诉进程当优雅的退出时使用什么样的状态码。
<br>

如下面的`process.exit()`错误用法演示了可能导致输出到标准输出的数据被切断和丢失：
```
if (someConditionNotMet()) {
  printUsageToStdout();
  process.exit(1);
}
```

上面的用法有问题的原因就是：写入数据到`process.stdout`中的操作有可能是异步的操作，调用`process.exit()`会强制进程在这些异步完成之前就退出了。
<br>

不应该直接调用`process.exit()`方法，正确的做法应该是设置`process.exitCode`,这样就可以进程自然的退出，避免在安排一些额外的工作进入到事件循环中。

正确的做法：
```
if (someConditionNotMet()) {
  printUsageToStdout();
  process.exitCode = 1
}
```

如果因为发生了错误，抛出一个未捕获的错误，需要退出进程，通过设置`process.exitCode`要比直接调用`process.exit()`安全的多。

## process.exitCode
return: &lt;integer&gt;
> 进程退出的时携带的状态码。
> 调用`process.exit()`时指定了退出码，那么该退出码会覆盖之前通过`process.exitCode`设置的值。那么此时通过`process.exitCode`获取到的值就是`process.exit(code)`中指定的code。

## process.kill(pid[,signal])
pid: &lt;number&gt;,进程ID
signal: &lt;string&gt;|&lt;number&gt;,发射的信号，既可以是字符串，也可以是数字值，默认值是`SIGTERM`。
> 该方法发送一个为`signal`的信号到`pid`的进程。

如果`pid`不存在，那么该方法抛出一个错误。作为一种特殊情况，信号`0`可以被用来测试进程的存在性与否。在windows平台，如果`pid`被用来杀死一个进程组，那么会抛出一个错误。

Note: 尽管该方法的名字叫`kill`,但事实上它仅仅是一个信号发射器。发射信号的目的是去做一些事情，而不是杀死目标进程。

```
process.on('SIGHUP', () => {
    console.log('Got SIGHUP signal')    
})

setTimeout(() => {
    console.log('Exiting')    
    process.exit(0)
}, 100)

process.kill(process.pid, 'SIGHUP')
```

Note: 当Node进程接收到一个`SIGUSR1`信号时，Node就会启动调试程序。

## process.memoryUsage()
return: &lt;Object&gt;
- rss: &lt;integer&gt;
- heapTotal: &lt;integer&gt;
- heapUsed: &lt;integer&gt;
- external: &lt;integer&gt;
> 方法返回一个对象，描述了Node使用内存的情况。

如：
```
console.log(process.memoryUsage())
```

输出如下：
```
{
  rss: 4935680,
  heapTotal: 1826816,
  heapUsed: 650472,
  external: 49879
}
```

`heapTotal`,`heapUsed`指向V8的内存的使用情况。
`external`指向被V8管理的绑定到JS对象上的C++对象的内存使用情况。

## process.nextTick(callback[,...args])
callback: &lt;Function&gt;
..args: 当调用callback时传入的额外参数。
> 该方法将`callback`添加到当前`microtask`循环的下一个轮次，一旦本轮的`microtask`循环结束，立马执行下一轮`microtask`中所有`callback`。
> `process.nextTick`不是`setTimeout(fn, 0)`的别名，它更加的高效，他在一下轮`macrotask`之前执行。

关于`microtask`和`macrotask`，请参看[这里](https://xxxxxmiss.github.io/2017/07/14/event-loop/)

```
console.log('start')

setTimeout(() => {
    console.log('setTimeout')    
}, 0)

process.nextTick(() => {
    console.log('nextTick callback')    
})

console.log('scheduled')

// start
// scheduled
// nextTick callback
// setTimeout
```

当你在开发API时，你想给用户一个机会去添加事件处理器在对象被构造以后，在任何的I/O发生以前，这个方法就显得尤为重要。如下：

```
function MyThing(options){
    this.setupOptions(options)

    process.nextTick(() =>f {
        this.startDoingStuff()    
    })
}

const thing = new MyThing()
thing.getReadyForStuff()

// thing.startDoingStuff() gets called now, not before.
// thing.startDoingStuff()在thing.getReadyForStuff()之后才执行。
```

当不确定一个方法时100%同步还是100%异步的时候，`process.nextTick`可以起到很重要的流程控制。
如：
```
// WARNING!  DO NOT USE!  BAD UNSAFE HAZARD!
function maybeSync(arg, cb) {
  if (arg) {
    cb();
    return;
  }

  fs.stat('file', cb);
}
```

上面的`maybeSync`是一个非常不靠谱的API，因为可能出现如下情况：

```
const maybeTrue = Math.random() > 0.5;

maybeSync(maybeTrue, () => {
  foo();
});

bar();
```

此次你并不清楚`foo()`,`bar()`那个先执行，如果`maybeTrue`为`true`,那么`foo()`先执行，否则`bar()`先执行。

如果改写为如下写法，那么就可以明确知道谁先执行了：

```
function definitelyAsync(arg, cb) {
  if (arg) {
    process.nextTick(cb);
    return;
  }

  fs.stat('file', cb);
}
```
此时，一定是`bar()`先执行，因为`process.nextTick`会将`cb`放到当前`microtask`的下一个轮次。

## process.pid
return: &lt;integer&gt;
> 返回当前进程的pid

## process.platform
return: &lt;string&gt;
> 返回当前Node进程运行在那个操作系统的平台上。
> 如： `'darwin'`, `'freebsd'`, `'linux'`, `'sunos'` or `'win32'`

## prcess.send(message[, sendHandle[, options]][,callback])
message: &lt;Object&gt;
sendHandle: &lt;Handle object&gt;
options: &lt;Object&gt;
callback: &lt;Function&gt;
return: &lt;boolean&gt;
> 如果一个进程是通过IPC信道spawned出来的，那么该进程可以通过`prcess.send()`方法发送信息到父进程。父进程可以通过`ChildProcess`来监听`message`事从而接收来自子进程的消息。
> 如果某个进程不是通过IPC信道spawned出来的，那么`process.send`属性为undefined。

Note: 该方法内部使用`JSON.stringify()`来序列化`message`。

## process.stderr
return: &lg;Stream&gt;
> 该方法返回一个连接到标准错误`stderr`(文件描述符为2)的流对象。
> 该流是一个`net.Socket`（这是一个双工流），当文件描述符`2`指向一个文件时，此时他是一个可写流。

## process.stdin
return: &lg;Stream&gt;
> 该方法返回一个连接到标注输入`stdin`(文件描述符为0)的流对象。
> 该流是一个`net.Socket`（这是一个双工流），当文件描述符`0`指向一个文件时，此时他是一个可读流。

```
process.stdin.setEncoding('utf8')

process.stdin.on('readable', () => {
    const chunk = process.stdin.read()    

    if(chunk !== null){
        process.stdout.write(`data: ${chunk}`)
    }
})

process.stdin.on('end', () => {
    process.stdout.write('end')
})
```

## process.stdout
return: &lt;Stream&gt;
> 该方法返回一个连接到标注输出`stdout`(文件描述符为1)的流对象。
> 该流是一个`net.Socket`（这是一个双工流），当文件描述符`1`指向一个文件时，此时他是一个可写流。

如：拷贝process.stdin到process.stdout
```
process.stdin.pipe(process.stdout)
```

### 关于process I/O需要注意以下几点：
> `process.stdout`和`process.stderr`区别于Node中其他的流有以下几点：

1, 他们分别被用于`console.log()`和`console.error()`内部
2, 他们不能被关闭
3, 他们不会触发`finish`事件
4, 写入有可能是同步的，取决于他们连接到哪里以及在哪个平台上：
- Files: 在windows和Linux平台上都是同步的
- TTYs(Terminals): 在windows上异步，在Unix上同步
- Pipes以及sockets: 在windows上同步，在Unix上异步

之所以有这些因为，都是因为一些历史原因，但是又不能轻易的改变他们。
<br>

同步的写入可以避免一些问题，比如`console.log()`,`console.error()`, 我们知道当使用`process.exit()`会立马终止进程，如果是异步写入，那么就可能导致还没写完进程就终止了，导致数据写入不全。

Warning: ....

## process.uptime()
return: &lt;number&gt;
> 返回当前Node进程运行的秒数。
> 需要注意的是，这个秒数包括小数部分。

## process.version
return: &lt;string&gt;
> 返回当前Node的版本

```
process.version
// v7.5.0
```

## Exit Codes(退出码)
[具体参看这里](https://nodejs.org/dist/latest-v8.x/docs/api/process.html#process_exit_codes)