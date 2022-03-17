---
layout: post
title: iris介绍
date: 2019-11-29
categories: blog
tags: [github]
description: 
---

去年年初开始学习golang，就想着自己写一个项目练练手，发现了一个非常不错的webmvc中间件，自称为速度最快的golang web框架，看过作者在github上的疯狂提交记录以后，决定用它来做我的练手项目。


### 第一步是导入代码
```
$ mkdir myapp
$ cd myapp
$ go mod init myapp
$ go get github.com/kataras/iris/v12@master
```