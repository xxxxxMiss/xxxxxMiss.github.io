---
title: http-range
date: 2018-11-21 21:46:00
tags:
  - http
  - range
categories:
  - http
---

## Range 简介

> *Range*是一个请求首部，告知服务器返回文件的哪一部分。在一个*Range*首部中，可以一次性请求多个部分，服务器会以*multipart*文件的形式将其返回。

- 如果服务器返回的是范围响应，需要使用`206 Partial Content`状态码。
- 假如所请求的范围不合法，那么服务器会返回`416 Range Not Satisfiable`状态码，表示客户端错误。
- 服务器允许忽略 Range 首部，从而返回整个文件，状态码用`200` 。

## 语法

> Range: <unit>=<range-start>-
> Range: <unit>=<range-start>-<range-end>
> Range: <unit>=<range-start>-<range-end>, <range-start>-<range-end>
> Range: <unit>=<range-start>-<range-end>, <range-start>-<range-end>, <range-start>-<range-end>

## [range-parser](https://github.com/jshttp/range-parser)源码解读

```js
function rangeParser(size, str, options) {
  if (typeof str !== 'string') {
    throw new TypeError('argument str must be a string')
  }

  var index = str.indexOf('=')

  if (index === -1) {
    // -2： 表示str是一个不符合range语法的字符串
    return -2
  }

  // split the range string
  // 将多个range以逗号分割
  var arr = str.slice(index + 1).split(',')
  var ranges = []

  // add ranges type
  // 获取单位<unit>，这个单位一般为bytes
  ranges.type = str.slice(0, index)

  // parse all ranges
  for (var i = 0; i < arr.length; i++) {
    var range = arr[i].split('-')
    var start = parseInt(range[0], 10)
    var end = parseInt(range[1], 10)

    // -nnn
    // 如果没有起始范围（索引），如：bytes=-10
    if (isNaN(start)) {
      start = size - end
      end = size - 1
      // nnn-
      // 如果没有结束范围（索引），如：bytes=10-
    } else if (isNaN(end)) {
      end = size - 1
    }
    // limit last-byte-pos to current length
    // 如果结束索引超出了最大索引，那么设置结束索引为最大索引
    if (end > size - 1) {
      end = size - 1
    }

    // invalid or unsatisifiable
    // 如果经过上面处理之后，还有一些无效的情况
    // 如：起始索引大于结束索引，或者开始索引是负数等
    // 那么跳过这些情况
    if (isNaN(start) || isNaN(end) || start > end || start < 0) {
      continue
    }

    // add range
    ranges.push({
      start: start,
      end: end
    })
  }

  // 如果最终都没有解析到有效的，那么返回-1
  if (ranges.length < 1) {
    // unsatisifiable
    return -1
  }

  // 如果传入options.combine，那么先处理索引重叠的情况
  // 否则直接返回
  return options && options.combine ? combineRanges(ranges) : ranges
}
```

处理索引有重叠，合并小的连续的范围：

```js
// var range = parse(150, 'bytes=0-4,90-99,5-75,100-199,101-102', { combine: true })
// assert.strictEqual(range.type, 'bytes')
// assert.strictEqual(range.length, 2)
// assert.deepEqual(range[0], { start: 0, end: 75 })
// assert.deepEqual(range[1], { start: 90, end: 149 })
/**
 * Combine overlapping & adjacent ranges.
 * @private
 */

function combineRanges(ranges) {
  // [
  //   { start: 0, end: 4, index: 0 },
  //   { start: 5, end: 75, index: 2 },
  //   { start: 90, end: 99, index: 1 },
  //   { start: 101, end: 102, index: 4 },
  //   { start: 100, end: 199, index: 3 },
  // ]
  var ordered = ranges.map(mapWithIndex).sort(sortByRangeStart)

  for (var j = 0, i = 1; i < ordered.length; i++) {
    var range = ordered[i]
    var current = ordered[j]

    if (range.start > current.end + 1) {
      // next range
      ordered[++j] = range
    } else if (range.end > current.end) {
      // extend range
      current.end = range.end
      current.index = Math.min(current.index, range.index)
    }
  }

  // trim ordered array
  ordered.length = j + 1

  // generate combined range
  var combined = ordered.sort(sortByRangeIndex).map(mapWithoutIndex)

  // copy ranges type
  combined.type = ranges.type

  return combined
}
```
