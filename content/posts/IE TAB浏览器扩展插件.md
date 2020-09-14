---
title: "IE TAB浏览器扩展插件修改过程"
date: 2020-09-07
tags: ["浏览器扩展" "绿化"]
categories: ["逆向生涯"]
---

# IE TAB浏览器扩展插件修改过程

事情是这样的，我在使用Puppeteer框架对网站进行爬取的时候，发现有些页面使用到了ActiveX控件。众所周知，只有IE浏览器才支持ActiveX控件，而Puppeteer却不支持IE浏览器！这导致我在爬取的过程中页面无法正常加载，这样一来我也就截取不到我想要的一些请求了。

在尝试解决该问题的过程我了解到了IE TAB，IE Tab 是网页浏览器的一个扩展插件，支持Firefox/Chrome。

##### IE TAB应用场景:

有些网站页面格式不标准，或者使用到了ActiveX控件，只能在IE浏览器中正常显示。而这个时候我们又想在Chrome/FireFox浏览器中访问此网站，这个时候就可以使用IE TAB插件，此插件主要功能是通过调用Internet Explorer的引擎来访问网页，解决一些网页无法在当前标准的浏览器中正常显示的问题。

------

该软件安装使用可能要用到科学上网，软件分免费版和授权版两种。

免费版能满足普通用户的大部分使用需求，但是对选项进行设置需要进行联网。

授权版有着GPO组策略部署等更方便好用的功能(不知道是啥玩意。。。)。



于是我便打算对IE TAB进行个人修改(去除一些我不想要的功能，添加我想要的功能)。

## 知识点归纳

1.程序ietabhelper.exe会释放一个文件ietab_nm_manifest.json至目录C:\Users\fjqisba\AppData\Local\IE Tab下，同时在注册表SOFTWARE\Google\Chrome\NativeMessagingHosts\net.ietab.ietabhelper.peruser中写入该json文件路径。这样的目的其实是为了注册本地消息主机。

> **本地消息主机(Native messaging):**
>
> 通过将浏览器所在客户端的本地应用注册为**本地消息主机**，Chrome浏览器扩展可以和本地应用之间收发消息。
>
> 本地应用要想成为"本地消息主机"，必须有一个有效的json配置文件，例如:
>
> ```json
> {
> 	"name": "com.my_company.my_application",
> 	"description": "My Application",
> 	"path": "C:\\MyApplication.exe",
> 	"type": "stdio",
> 	"allowed_origins": [ "chrome-extension://ndbehkpfbjcaflobmibchkjiphgibnid/" ]
> }
> ```
>
> 其中path为本地应用的执行路径；allowed_origins为授权能够与本地消息主机进行通讯的浏览器扩展，不得有通配符。
>
> 之后在安装本地应用时需要在注册表中指明配置文件的路径，例如创建key
>
> HKEY_CURRENT_USER\SOFTWARE\Google\Chrome\NativeMessagingHosts\com.my_company.my_application
>
> 设置默认值Default为配置文件所在的绝对路径。

程序注册了本地消息主机，是为了让浏览器扩展和程序自带的ietabhelper.exe进行通讯，个人推测一些核心功能其实是在ietabhelper.exe中，例如调用IE浏览器引擎等。

很明显我们在重新打包扩展插件的时候，浏览器扩展插件的id会发生变化，因此我们需要修改配置文件中allowed_origins的内容，allowed_origins内容其实来源于ietabhelper.exe中，我们可以对该exe进行patch，加入我们自己的浏览器扩展插件id。



2.在nathost_manager.js中似乎对浏览器扩展ID还有判断，先不管对不对，加上自己的ID就完事了。

```js
_updateAllowedOrigins: function(manifestContent) {
        // hehijbfgiekmjfkfjpbkbammjbdenadd - Chrome Web Store release
        // knnoopddfdgdabjanjmeodpkmlhapkkl - IE Tab Enterprise edition
        // ncdgipmkgkhennagnfmnlkflidilhbdi - IE Tab Enterprise self-deployed
        // npjkkakdacjaihjaoeliacmecofghagh - Windows Store for Edge
        // almljgkjodjgoldenkijomojnejpkcjk - IE Tab Beta for Chrome
        var origins = [
            'chrome-extension://hehijbfgiekmjfkfjpbkbammjbdenadd/',
            'chrome-extension://knnoopddfdgdabjanjmeodpkmlhapkkl/',
            'chrome-extension://ncdgipmkgkhennagnfmnlkflidilhbdi/',
            'chrome-extension://npjkkakdacjaihjaoeliacmecofghagh/',
            'chrome-extension://almljgkjodjgoldenkijomojnejpkcjk/'
        ];
        var me = chrome.extension.getURL('');
        if ( (origins[0] != me) && (origins[1] != me)) {
            origins.push(me);
        }
        var cleanOrigins = JSON.stringify(origins);
        cleanOrigins = cleanOrigins.replace(/[\[\]]/g, '');
        return manifestContent.replace('ALLOWED_ORIGINS', cleanOrigins);
    },
```



