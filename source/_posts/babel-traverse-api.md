---
title: babel-traverse API
date: 2018-12-27 10:45:55
tags:
  - js
  - babel
  - babel-traverse
categories:
  - js
---

## 父节点相关

```js
findParent(callback): ?NodePath
```

> 从当前节点的父节点（不包括当前节点自己）开始向上查找并调用 callback，如果 callback 返回一个真值，那么返回那个父节点；都没有找到，返回 null。

```js
find(callback): ?NodePath
```

> 同`findParent`，唯一的区别是从当前节点（包括自己）开始查找。

```js
getFunctionParent(): ?NodePath
```

> 找到满足 callback 的函数父节点。

```js
getStatementParent(): NodePath
```

> 向上遍历节点书，直到命中一个处于`list`中的父节点。

```js
getEarliestCommonAncestorFrom(
  paths: Array<NodePath>,
): NodePath
```

```js
getDeepestCommonAncestorFrom(
  paths: Array<NodePath>,
  filter?: Function,
): NodePath
```

```js
getAncestry(): Array<NodePath>
```

```js
isAncestor(maybeDescendant: NodePath): boolean
```

> 判断当前的`path`是否是`maybeDescendant`的祖先节点。

```js
isDescendant(maybeAncestor: NodePath): boolean
```

> 判断当前的`path`是否是`maybeAncestor`的后代。

```js
inType(): boolean
```

> 向上查找，直到一个节点的`type`在提供的`type`列表中为止，此时返回 ture，否则 false。

## 兄弟节点相关

```js
getOpposite(): ?NodePath
```

> 得到一个对立的节点。

```js
getCompletionRecords(): Array
```

> 得到一个完整到的记录。

```js
// key: 即为path.key
getSibling(key): NodePath
```

> 根据`key`得到一个兄弟节点。

```js
getPrevSibling(): NodePath
```

> 得到当前节点的前一个节点。

```js
getNextSibling(): NodePath
```

> 得到当前节点的下一个节点。

```js
getAllNextSiblings(): Array<NodePath>
```

```js
getAllPrevSiblings(): Array<NodePath>
```

```js
get(
  key: string,
  context?: boolean | TraversalContext,
): NodePath
```

> 根据字符串路径得到一个节点，类似于`lodash`中的`get`方法：`path.get('body.0')`。

```js
getBindingIdentifiers(duplicates?): Object
```

> 获取绑定的标示，如：

```js
var a = 1, { d } = b, [c] = e
//       ⬇
//
{ a:
   Node {
     type: 'Identifier',
     start: 4,
     end: 5,
     loc:
      SourceLocation { start: [Position], end: [Position], identifierName: 'a' },
     name: 'a' },
  d:
   Node {
     type: 'Identifier',
     start: 27,
     end: 28,
     loc:
      SourceLocation { start: [Position], end: [Position], identifierName: 'd' },
     name: 'd' },
  b:
   Node {
     type: 'Identifier',
     start: 15,
     end: 16,
     loc:
      SourceLocation { start: [Position], end: [Position], identifierName: 'b' },
     name: 'b' } }
```

```js
getOuterBindingIdentifiers(duplicates?): Object
```

> 获取函数外层绑定的标识符，如：

```js
function f () {}
// ⬇
//
{ f:
   Node {
     type: 'Identifier',
     start: 43,
     end: 44,
     loc:
      SourceLocation { start: [Position], end: [Position], identifierName: 'f' },
     name: 'f' } }
```

```js
getBindingIdentifierPaths((duplicates = false), (outerOnly = false))
```

```js
getOuterBindingIdentifierPaths(duplicates?)
```

## 当前节点自身相关

```js
matchesPattern(
  pattern: string,
  allowPartial?: boolean,
): boolean
```

```js
has(key): boolean
```

> 别名：`is`

```js
isnt(key): boolean
```

> `has`的否定操作。

```js
equals(key, value): boolean
```

> 检查当前节点的`key`是否等于给定的`value`。

```js
isNodeType(type: string): boolean
```

```js
canHaveVariableDeclarationOrExpression()
```

```js
canSwapBetweenExpressionAndStatement(replacement)
```

```js
isStatic()
```

```js
isCompletionRecord(allowInsideFunction?)
```

```js
isStatementOrBlock()
```

```js
referencesImport(moduleSource, importName)
```

```js
getSource()
```

> 获取当前节点的 souce 内容。

```js
willIMaybeExecuteBefore(target)
```

```js
resolve(dangerous, resolved)
```

```js
isConstantExpression()
```

```js
isInStrictMode()
```

> 判断一个模块或者函数是否处于严格模式。
> ES6 模块默认是处于严格模式，其实情况看是否使用`use strict`指令。

## 修改当前节点相关

```js
insertBefore(nodes)
```

```js
insertAfter(nodes)
```

```js
updateSiblingKeys(fromIndex, incrementBy)
```

```js
unshiftContainer(listKey, nodes)
```

```js
// listKey: path.listKey => "body" | "params"
pushContainer(listKey, nodes)
```

> 将`nodes`放入到指定的`listKey`容器中，如：

```js
function test(a) {}
path.pushContainer('params', t.identifier('b'))
// ⬇
function test(a, b) {}

path.pushContainer('body', t.expressionStatement(t.identifier('b')))
// ⬇
function test(a) {
  b
}
```

```js
hoist((scope = this.scope))
```

## 删除当前节点相关

```js
remove()
```

## 替换当前节点相关

```js
replaceWithMultiple(nodes: Array<Object>)
```

> 用多个节点替换当前节点。

```js
replaceWithSourceString(replacement)
```

> _不推荐使用_
> 将`replacement`作为一个表达式去解析，然后用解析的结果替换当前节点。

```js
replaceWith(replacement)
```

> 用一个节点替换当前节点。

```js
replaceExpressionWithStatements(nodes: Array<Object>)
```

```js
replaceInline(nodes: Object | Array<Object>)
```

## 注释相关

```js
shareCommentsWithSiblings()
```

```js
addComment(type: string, content: string, line?: boolean)
```

```js
addComments(type: string, comments: Array)
```

## 上下文相关

> 维护`TraversalContext`相关的方法。

```js
call(key): boolean
```

```js
isBlacklisted(): boolean
```

```js
visit(): boolean
```

```js
skip()
```

```js
skipKey(key)
```

```js
stop()
```

> 停止继续往上或者往下遍历一个节点。

```js
setScope()
```

```js
setContext(context)
```

```js
resync()
```

```js
popContext()
```

```js
pushContext(context)
```

```js
setup(parentPath, container, listKey, key)
```

```js
setKey(key)
```

```js
requeue((pathToQueue = this))
```

## 节点类型转化

```js
ensureBlock()
```

> 将可以转化的节点（函数，for 循环等）转换成块节点，如：`() => true` => `() => { return true }`。

```js
arrowFunctionToExpression(
  ({ allowInsertArrow = true, specCompliant = false } = {})
)
```

> 将一个箭头函数转化为 ES5 的函数表达式。
