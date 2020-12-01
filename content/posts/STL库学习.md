---
title: "STL库学习"
date: 2020-09-24
tags: ["STL"]
categories: ["C++逆向"]
---

C++存在非常令人头疼的STL模板库，如果不去了解它的话，还原C++代码又会特别吃力。。。

不同的VC版本或者Debug\Release版，STL库都可能有一定的差别。



这里以VS2017 Release版本为示例:

##### String(大小0x18)

```c
struct string
{
	Union _Bxty
    {
        char _Buf[16];
        char* _Ptr;
    }
    size_t _Mysize;		//字符串长度
    size_t _Myres;		//最大字符串长度
};
```



##### Vector(大小0xC)

```c
struct vector
{
	T* _Myfirst;	//数组起始地址
	T* _Mylast;
	T* _Myend;
};
```



##### Map(大小0x8)

```c
struct map
{
	Tree_nod* _MyHead;
	unsigned int _Mysize;
};
```

##### Tree_nod(大小0x10 + 键值对)

```c
struct __declspec(align(4)) Tree_nod
{
    Tree_nod* _Left;
    Tree_nod* _Parent;
    Tree_nod* _Right;
    char _Color;
    char _Isnil;
    map_pair _Myval;			//键值对
};
```



#### List(大小0x8)

```c
struct list
{
	List_node* _MyHead;
	unsigned int _Mysize;
}
```

#### List_node(大小0x8 + 值):

```c
struct __declspec(align(4)) List_node
{
	List_node* _Next;
    List_node* _Prev;
    int _Myval;		//值
}
```

list->MyHead->Next为list.front();

list->MyHead->Prev为list.back();