3.在进行选项设置的时候，你需要访问http://www.ietab.net/options这个网址才行，其实就软件功能来说，理应可以实现完全本地化的，但是作者非要你访问他的官网，这里我们直接将options.html给离线存储下来，相应的服务器js、html、css也保存到本地，再修正一下HTML引用的文件URL。

之后我们还需要修改一下程序的配置，在manifest.json中有一个值为content_scripts，简要介绍如下:

> Content scripts是在Web页面内运行的javascript脚本。通过使用标准的DOM，它们可以获取浏览器所访问页面的详细信息，并可以修改这些信息。
>
> 下面是content scipt可以做的一些事情范例：
>
> 从页面中找到没有写成超链接形式的url，并将它们转成超链接。
> 放大页面字体使文字更清晰
> 找到并处理DOM中的microformat
> 当然，content scripts也有一些限制，它们不能做的事情包括 ：
>
> 不能使用除了chrome.extension之外的chrome.* 的接口
> 不能访问它所在扩展中定义的函数和变量
> 不能访问web页面或其它content script中定义的函数和变量
> 不能做cross-site XMLHttpRequests
> 这些限制其实并不像看上去那么糟糕。Content scripts 可以使用messages机制与它所在的扩展通信，来间接使用chrome.*接口，或访问扩展数据。Content scripts还可以通过共享的DOM来与web页面通信。

总之，可以理解为一个页面注入js，而IE TAB存在这么一个配置

```json
content_scripts": 
[ 
	{
      "js": [ "js/extapi_cs.js" ],
      "matches": [ "*://*.ietab.net/*" ],
      "run_at": "document_start"
    } 
]
```

意思就是，程序在访问http://www.ietab.net/options这个网址时，便会注入extapi_cs.js这个js，这个js非常关键，涉及到核心功能之间的相互通讯，如果没有的话那么功能会无法执行起来。由于我们本地化了options.html，因此我们也需要注入这个js，其实方式也很简单，我们可以直接在options.html中加入下列代码

```html
<script src="js/extapi_cs.js"></script>
```

这样便完成了和原程序一样的注入。



4.软件使用到了localStorage来存储配置选项信息+授权信息，在Settings.js中存在以下代码，为程序加载的一些默认项

> localStorage为浏览器的本地存储机制，存储时间理论上来说是永久有效的，即不主动清空的话就不会消失，即使保存的数据超出了浏览器所规定的大小，也不会把旧数据清空而只会报错。

```
DEFAULT_SETTINGS: {
	'compat-mode': 'IE7S',
	'disable-intro-page': false,
	'enable-auto-urls': true,
	'enable-chrome-popups': true,
	'settings-refresh-interval': 1000*60*10,    // Every 10 minutes
	'show-search-box': false,
	'enable-use-full-window-popups': true,
	'enable-dep': true,
	'enable-atl-dep': true,
	'only-auto-urls' : false,
	'hide-addr-bar' : false,
	'show-status-text' : false,
	'open-popups-in-tab': false,
	'allow-api-prompt': true,
	'enable-direct-invoke': false,
	'scripturl-mitigation': true,
	'cookie-sync': false,
	'single-session': false,
	'local-network': false,
	'favicon': false,
	'beforeunload': false,
	'ietab-header': false,
	'threaded-popups': false,
	'ie-dialogs': true,
	'show-context-menu': true
},
```

我们通过拜读js源码得知直接在里面添加以下代码，就完成了授权的破解

```
'licensee': 'fjqisba',
'license-key': 'https://bbs.pediy.com/'
```



5.根据程序名称，留意到程序似乎有一个检测函数licensePing，作用推测是每天定时向服务器发送License，判断是否有效，无效则取消Lincense，我们直接return即可。



**总结**:通过对该浏览器扩展插件进行学习，也接触了一些关于浏览器插件开发的知识，在理解了作者编写的js源码的情况下，就可以对程序进行一些个人化的修改。

**后记**:该插件其实最后并没有用上，因为我采用了另外一种解决方案——通过正则表达式探测HTML页面中的链接地址得到了想要的请求链接。



耗时总共5小时。

## 参考资料

http://open.chrome.360.cn/extension_dev/overview.html

