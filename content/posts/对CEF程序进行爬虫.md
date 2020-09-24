---
title: "对CEF程序进行爬虫"
date: 2020-09-20
tags: ["浏览器","CEF","Selenium"]
categories: ["爬虫"]
---

# 对CEF程序进行爬虫

想标题想了很久，最后感觉还是用这个标题比较合适。

问题情景是这样的：

有一个较为古老的CEF程序，需要对程序里面的内容进行爬取，获取数据。

众所周知，CEF框架无非就是个浏览器，最终访问的还是网页，那么我们直接访问网页进行爬取不就好了吗?

但实际上能否这样做是值得商榷的，例如我要爬取的那个程序，通过CEF注册JS扩展的方式，使网页与本地的其它进程建立起了通讯，这样我就不能脱离这个CEF程序而独立去访问网页了，否则页面将无法正常运作。

遇到这种情况，我们可以根据**远程调试协议**开启浏览器的远程调试功能，再用Selenium或者Puppeteer等爬虫工具挂接浏览器，这样我们就可以对浏览器进行一些自动化操作了。

### 开启远程调试

开启方法很简单，在要调试的浏览器进程快捷方式属性上加上参数:

```
--remote-debugging-port=9222 --user-data-dir=C:\ChromeDebug
```

远程调试端口一般为9222，用户数据目录我们随便创建一个就好。

这个时候我们可以访问127.0.0.1:9222/json/version，其中有一个值叫webSocketDebuggerUrl，调试程序主要就是根据这个URL来连接上浏览器的。

### Selenium爬虫

为什么使用Selenium而不是Puppeteer呢？先前已经提到，该CEF程序是一个古老的程序，Chromium浏览器内核版本为V58左右，而Puppeteer框架对浏览器版本有着严格的限制，官方也有说明:每一个版本的Puppeteer理论上只适配一个特定版本的Chromium浏览器。而Selenium框架对版本支持更加友好，不管老版本还是新版本，都有适配的浏览器驱动，我们只需要去下载相应版本的WebDriver即可。下载地址如下:

http://chromedriver.storage.googleapis.com/index.html



至于Selenium的使用教程，参考一下:

https://selenium-python-zh.readthedocs.io/en/latest/

编写代码连接上浏览器

```python
from selenium import webdriver

chrome_options = webdriver.ChromeOptions()
chrome_options.add_experimental_option('debuggerAddress','127.0.0.1:9222')

browser = webdriver.Chrome(executable_path="C:\chromedriver.exe",chrome_options=chrome_options)

browser.get('http://www.baidu.com')
```

之后后面的模拟点击、爬取内容就不再细谈了。