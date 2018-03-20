---
title: vue-ssr
date: 2017-12-04 15:20:00
tags:
    - vue
    - ssr
categories:
    - 构建工具
---

## 整合jsx
### 依赖包
- babel-plugin-syntax-jsx
- babel-plugin-transform-runtime
- babel-plugin-transform-vue-jsx

### nuxt.config.js
> 在`build`配置项中增加如下配置

```javascript
build: {
    babel: {
      "presets": [
        ["env", {
          "modules": false
        }],
        "stage-2", // 为了使用对象的延展语法
        "flow"
      ],
      "plugins": ["transform-runtime", "transform-vue-jsx"]
    }
}
```

### 如果只是使用客户端渲染，在.eslintrc中配置
```
{
  "presets": [
    ["env", {
      "modules": false
    }],
    "stage-2", // 为了使用对象的延展语法
    "flow"
  ],
  "plugins": ["transform-runtime", "transform-vue-jsx"]  
}
```


## 整合flow
### 依赖包
- babel-preset-flow
- eslint-plugin-flowtype

### .eslintrc.js配置
```javascript
plugins: [
  'html',
  'flowtype'
],
'extends': [
    'standard',
    'plugin:flowtype/recommended'
]
```

### flow配置文件
> 在项目的根目录下增加`.flowconfig`配置文件，具体配置也可以查看flow的官方文档。
> [flow](https://flow.org/en/docs/install/)

```
[ignore]
.*/node_modules/.*
.*/dist/.*
.*/public

[include]

[libs]
flow

[options]
unsafe.enable_getters_and_setters=true
```