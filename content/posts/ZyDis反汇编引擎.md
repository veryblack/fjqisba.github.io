---
title: "ZyDis反汇编引擎"
date: 2020-08-16
tags: ["反汇编引擎"]
categories: ["杂文"]
---
# ZyDis反汇编引擎

Zydis是一个开源的反汇编引擎，项目地址如下:

https://github.com/zyantific/zydis



### 配置ZyDis库

1.克隆存储库，得到Zydis源码。

2.由于笔者使用的是Windows平台下的**Visual Studio**环境，因此可以直接运行源码目录zydis\msvc\Zydis.sln的工程。

3.在工程中编译库，大致分为DLL动态库或者静态库两种方式，笔者比较喜欢静态编译的方式，因此工程配置选择Release MT，编译x86和x64两个版本的库。

4.提取出include头文件和lib文件，即得到反汇编引擎库。

或者直接点击此[下载](https://github.com/fjxisba/GithubDropBox/releases/download/Zydis/Zydis.7z)



### 使用Zydis库

新建一个测试工程

1.附加包含目录中添加Zydis\include

2.附加库目录视编译平台选择Zydis\lib\X86或者Zydis\lib\X64

3.附加依赖项中添加Zycore.lib和Zydis.lib

4.预处理器定义中添加两行

```
ZYCORE_STATIC_DEFINE
ZYDIS_STATIC_DEFINE
```



编写代码进行测试，可以正常地使用Zydis库函数，则代表反汇编引擎配置成功!