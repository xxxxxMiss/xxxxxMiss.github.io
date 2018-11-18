---
title: RegExp
date: 2017-06-05 11:35:04
tags: js
categories: js
---

## Character Classes or Character Sets (字符类, 字符集合)
> 在正则表达式中，字符类就是用一对方括号`[]`包裹你要匹配的字符。需要注意以下几点：

- 一个字符类仅仅匹配一个单字符。如`/gr[ae]/y`, 只会匹配`gray`, `grey`, 不会匹配`graey`。
<br>
- 在字符类中，可以使用连接符`-`来表示一个范围。当然了，你可以使用多个连字符来表示多个范围。如`/[0-9a-fA-F]/`,并且字符的顺序是无关紧要的。也就是说，你可以用`/[0-9a-fA-F]/`, `/[a-f0-9A-F]/`等都可以用来表示一个16进制的单字符。
<br>
- 在字符类中除了 `\`, `^`, `-`外，所有的元字符都是普通的字符，不需要转义。当然了，你非要对这些元字符转义，也是没问题的，只是减少了可读性。就是说，原本一些有特殊意义的字符，用方括号包裹之后，就失去了它原本特殊的含义而变成了一个普通的字符。
<br>
- 还有一个比较特别的就是闭合方括号`]`。如`[]x]`, `[^]x]`等这些含有未转义的`]`正则，在不同的语言中可能会有不同的情况。以上列举的这2种情况，在javascript中是不能正常工作的。例如在ruby中，空的字符类`[]`被视为一个错误。 还有就是方括号中嵌套方括号，这时也需要注意的,如`/[-.*+?^${}()|[\]\/\\]/g`。
<br>
- 所以综上所述，对于字符类中的`]`, `\`, `^`, `-`，如果要把他们当做普通字符使用，最好都转义。

```javascript
/[.*?+]/.test('.') // true

/[.*?+]/.test('a') // false
```

## Negated Character Classes （否定的字符类）
> 表示的意思就是匹配任何不包含在这个字符类中的字符。需要注意以下几点：

- 我们知道，`/./`表示的是除换行符以外的任何字符（当然这里有范围的限制，此处暂不讨论），否定字符类恰好能匹配换行符，所以`/[^]/`表示的就是匹配任何字符（包括换行符）。所以如果你不想否定字符类匹配换行符，你需要在否定字符类中显示的包含换行符，如`/[^0-9\r\n]/`,匹配任何不是数字或者换行符的字符。

举例验证
```javascript
// \u000A 为换行符所对应的unicode

