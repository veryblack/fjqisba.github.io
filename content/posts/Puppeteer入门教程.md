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



//To do...为什么选择Puppeteer



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

到此puppeteer环境就已经配置好了，如果要编写puppeteer相关的代码，那么还需要配置一下NodeJs的编程环境:

- 新手推荐使用webstorm
- 老鸟推荐使用VSCode
- 大神可以直接使用记事本来编写代码，使用命令行node xx.js来运行。

官方入门的 DEMO如下:

```js
const puppeteer = require('puppeteer');
 
(async () => {
 const browser = await puppeteer.launch();
 const page = await browser.newPage();
 await page.goto('https://www.baidu.com');
 await page.screenshot({path: 'example.png'});
 
 await browser.close();
})();
```

运行上面这段JS后，便会在目录下生成百度页面的截图了。

