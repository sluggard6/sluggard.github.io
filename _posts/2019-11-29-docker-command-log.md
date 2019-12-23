---
layout: post
title: 搭建docker环境的记录
date: 2019-11-29
categories: blog
tags: [docker]
description: 
---

### docker安装私有仓库
docker run -d -p 5000:5000 -v /data/registry:/var/lib/registry registry

### 安装zookeeper
docker run -p 2181:2181 --restart always -d zookeeper

### 安装mysql
docker run -d -p 3306:3306 -v /data/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7.28 --innodb-use-native-aio=0

要注意增加--innodb-use-native-aio=0

否则回报错：InnoDB : Error 22 with aio_write

### 安装redis
docker run -d -p 6379:6379 redis --requirepass "password"