---
title: 代码规范
date: 2018-03-16 16:21:48
tags:
  - workflow
  - git
  - lint
  - prettier
  - changelog
categories:
  - 工作流
---

## git 日志提交规范

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

> 当使用`type script`的时候，如果修改的内容和 types 相关。
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

```json
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

package.json 配置

```json
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

```bash
npm i -g commitizen cz-conventional-changelog
```

创建 commitizen 配置文件：

```bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

现在每次提交的时候就可以使用`git cz`代替`git commit`。
`git cz`**支持和**`git commit`**一样的选项，如：git cz -a**。

## 自定义 commit 校验

verify-commit-msg.js

```js
const chalk = require('chalk')
const msgPath = process.env.GIT_PARAMS
const msg = require('fs')
  .readFileSync(msgPath, 'utf-8')
  .trim()

const commitRE = /^(revert: )?(feat|fix|docs|style|refactor|perf|test|workflow|ci|chore|types)(\(.+\))?: .{1,50}/

if (!commitRE.test(msg)) {
  console.log()
  console.error(
    `  ${chalk.bgRed.white(' ERROR ')} ${chalk.red(
      `invalid commit message format.`
    )}\n\n` +
      chalk.red(
        `  Proper commit message format is required for automated changelog generation. Examples:\n\n`
      ) +
      `    ${chalk.green(`feat(compiler): add 'comments' option`)}\n` +
      `    ${chalk.green(
        `fix(v-model): handle events on blur (close #28)`
      )}\n\n` +
      chalk.red(
        `  You can also use ${chalk.cyan(
          `npm run commit`
        )} to interactively generate a commit message.\n`
      )
  )
  process.exit(1)
}
```

## [git 钩子](https://git-scm.com/docs/githooks)

> 在 git 执行特定的阶段触发的程序，这些程序被放置在特定的目录下`$GIT_DIR/hooks`。

常用的钩子：

- pre-commit：执行`git-commit`时触发，但是你可以通过`--no-verify`选项绕过这个钩子。如果该钩子以非零状态码退出，那么会取消这次的提交。

- commit-msg：执行`git-commit`和`git-merge`的时候触发，但是你可以通过`--no-verify`选项绕过这个钩子。执行该钩子，会将握有提案信息的文件名作为参数传给该钩子。可以使用该钩子来编辑提交信息文件以规范提交信息，也可以拒绝提交信息。

- post-commit：执行这个钩子时，提交信息已经生成。主要用来发送一些通知等。

- pre-push：执行`git-push`时触发，会将远程地址和分支名称传入该钩子。如果该钩子以非零状态码退出，那么退出该次推送。

## [husky](https://github.com/typicode/husky)

> 通过`npm scripts`来触发`git hooks`，让使用`git hooks`更加的简单。

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "node verify-commit-msg.js"
    }
  }
}
```

## [lint-staged](https://github.com/okonet/lint-staged)

> 在 git 执行的特定时期来触发校验。

```json
{
  "lint-staged": {
    "*.{js,jsx,json}": ["prettier --write", "git add"]
  }
}
```

## [prettier](https://prettier.io/)

> 一款强大的代码格式化工具，支持`js`,`jsx`,`Vue`, `Flow`, `TypeScript`等。

```json
{
  "prettier": {
    "semi": false,
    "singleQuote": true,
    "arrowParens": "avoid",
    "trailingComma": "es5"
  }
}
```

### prettier整合eslint

.eslintrc.json:

```json
{
  "plugins": ["prettier"],
  "extends": ["plugin:prettier/recommended"],
  "rules": {
    "prettier/prettier": "warn"
    // other eslint rules
  }
}
```

## [eslint](https://eslint.org/)

## [Airbnb Javascript Style](https://github.com/airbnb/javascript)
