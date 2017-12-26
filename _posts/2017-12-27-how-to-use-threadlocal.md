---
layout: post
title: ThreadLocal的典型用法
date: 2017-12-27
categories: blog
tags: [java,多线程,ThreadLocal]
description: 
---

最近面试了很多人，聊起多线程的时候，都很容易聊到java.lang.ThreadLocal这个类，大多数人都知道这个类的作用，但是问起在什么情况下会使用这个类的时候，绝大多数人都基本上没有在实际生产中使用过这个类，所以今天就来和大家分享一下这个类的一个用法，那就是java.text.SimpleDateFormat.因为SimpleDataFormat是线程不安全的，我们没法定义一个全局的SimpleDataFormat类的实例到处调用，但是每次都new一个新的实例，不仅很烦，而且让人觉得很不舒服（好吧，我承认我对代码有洁癖），但是通过ThreadLocal就完美的解决了这个问题，下面是代码参考
```
package xyz.sluggard.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class DateFormatUtil {

    private static final String DATETIME_PATTERN = "yyyy-MM-dd hh:mm:ss";

    private static ThreadLocal<SimpleDateFormat> dataTimeFormat = new ThreadLocal<SimpleDateFormat>(){

        @Override
        protected SimpleDateFormat initialValue() {
            return new SimpleDateFormat(DATETIME_PATTERN);
        }
    };

    public static Date dateTimeParse(String source) throws ParseException {
        return dataTimeFormat.get().parse(source);
    }

    public static String dateTimeFormat(Date date) {
        return dataTimeFormat.get().format(date);
    }


}

```