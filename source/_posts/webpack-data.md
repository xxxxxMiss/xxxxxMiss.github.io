---
title: webpack-data
date: 2019-01-09 16:03:44
tags:
categories:
---

## compilation

> 实例方法：

- getStats()

- addModule(module, cacheGroup)

- getModule(module)

- findModule(identifier)

- waitForBuildingFinished(module, callback)

- buildModule(module, optional, origin, dependencies, thisCallback)

- processModuleDependencies(module, callback)

- addModuleDependencies(
  module,
  dependencies,
  bail,
  cacheGroup,
  recursive,
  callback
  )

- addEntry(context, entry, name, callback)

- prefetch(context, dependency, callback)

- rebuildModule(module, thisCallback)

- finish()

- unseal()

- seal(callback)

- reportDependencyErrorsAndWarnings(module, blocks)

- addChunkInGroup(groupOptions, module, loc, request)

- addChunk(name)

- assignDepth(module)

- getDependencyReference(module, dependency)

- processDependenciesBlocksForChunkGroups(inputChunkGroups)

- removeReasonsOfDependencyBlock(module, block)

- patchChunksAfterReasonRemoval(module, chunk)

- removeChunkFromDependencies(block, chunk)

- applyModuleIds()

- applyChunkIds()

- sortItemsWithModuleIds()

- sortItemsWithChunkIds()

- summarizeDependencies()

- createHash()

- modifyHash(update)

- createModuleAssets()

- createChunkAssets()

- getPath(filename, data)

- createChildCompiler(name, outputOptions, plugins)

- checkConstraints()

## compilation.assets

```js
{
  'account/index.html': CachedSource
}
```

[CachedSource](https://github.com/webpack/webpack-sources)

## chunk

- canBeInitial()

  > 是否初始化加载（对应的是按需加载）

- files

```js
;['account/index.html']
```

## compilation hooks

- optimizeChunkAssets

> args: chunks

## compiler

```js
compiler.inputFileSystem = {
  purge() {}
}
compiler.purgeInputFileSystem()
```

- comipler.watchMode
  > 是否处于 watch 模式

## compiler hooks

- beforeCompile

> args: params

- compile

> args: params

### params

> params 对象上有如下东西：

```js
const params = {
  // createNormalModuleFactory()触发normalModuleFactory钩子
  // this.hooks.normalModuleFactory.call(normalModuleFactory);
  normalModuleFactory: this.createNormalModuleFactory(),
  // createContextModuleFactory()触发contextModuleFactory钩子
  //this.hooks.contextModuleFactory.call(contextModuleFactory);
  contextModuleFactory: this.createContextModuleFactory(),
  compilationDependencies: new Set()
}
```

### normalModuleFactory

> 该对象是一个`NormalModuleFactory`类的实例

### NormalModuleFactory

```js
class NormalModuleFactory extends Tapable {}
```

> 实例方法：

- create(data, callback)

- resolveRequestArray(contextInfo, context, array, resolver, callback)

- getParser(type, parserOptions)

- createParser(type, parserOptions = {})

- getGenerator(type, generatorOptions)

- createGenerator(type, generatorOptions = {})

- getResolver(type, resolveOptions)

### ContextModuleFactory

```js
class ContextModuleFactory extends Tapable {}
```

> 实例方法：

- create(data, callback)

- resolveDependencies(fs, options, callback)

## 模块基类之间的继承关系

### DependenciesBlock

> 实例属性

- dependencies: []

- blocks: []

- variables: []

> 实例方法

- addBlock(block)

  > 用来做代码分割的

- addVariable(name, expression, dependencies)

- addDependency(dependency)

- removeDependency(dependency)

- updateHash(hash)

- disconnect()

- unseal()

- hasDependencies(filter)

- sortItems()

### Module

```js
class Module extends DependenciesBlock {}
```

> 实例属性

-     this.type = type;

-     this.context = context;

-     this.debugId = debugId++;

-     this.hash = undefined;

-     this.renderedHash = undefined;

-     this.resolveOptions = EMPTY_RESOLVE_OPTIONS;

-     this.factoryMeta = {};

- this.warnings = [];

-     this.errors = [];

-     this.buildMeta = undefined;

-     this.buildInfo = undefined;

-     this.reasons = [];

-     this._chunks = new SortableSet(undefined, sortById);

-     this.id = null;

-     this.index = null;

-     this.index2 = null;

-     this.depth = null;

-     this.issuer = null;

-     this.profile = undefined;

-     this.prefetched = false;

-     this.built = false;

-     this.used = null;

-     this.usedExports = null;

-     this.optimizationBailout = [];

-     this._rewriteChunkInReasons = undefined;

-     this.useSourceMap = false;

-     this._source = null;

> getter

- get exportsArgument()

- get moduleArgument()

- get optional()

- get chunksIterable()

> 实例方法

- disconnect()

- unseal()

- setChunks(chunks)

- addChunk(chunk)

- removeChunk(chunk)

- isInChunk(chunk)

- isEntryModule()

- getChunks()

- getNumberOfChunks()

- hasEqualsChunks(otherModule)

- addReason(module, dependency, explanation)

- removeReason(module, dependency)

- hasReasonForChunk(chunk)

- hasReasons()

- rewriteChunkInReasons(oldChunk, newChunks)

- isUsed(exportName)

- isProvided(exportName)

- toString()

- updateHash(hash)

- sortItems(sortChunks)

### NormalModule

```js
class NormalModule extends Module {}
```

## Template 类

> 各种`Module`会有对应的`Template`，用来拼接相关字符串（一些注释等）和源代码字符串的。

- MainTemplate: 用来操作入口文件的。
