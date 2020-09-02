---
title: "Puppeteer入门教程"
date: 2020-09-01
tags: ["浏览器","自动化","模拟","入门教程"]
categories: ["Puppeteer"]
---



# Puppeteer入门教程

Puppeteer，木偶框架，是谷歌开源的一个浏览器控制框架。它提供了一组可以用来操控Chrome的API，使得我们可以很方便地进行一些浏览器模拟、自动化操作，例如:

1. 生成网页截图或者 PDF
2. 高级爬虫，爬取大量异步渲染内容的网页
3. 模拟键盘输入、表单自动提交、登录网页等，实现 UI 自动化测试
4. 捕获站点的时间线，以便追踪网站，帮助分析网站性能问题



至于为什么选择Puppeteer，而不使用Selenium等其它浏览器控制框架，是因为Puppeteer有以下优点:

1. Puppeteer 比Selenium安装简单，使用起来较为简单、更人性化，是站在用户使用的角度上来设计操作接口，而不是浏览器的角度。
2. 由Chrome官方团队进行维护，拥有更好的前景。
3. 功能比Selenium更强大，可以很方便地对网络请求进行拦截。
4. 使用与浏览器相同的语言，与浏览器衔接更好。



------

Puppeteer实际上为NodeJs的一个库，NodeJs部署也较为简单，首先到NodeJs官网

https://nodejs.org/en/配置好NodeJs环境。

之后可以在cmd中运行以下指令安装puppeteer库。

```bash
npm install puppeteer --save
```

##### npm介绍:

NPM是随同NodeJS一起安装的包管理工具，能解决NodeJS代码部署上的很多问题，常见的使用场景有以下几种：

- 允许用户从NPM服务器下载别人编写的第三方包到本地使用。
- 允许用户从NPM服务器下载并安装别人编写的命令行程序到本地使用。
- 允许用户将自己编写的包或命令行程序上传到NPM服务器供别人使用。

------

到此puppeteer环境就已经配置好了，如果要编写puppeteer相关的代码，那么还需要配置一下NodeJs的编程环境，可选的编程环境有

webstorm、(Visual Studio或者VSCode) + TypeScript。



官方API文档:https://zhaoqize.github.io/puppeteer-api-zh_CN/#/，请务必频繁查看此API文档。

#### Browser类

一个Browser可以理解成一个浏览器实例，这个类较为简单，使用Browser创建Page例子如下:

```js
const puppeteer = require('puppeteer');

puppeteer.launch().then(async browser => {
  const page = await browser.newPage();			//浏览器创建一个新标签页
  await page.goto('https://www.baidu.com');		//标签页导航到指定网址
  await browser.close();						//关闭浏览器
});
```

#### Page类

这个类最为关键，可能是要用到的最多的一个类。Page提供对单个标签页进行操作的方法，一个Browser实例可以有多个Page实例。



## 实际应用场景模拟

就以https://zhaoqize.github.io/puppeteer-api-zh_CN/#/这个网址为例吧，目标是爬取出这个网址中全部的文档内容。

#### 1、新建浏览器，定位到页面