/./.test('\u000A')  // fasle
/[^]/.test('\u000A') // true
```

## Repeating Character Classes（重复字符类）
> 当你在字符类上使用`*`, `?`, `+`进行重复时，需要知道的是，你重复的是这些字符类，而不是重复字符类匹配的字符。

```javascript
/[0-9]+/ // match 837 as well as 222
```

> 如果你想重复字符类匹配的字符，可以使用**反向引用**

```javascript
/([0-9])\1+/ // match 222 but not 837
```

## Shorthand Character Classes(字符类简写)
> 因为一些特定的字符类经常被使用，所以就制定了一些特定的字符代表字符类。在不同的语言中，这些特定的字符所代表的字符不一定是完全一样的。

- \w: [0-9a-zA-Z_]
- \s: [ \t\r\n\f],在某些语言中还包括垂直制表符`\v`
- \d: [0-9]

## Dot or Period(点)
> 元字符`.`匹配除了换行符以外的任意一个单字符。
> 至于为什么不包含换行符是由于历史原因造成的：第一代工具使用正则表达式是基于行的。他们一行一行的读取文件，使用正则表达式分割行。由于这些工具的影响，导致了`.`元字符不包括换行符。

NOTE: 虽然元字符`.`不包括换行符，但是在不同的语言中，实现并不相同，有些语言是可以通过一些选项来控制是否包含换行符的。但是在javascript和vbscript中，是没有任何选项来控制的。

```
// 在js中，可以使用[\s\S]来匹配任何字符
/[\s\S]/  // match any character, include line breaks
```

## Line Breaks Character(换行符)
> 换行符在不同的操作系统以及不同的语言中实现也有所不同，尽管如此，但是我们依然可以认为`\n`就是我们所说的换行符。因为在我们熟悉的脚本语言中，都只会将`\n`作为换行符，而不会将其他字符作为换行符。
> 尽管window系统中的换行符是`\r\n`,但是我们说换行符就是`\n`依然没有问题。这是因为这些脚本语言默认是处于**文本模式**下读写文件的。
> 当脚本运行在window系统中，在读取文件时，`\r\n`自动转换为`\n`;写文件时，`\n`自动转换为`\r\n`。

## Word Boundaries（单词边界）
> 元字符`\b`和`^`,`$`都属于锚点字符，用来匹配叫做**单词边界**的位置。他匹配的长度为0。
> 有3种不同的位置可以作为单词的边界：

- 字符串中的第一个字符的前面（第一个字符必须是单词）
- 字符串中的最后一个字符的后面（最后一个字符必须是单词）
- 字符串中两个字符之间的位置，这个两个字符必须一个是单词，一个非单词

## Alternation（选择）
> 正则表达式中使用管道符（pipe character）`|`来对匹配模式进行选择匹配。
> 需要注意的是**选择操作**在正则表达式中的**优先级是最低**的。

如：假设我们要匹配的是一个单词及其左右边界，正则如下
```javascript
/\bcat|dog\b/  // 能匹配catxx或者xxdog等
```
解释：按照上面的写法只会匹配cat及其左边界或者dog及其右边界，如果要匹配cat或则dog及其左右边界，必须使用分组来改变其优先级。如下
```javascript
/\b(cat|dog)\b/
```

关于正则表达式中的“选择”，下面我们来通过例子详细的说明他们是如何工作的。
```javascript
var animalCount = /\b\d+ (pig|cow|chicken)s?\b/
console.log(animalCount.test("15 pigs"))
// → true
console.log(animalCount.test("15 pigchickens"))
// → false
```

{% asset_img  re_pigchickens.svg "/\b\d+ (pig|cow|chicken)s?\b/" %}

假设我们的正则表达式已经实例化成上面的图表，图表中的每个正则`token`看成一个盒子。要匹配的字符串为`the 3 pigs`。那么匹配的流程会像下面的步骤进行：
- 在第4个位置（从0开始），有一个单词边界，因此通过了第一个盒子。
<br>
- 此次仍然在第4个位置（因为单词边界是不占据长度的），找到了一个数字，因此通过了第二个盒子。
<br>
- 在进入第5个位置时，有2个条路径，一条回到第二个盒子形成一个环路，一条直接进入第5个位置。我们要匹配的字符串的第5个位置是一个空白字符，因此直接进入第5个位置。
<br>
- 在进入第6个位置时(`pigs`的第一个字符)，有三条路径。但我们要匹配的字符串中并没有`cow`或者`chicken`, 有的是`pig`，因此进入`pig`这条路径。
<br>
- 在进入第9个位置时，又出现了2条路径，一条跳过了`s`这个盒子直接进入最终的单词边界的盒子，一条进入`s`这个盒子。要匹配的字符中含有字符`s`，因此进入到`s`这个盒子。
<br>
- 在第10个位置（末尾单词边界的位置），要匹配的字符串已经到达末尾（字符串的末尾算着一个单词边界）。因此通过了最后单词边界这个盒子，完成了整个的匹配。
<br>
---
综上所述, 在一个字符串中搜寻匹配的字符时，正则表达式引擎会进行如下的查找了流程：
从一个字符串的起始位置，一个一个字符进行匹配，直到找到了一个匹配或者达到字符串的末尾才能决定最终的匹配情况。

在举个例子：
> 假设你要匹配一个函数名`SetValue`，你写的正则如下：

``` js
/Get|GetValue|Set|SetValue/.exec('SetValue')
// -> Set
```

在控制台运行下，就会发现我们匹配到的是`Set`, 而不是`SetValue`。解释如下：

> 因为正则表达式引擎一旦匹配到满足的字符，会立即停止匹配。而按照上面的写法，`Set`是匹配`SetValue`的。解决方法可以有如下几种：

- 改变*Alterlation*的顺序：

``` js
/GetValue|Get|SetValue|Set/.exec('SetValue')
```

- 利用`?`,`+`,`*`,`{m,n}`等贪婪匹配的特性：

``` js
/Get(Value)?|Set(Value)?/.exec('SetValue')
```

- 将上面的表达式进一步优化

``` js
/(Get|Set)(Value)?/.exec('SetValue')
```

### Backtracking(回溯)
> 在正则表达式中，有一种叫做**回溯查找**，就是沿着某一条路径匹配多次。回溯通常出现在数量匹配中，如`*`, `+`, `{m, n}`。
下面以具体的图表和例子来说明匹配情况。

```javascript
/\b([01]+b|\d+|[\da-f]+h)\b/.test('103')
```

{% asset_img re_number.svg "/\b([01]+b|\d+|[\da-f]+h)\b/" %}


- 上面的例子中，匹配器会一直在最上面的那条路径进行匹配，只有达到字符`3`，才知道进错了路径。
- 此时匹配器进行回溯。其实在选择匹配的时候，匹配器首先会记录当前的位置（也就是每条路径中第一个字符的位置）以便于当进入到错误的路径时可以快速返回到这个位置。
- 此时进入到第二条路径（从上往下），发现可以完整匹配，匹配结束。

NOTE: 一旦找到一个完整匹配，匹配器会立马停止匹配。这就意味着如果多个分支可以匹配这个正则，那么返回的匹配是第一个（每个分支按在正则表达式中出现的先后顺序来排序）
举例如下：
```javascript
/^(h|hello)(.*)$/.exec("hello") // ['hello', 'h', 'ello']
```


下面来看一个正则表达式中类似于多次循环的例子：
```javascript
/([01]+)+b/
```
{% asset_img re_slow.svg "/([01]+)+b/" %}

关于上面的例子中的正则表达式有什么问题，此处先不做说明。

## Greedy and non-greedy(贪婪匹配和非贪婪匹配)
> 正则引擎默认是贪婪匹配的，就是尽可能多的匹配。除非尽可能多的导致整个匹配失败，那么才会回溯到重复的位置重新开始匹配。贪婪匹配一般出现在量词中，如下：

- `?` <=> `{0,1}`
- `*` <=> `{0,}`
- `+` <=> `{1,}`
- `{m, n}`

下面以一个具体的例子来说明贪婪匹配，
假设我们要匹配一个字符串中不带任何属性的html标签，你的正则可能会像下面这样：
```
/<.+>/.exec('This is a <EM>first</EM> test')
// prints: ['<EM>first</EM>']
```
你会看到匹配的结果和我们所期盼的`<EM>`,`</EM>`并不一样。究其原因就是因为量词`+`是贪婪的，它会让正则引擎尽可能多的匹配。其实这个匹配过程可以用上面的图表来解释更加的清楚：
匹配完第一个`.`所代表的字符后，进入到下一个字符会有2条路径：一条是`.`形成的环路，一条直接进入`>`, 但是`+`是贪婪的，那么正则引擎会一直进入这条环路，直接匹配失败了才会退出这条路径。
<br>
下面是更加详细的关于正则引擎是如何匹配`<EM>first</EM>`的：
> The first token in the regex is `<`. As we already know, the first place where it will match is the first `<` in the string. The next token is dot, which matches any character except newlines. The dot is repeated by the plus. The plus is greedy. Therefore, the engine will repeat the dot as many times as it can. The dot matches `E`, so the regex continues to try to match the dot with the next character. `M` is matched, and the dot is repeated once more. The next character is `>`. You should see the problem by now. The dot matches the `>`, and the engine continues repeating the dot. The dot will match all characters in the string. The dot fails when the engine has reached the void after the end of the string. Only at this point does the regex engine continue with next token `>`.
> <br>
> So far, `<.+` has matched `<EM>first</EM> test` and the regex engine has arrived at the end of the string. `>` cannot match here. The engine remembers that the plus has repeated the dot more often than is required. (Remember that the plus requires the dot to match only once.) Rather than admitting failure, the engine will backtrack. It will reduce the repetition of the plus by one, and then continue trying the remainder of the regex.
> <br>
> So the match of `.+` is reduced to `EM>first</EM>` tes. The next token in the regex is still `>`. But now the next character in the string is the last `t`. Again, these cannot match, causing the engine to backtrack further. The total match so far is reduced to `<EM>first</EM> te`. But `>` still cannot match. So the engine continues backtracking until the match of `.+` is reduced to `EM>first</EM. Now`, `>` can match the next character in the string. The last token in the regex has been matched. The engine reports that `<EM>first</EM>` has been successfully matched.

```
/^(.+) ((?:BBB )?CCC)$/.exec('AAA BBB CCC')
```


## 正则相关方法
> 操作字符串的一些常用方法，如replace, split, match, search等，这些方法的第一个参数都可以是一个正则表达式对象，也可以是一个子字符串，此处主要讲解第一个参数是正则表达式的情况。
> RegExp的一些实例方法，如test, exec等

### str.replace(regexp|substr, newSubstr|function)

先来看一个例子：假设我们要匹配动态的匹配一个人的姓名，在匹配到姓名前后插入下划线，但是这个人的姓名很特殊（含有一些特殊的符号）。所以我们可以按照下面的做法来处理：
```javascript
var name = 'dea+hl[]rd'
var text = 'This dea+hl[]rd guy is super annoying.'
// 匹配除了单词和空白以外的任何字符
// 不能对任何字符进行转义，以为\n,\b这些字符也是有特殊意义的
var escaped = name.replace(/[^\w\s]/g, "\\$&")
var regexp = new RegExp("\\b(" + escaped + ")\\b", "gi");
console.log(text.replace(regexp, "_$1_"));
// → This _dea+hl[]rd_ guy is super annoying.
```

第二个参数`newSubstr`可以使用下面的这些特殊的变量名。

| 变量名 | 代表的值 |
| --- | --- |
| $$ | 插入一个$ |
| $& | 插入匹配的子串 |
| $` | 插入当前匹配的子串的左边的内容 |
| $' | 插入当前匹配的子串的右边的内容 |
| $n | 假如repalce方法的第一个参数是一个RegExp对象，并且n是小于100的从1开始的整数，那么插入第n个捕获性分组 |

