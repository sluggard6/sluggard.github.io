---
layout: post
title: 关于gradle配置变量的问题
date: 2022-06-01
categories: blog
tags: [gradle]
description: 
---

注意事项
```
implementation "com.google.code.gson:gson:$gsonVersion"
```

使用$配置变量方法定义依赖时，需要使用双引号，因为gradle使用的是groovy语言, groovy的字符串有三种使用方式，单引号'',双引号"",三个单引号'''，分别表示：只表示字符串；字符串可以通过${}引用其他变量；字符串换行。
