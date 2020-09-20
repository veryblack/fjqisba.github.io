---
title: "Puppeteer入门教程"
date: 2020-09-01
tags: ["Puppeteer","自动化","模拟","入门教程"]
categories: ["爬虫"]
---

# Puppeteer入门教程

Puppeteer，木偶框架，是谷歌开源的一个浏览器控制框架。它提供了一组可以用来操控Chrome的API，使得我们可以很方便地进行一些浏览器模拟、自动化操作，例如:

1. 生成网页截图或者 PDF
2. 高级爬虫，爬取大量异步渲染内容的网页
3. 模拟键盘输入、表单自动提交、登录网页等，实现 UI 自动化测试
4. 捕获站点的时间线，以便追踪网站，帮助分析网站性能问题



至于为什么选择Puppeteer，而不使用Selenium、CEF等其它框架来模拟浏览器操作，是因为Puppeteer有以下优点:

- Puppeteer是站在用户使用的角度上来设计操作接口，而不是浏览器的角度，使用起来较为简单、更人性化
- 由Chrome官方团队进行维护，拥有更好的前景
- 功能比Selenium更强大，可以很方便地对网络请求进行拦截
- 使用与浏览器相同的语言，与浏览器衔接更好



Puppeteer同样也有缺点，缺点如下:

- 只支持Chrome、FireFox浏览器，不支持IE浏览器
- 只支持NodeJs、C#两种语言



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

webstorm、Visual Studio、VSCode等。这里笔者使用的是Visual Studio，不要问我为什么，Visual Studio天下第一！



不过在使用Visual Studio的时候，可能会出现一点问题，例如以下代码

```js
 var 百度主页 = "https://www.baidu.com";
```

Visual Studio将无法编译通过，这是因为Visual Studio中的源码默认字符集设置问题，需要将字符集编码改为UTF-8。

但是VS 2019隐藏了高级保存功能，导致没办法直接去设置代码编码为UTF-8。具体开启步骤参考如下:

1. 单击“工具”|“自定义”命令，弹出“自定义”对话框。
2. 单击“命令”标签，进入“命令”选项卡。
3. 在“菜单栏”下拉列表中，选择“文件”选项。
4. 单击“添加命令”按钮，弹出“添加命令”对话框。
5. 在“类别”列表中，选择“文件”选项；在“命令”列表中，选择“高级保存选项”选项。 单击“确定”按钮，关闭“添加命令”对话框。
6. 选中“控件”列表中的“高级保存选项”选项，单击“上移”或者“下移”按钮，调整该命令的位置。
7. 单击“关闭”按钮，完成“高级保存选项”命令的添加操作。

之后我们就可以通过**高级保存选项**来设置源码的字符集编码了。

------

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

就以爬取百度搜索结果为例吧，目标是爬取出指定搜索结果。

#### 1、新建浏览器，定位到页面

