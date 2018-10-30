---
title: git-commit-rules
date: 2018-03-16 16:21:48
tags:
    - git
categories: 版本管理
---

## git日志提交规范
> 格式如下：

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

### fix(:bug:)
> 修复问题，对应`semver patch`
> fix: named slots for nested functional components

> 指定具体的模块，功能等

- fix(core)
- fix(ssr)
- fix(model)
- fix(keep-alive)

### feat(:sparkles:)
> 增加新的特征，功能，对应`semver minor`
> feat(weex): support sending style sheets and class list to native

### BREAKING CHANGE
> 内容发生重大改变，对应`semver major`
> BREAKING CHANGE: environment variables now take precedence over config files

### build
> 构建版本
> build: release 2.5.15

### test
> 测试相关
> test(vdom): add test case for #7786 (#7793)

### types
> 当使用`type script`的时候，如果修改的内容和types相关。
> types: add Fragment in RenderState typing (#7802)

### workflow
> 有关工作流的修改
> workflow: specify e2e env when releasing
> workflow: remove setup script

### chore
> 一些杂活，比如更新赞助者，重新组织代码贡献者
> chore: coverage
> chore: update sponsors
> chore: re-organize backers.md

### refactor
> 重构代码
> refactor: observerState

> 重构具体的模块
> refactor(core): remove unnecessary switch case (#5971) 

### docs(:memo:)
> 有关文档的修改
> docs: update Angular's commit convention link (#7666)

### ci
> 相关工具的修改，比如`vue-cli`
> ci: use latest version of codecov binary (#7665) 

### polish
> 美化代码
> polish: raise warning when Vue.set/delete is called on invalid values

### revert
> 版本回退
> revert(weex): remove the "receiveTasks" api and support component hook

### perf(:zap:)
> 优化性能
> perf(v-model): tweak setSelected

[Conventional Changelog Ecosystem](https://github.com/conventional-changelog/conventional-changelog)
[semantic versioning](https://semver.org/#spec-item-9)
[git conventional commits](https://conventionalcommits.org/)
[git emojis](https://www.webpagefx.com/tools/emoji-cheat-sheet/)

## 使用`commitlint`校验本地提交信息
安装包
```
npm i @commitlint/cli @commitlint/config-conventional husky --save-dev
```

在项目的根目录下新建`commitlint.config.js`
```
module.exports = {extends: ['@commitlint/config-conventional']}
```

在`scripts`中添加如下`script`
``` json
{
  "scripts": {
    "commitmsg": "commitlint -e $GIT_PARAMS"
  }
}
```

## 使用`commitizen`交互式窗口生成约定的提交信息
### 作为项目依赖安装使用
```
npm i commitizen cz-conventional-changelog --save-dev
```
package.json配置
``` json
{
  "scripts": {
    "commit": "git-cz"
  },
  "config": {
    "commitizen": {
      "path": "cz-conventional-changelog"
    }
  }
}
```
然后每次提交的时候，使用`npm run commit`代替`git commit`。

### 作为全局安装使用
``` bash
npm i -g commitizen cz-conventional-changelog
```
创建commitizen配置文件：
``` bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```
现在每次提交的时候就可以使用`git cz`代替`git commit`。
`git cz`**支持和**`git commit`**一样的选项，如：git cz -a**。
