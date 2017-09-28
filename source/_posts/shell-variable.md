---
title: shell变量
date: 2017-03-30 00:21:20
tags: shell
categories: linux
---

### 变量的定义
```
your_name="rou"
```
- 变量名只能有字母和下划线`_`组成，且不能使用`bash`里的关键字
- 变量名和等号之间不能有空格

### 使用变量
```
your_name="rou"
echo $your_name
echo ${your_name} // 推荐使用这种方式
```

### 只读变量
```
readonly myUrl="www.baidu.com"
```

### 删除变量
```
unset varibale_name
```
>变量被删除后不能再次使用。`unset`命令不能删除***只读***变量


### Shell字符串
> shell中字符串即可用单引号包裹，也可以用双引号包裹
- 当引号中包裹的字符中照原样输出
- 双引号包裹的字符串可以包含变量

### 获取字符串的长度
```
my_str="this is a test string"
${#my_str}
```

### 提取字符串
```
str="my name is test"
${str:1:4} // 从第2个位置开始截取4个字符串（下标索引从0开始）
```


### Shell数组
```
array_name=(value1 value2 valu3...)
或者
array_name=(
    value1
    value2
    value3
)
```

### 获取数组中所有的元素
```
array=(a b c)
${array[@]} 或者 ${array[*]}
```

### 获取数组的长度
> 和获取字符的长度语法是一致的

```
# 获取数组的长度
${#array[@]} 或者 ${#array[*]}

# 获取数组中某个元素的长度
${#array[n]} // 下标n从0开始
````