例子：
```javascript
"dea+hl[]rd".replace(/[^\w\s]/g, "\\$`")
// prints: "dea\deahl\dea+hl\dea+hl[rd"
```

第二个参数可以是一个函数，在这种情况下，当匹配执行后， 该函数就会执行。 函数的返回值作为替换字符串。 (注意:  上面提到的特殊替换参数在这里不能被使用。) 另外要注意的是， 如果第一个参数是正则表达式， 并且其为全局匹配模式， 那么这个方法将被多次调用， 每次匹配都会被调用。

| 变量名 | 代表的值 |
| --- | --- |
| match | 匹配的子串。（对应于上述的$&。） |
| p1, p2, ... | 假如replace()方法的第一个参数是一个RegExp 对象，则代表第n个括号匹配的字符串。（对应于上述的$1，$2等。） |
| offset | 匹配到的子字符串在原字符串中的偏移量。（比如，如果原字符串是“abcd”，匹配到的子字符串时“bc”，那么这个参数将是1） |
| string | 被匹配的原字符串 |

NOTE: 精确的参数个数依赖于replace()的第一个参数是否是一个正则表达式对象， 以及这个正则表达式中指定了多少个括号子串。

```javascript
function replacer(match, p1, p2, p3, offset, string) {
  // p1 is nondigits, p2 digits, and p3 non-alphanumerics
  return [p1, p2, p3].join(' - ')
}
var newString = 'abc12345#$*%'.replace(/([^\d]*)(\d*)([^\w]*)/, replacer)
// prints: 'abc - 12345 - #$*%'
```

该方法的详细用法可以[参考这里](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String/replace)

### str.search(regexp)
> 我们知道，字符串有个`indexOf`方法，但是它不能使用正则表达式作为参数，而search方法就需要一个正则表达式作为参数。和indexOf方法一样，它返回第一个匹配字符串的索引；没有找到任何匹配，返回-1。

NOTE: indexOf方法可以传入第二个参数作为搜索的起始偏移量，而search却不能。

```javascript
console.log("  word".search(/\S/));
// → 2
console.log("    ".search(/\S/));
// → -1
```

### str.split([separator, [limit]])
> 分割一个字符串，返回分割后的字符串组成的数组。

- 如果忽略了separator或者在str中没有找到separator, 那么返回的是整个字符串组成的一个元素的数组。
- 如果separator是长度为0的字符串，那么返回的是str中每个字符组成的数组。
- 只有在str长度为0, separator长度也为0的时候，才会返回一个空数组。
- 支持第二个参数limit, 代表切割后返回的数组的长度。如`limit=3`，表示需要切割3次（形成4个子串），返回前3个元素组成的数组。

当separator是一个正则时，需要注意：

```js
'abc2d3f'.split(/\d/) // ["abc", "d", "f"]

