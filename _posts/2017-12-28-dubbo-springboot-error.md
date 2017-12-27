#记一个springboot+dubbo的错误

今天搭建一个springboog+dubbo.consumer+zookeeper的服务,很简单的一个框架,但是就是拿不到远程服务,报下面的错误
```
2017-12-27 14:38:17.365 ERROR 8015 --- [  restartedMain] com.alibaba.dubbo.common.logger.Logger   :  [DUBBO] Failed to init remote service reference at filed smsService in class com.jhh.jfq.loan.app.controller.UserController, cause: interface com.jhh.jfq.loan.api.sms.SmsService is not visible from class loader, dubbo version: 2.5.3, current host: 192.168.57.1

java.lang.IllegalArgumentException: interface com.jhh.jfq.loan.api.sms.SmsService is not visible from class loader
```
参考了[这篇](http://blog.csdn.net/weigang200820chengdu/article/details/78139180)文章,不过请不要被文章标题误导,和是否是dubbo本地服务无关,仅仅就是因为spring-boot-devtools包和spring-boot-starter-dubbo是冲突的~把maven的一下部分注释掉就好了
```
<!-- 
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-devtools</artifactId>
	<version>${spring-boot.version}</version>
	<optional>true</optional>
</dependency>
-->
```
希望dubbo团队能尽快解决这个问题.