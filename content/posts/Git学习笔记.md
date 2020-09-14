---
title: "Git学习笔记"
date: 2020-08-23
tags: ["笔记" "git"]
categories: ["杂文"]
---

# Git学习笔记

### 克隆含有子模块的项目

当一个git项目含有子模块(submodule)时，直接克隆下来的子模块目录里面是空的。

这时可以在执行git clone时加上--recursive参数，它会自动初始化并更新每一个子模块，例如

```bash
git clone --recursive https://github.com/x64dbg/x64dbg.git
```



如果项目已经克隆到了本地，执行下面的步骤：

1.初始化本地子模块配置文件

```bash
git submodule init
```

2.更新项目，抓取子模块内容。

```bash
git submodule update
```