'abc2d3f'.split(/(\d)/) // ["abc", "2", "d", "3", "f"]
```

> 由上面的例子可以看出，当split方法第一个参数为正则时，如果这个正则包含捕获性分组时，这个分组匹配的子串是不会被移除的，而是会被包含到返回的数组中。

### str.match(regexp)
> 一个正则表达式对象。如果传入一个非正则表达式对象，则会隐式地使用 new RegExp(obj) 将其转换为一个 RegExp 。如果你未提供任何参数，直接使用 match() ，那么你会得到一个包含空字符串的 Array ：[""]

NOTE: 
如果使用的正则不包含全局修饰符`g`, 那么返回的数组会有额外的2个属性, 并且包好捕获性分组：
- input: 包含被解析的原始字符串
- index: 该属性表示匹配结果在原字符串中的索引（以0开始）

```javascript
'bac12d3'.match(/[a-z]+(\d)*/)
// prints: ["bac12", "2", index: 0, input: "bac12d3"]
```

此时它和正则对象的`exec`方法返回值是一样的:
```javascript
/[a-z]+(\d)*/.exec('bac12d3')
// prints: ["bac12", "2", index: 0, input: "bac12d3"]
```

如果使用的正则包含修饰符`g`, 那么返回的数组只包含所有的子匹配，并不包含额外的属性以及捕获性分组：

```javascript
'bac12d3'.match(/[a-z]+(\d)*/g)
// prints: ["bac12", "d3"]
```

不管是哪种情况，没有找到任何匹配，那么返回`null`。

该方法的详细用法可以[参考这里](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/String/match)

### regex.exec
> 我们知道，字符串的indexOf方法提供了起始搜索偏移量这个参数，可以更加高效的执行字符串查找。但是字符串的一些有关正则方法并没有直接提供这样的方式。正则对象虽然也没有直接提供这样的快捷方式，但是正则对象的exec方法提供了一种"不是很方便"的方式来让我们做这样一个操作, 那就是通过`lastIndex`这个正则属性。

```javascript
var re = /quick\s(brown).+?(jumps)/ig
var result = re.exec('The Quick Brown Fox Jumps Over The Lazy Dog')
// prints: ["Quick Brown Fox Jumps", "Brown", "Jumps", index: 4, input: "The Quick Brown Fox Jumps Over The Lazy Dog"]
```

关于上面的脚本中的`re`,`result`对象相关属性说明如下：

<table>
    <thead>
        <tr>
            <th width="10%" align="center">对象</th>
            <th width="10%" align="center">属性/索引</th>
            <th width="40%" align="center">描述</th>
            <th width="40%" align="center">例子</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="4">result</td>
            <td>[0]</td>
            <td>完全匹配</td>
            <td>Quick Brown Fox Jumps</td>
        </tr>
        <tr>
            <td>[1], ...[n]</td>
            <td>捕获性分组</td>
            <td>[1] = Brown<br>[2] = Jumps</td>
        </tr>
        <tr>
            <td>index</td>
            <td>完整的匹配在整个字符串中的索引</td>
            <td>4</td>
        </tr>
        <tr>
            <td>input</td>
            <td>要匹配的原始字符串</td>
            <td>The Quick Brown Fox Jumps Over The Lazy Dog</td>
        </tr>
        <tr>
            <td rowspan="5">re</td>
            <td>lastIndex</td>
            <td>执行下一次搜索时起始的位置</td>
            <td>25</td>
        </tr>
        <tr>
            <td>ignoreCase</td>
            <td>表示是否使用了i标记</td>
            <td>true</td>
        </tr>
        <tr>
            <td>global</td>
            <td>表示是否使用了g标记</td>
            <td>true</td>
        </tr>
        <tr>
            <td>multiline</td>
            <td>表示是否使用了m标记</td>
            <td>false</td>
        </tr>
        <tr>
            <td>source</td>
            <td>匹配模式的字符串文本</td>
            <td>quick\s(brown).+?(jumps)</td>
        </tr>
    </tbody>
</table>

> 下面就关于上表中的相关注意事项做下说明： 我们知道，正则引擎是eager(急切的，渴望的)的，也就是说当从整个字符串中找到一个匹配时，会立马停止继续查找，并返回找到的子串。
> 像字符串的`match`, `replace`方法，当第一个参数为正则对象时，可以传入修饰符`g`来进行全局的查找，也就说找到从一行字符中找到所有的匹配，直到查找到这行字符串的尽头。
> 但是正则对象的exec方法却并不是这样的，即使你传入全局标记`g`,依然只是返回第一个匹配。我们测试下：

```javascript
/(\d)/g.exec('ab12c45')
// prints: ["1", "1", index: 2, input: "ab12c45"]
```

经过上面例子的验证，我们看到确实如我们所言：尽管是全局匹配，但是依然只是返回了第一个匹配。
还有就是需要注意exec方法和match方法的对比：
- exec方法使用了全局标记`g`,它虽然只返回了第一个匹配，但是它返回的信息非常全面，包含`index`,`innput`属性以及捕获性分组。
- match方法不使用全局标记`g`时，返回的信心包含`index`,`input`属性以及捕获性分组。
- match方法使用了全局标记`g`, 返回的信息只包含所有匹配的子串。
<br>
既然exec方法有没有全局标记`g`，返回的信息都一样，那么全局`g`有什么用？

### 正则对象的lastIndex属性
> 一当一个正则对象或者正则字面量开启了全局标记`g`，那么配合正则对象的`lastIndex`属性，我们就可以指定下次搜索时，从什么位置开始搜索。并且通过循环判断exec方法来的返回值对字符串进行一个全局的匹配。

```javascript
var reg = /\d+/g
console.log(reg.lastIndex) // 0
console.log(reg.exec('abc12d3bb4')) // ["12", index: 3, input: "abc12d3bb4"]
console.log(reg.lastIndex) // 5
```

> 默认情况下正则对象的`lastIndex`值是0，表示起始偏移量。
> 一旦成功的找到一个匹配后，正则引擎会自动更新`lastIndex`的值，表示下一次匹配时默认从这个地方开始。
> 什么从一开始就没有找到任何匹配，那么`lastIndex`的值还是0。

当然了，你可以设置`lastIndex`的值，表示一开始就从你设置的这个位置开始查找：

```javascript
var reg = /\d+/g
reg.lastIndex = 5
console.log(reg.exec('abc12d3bb4')) // ["3", index: 6, input: "abc12d3bb4"]
console.log(reg.lastIndex) // 7
```

使用exec方法找到所有匹配，一般这样做：
```javascript
var reg = /\d+/g
var match = null
var str = 'abc12d3bb4'
while(match = reg.exec(str)){
    console.log('$&: ', match[0])
    console.log('lastIndex: ', reg.lastIndex)
}
// prints: 
// $&:  12
// lastIndex:  5
// $&:  3
// lastIndex:  7
// $&:  4
// lastIndex:  10
```

## 字符串相关方法 VS 正则对象的相关方法
> // TODO ...