[toc]

本章要点

- Win32控制台编程
- 编写Windows图形界面应用程序
- 动态内存分配
- IA-32内存管理

# 11.1 Win32 控制台编程

在阅读本章的过程中，读者最好能随时提醒自己思考以下的问题：

- 32位程序如何进行文本的输入和输出？
- 32位控制台模式下如何处理文本颜色？
- Irvine32库是如何工作的？
- Windows下如何处理时间和日期？
- 如何使用MS-Windows函数读写数据文件？
- 使用汇编能写出图形界面的Windows应用程序吗？
- 在保护模式下，如何把段地址和偏移地址转换成物理地址？
- 为什么虚拟内存能带来诸多好处？

在讲述MS-Windows32位编程基础知识的过程中，本章将回答上面这些（甚至于更多的）问题。在了解了一些数据结构和参数相关的知识之后，控制台程序是相当容易编写的，这就是为什么本章讨论的是Win32编程，而大部分的内容却是和文本模式的控制台程序相关的原因。Irvine32链接库是完全基于Win32控制台函数实现的，因此读者可以把它的源代码和本章中的相关内容进行对比。Irvine32链接库的源代码可在本书附带代码的\Examples\Lib32目录下找到。
为什么不从我们平常在Windows下看到的图形界面的窗口应用程序开始学习呢？最主要的原因是：这样会涉及繁多的技术细节，汇编语言或C语言编写的图形界面应用程序穴长而复杂。即使在一些优秀作者的帮助下，C和C+程序员们还是年复一年地为搞清楚图形设备句柄、消息传递、字体的度量、设备位图和映射模式等各种技术细节而感到吃力。事实上，在因特网上有很多汇编爱好者很擅长Windows图形界面编程，作者已经对他们的网站进行了链接，参见本书网站（www.asmirvine.com)上Assembly Language Sources部分的链接。
但是希望了解图形界面编程的读者也不必感到失望，11.2节介绍了一些这方面的知识。虽然这仅仅只是个开始，但可能对读者以后深人这些主题会有所启发。在11.5节中，也列出了用于深入了解这方面内容的一些参考文献。
从表面看，32位的控制台程序和16位的MS-DOS文本应用程序在外观和行为上都是很相似的。不过事实上，32位控制台程序和MS-DOS程序还是有一些不同：前者在保护模式下运行，后者在实模式下运行。它们使用的是完全不同的函数库，Win32控制台程序使用的就是Windows图形界面程序使用的那些库文件，而MS-DOS程序使用的是BIOS和MS-DOS中断，这些中断在出现IBM-PC的那个年代就已经在使用了。

应用程序编程接口（API,Application Programming Interface)是一些类型、常量和函数的集合，它提供了直接通过编程操纵对象的途径。
Win32平台软件开发包（Win32 Platform SDK):和Win32API有紧密联系的是Microsoft Platform SDK,SDK的含义是软件开发包（Software Development Kit),这是一些用于创建Windows应用程序的工具软件、库文件、代码例子和帮助文档的集合。完整的文档也可以在Microsoft的网站上找到，可在www.msdn.microsoft.com上搜索“Platform SDK”。下载Platform SDK是免费的。
提示：Irvine32链接库和Win32API是兼容的，因此在程序中可以同时调用Irvine32库中的函数和Win32API中的函数。

## 11.1.1 背景知识

当一个Windows应用程序开始运行的时候，它可以创建一个控制台窗口，也可以创建一个图形化的窗口。可以在项目文件中为LINK命令指定下面的命令行选项，该选项通知链接器创建于控制台的应用程序：

```assembly
/SUBSYSTEM:CONSOLE
```

接下来可以看到，控制台程序的外观和行为看起来就像一个增强版的MS-DOS窗口程序。每个控制台程序有一个输入缓冲区、一个或者多个屏幕缓冲区：

- ==输入缓冲区中包含了一个输入记录队列，每个输入记录都包含了一个输入事件的相关数据。输入事件包括键盘输入、鼠标单击或者用户在改变控制台窗口等事件。==
- ==屏幕缓冲区是一个包含了字符和颜色数据的二维数组，这些数据控制着控制台窗口中显示的文本的外观。==

### Win32API的参考信息

#### 函数

本章只能介绍一部分Win32API函数并给出一些简单的示例，由于篇幅所限，很多细节不能一一涉及。要查阅更多相关的内容，可以在Microsoft Visual C++ Express内单击帮助菜单或在线访问 Microsoft MSDN站点（当前的网址是www.msdn.microsoft.com)。在搜索函数或标识符时，应把过滤条件参数(“Filtered by”)设为“Platform SDK”。在本书附带的例子代码中，kernel32.txt和user32.txt两个文件分别列出了kernel32.lib和user32.lib两个库中全部函数的名字。

#### 常量

在阅读Win32API中的函数文档时，经常会遇到一些常量名，比如TIME_ZONE_ID_UNKNOWN,这类常量有的已经在SmallWin.inc中定义了。如果在SmallWin.inc中找不到定义，那么可以查阅本书网站上最新版本的SmallWin.inc是否已经包含了该定义。如果依旧没有找到，那么可以参考SDK中的相关头文件。例如，头文件WinNTh中定义了TIME_ZON_ID_UNKNOWN以及其他一些相关的常量：

```c
#define TIME_ZONE_ID_UNKNOWN	0
#define TIME_ZONE_ID_STANDARD	1
#define TIME_ZONE_ID_DAYLIGHT 	2
```

使用类似上面的信息，就可以在SmallWin.inc或自己的头文件中增加常量定义了，如：

```c
TIME_ZONE_ID_UNKNOWN  = 0
TIME_ZONE_ID_STANDARD = 1
TIME_ZONE_ID_DAYLIGHT = 2
```

### 字符集和WindowsAPI函数

#### Win32 API函数使用两种字符集

8位的ASCII/ANSI字符集和16位的Unicode字符集（在Windows NT/2000/XP中提供）。用于处理文本的Win32API函数往往提供了两个不同的版本：个版本的函数名是以A结尾的（用于8位ANSI字符集）;另一个版本的函数名是以W结尾的（用于16位的宽字符集，包括==Unicode字符集==）。以WriteConsole函数为例，两个不同版本的函数名如下所示：

- WriteConsoleA
- WriteConsoleW

Windows 95/98操作系统不支持以W结尾的函数名。在Windows NT/2000/XP操作系统中Unicode是内置的字符集，在这些系统中如果调用WriteConsoleA函数，操作系统首先把ANSI字符转换成Unicode字符，然后再去调用WriteConsoleW函数。
在MSDN文档中，函数名（如WriteConsole)尾部的A或者W省略掉了。在本书例子程序使用的include文件中，使用下面的方式对函数名重新定义：

```assembly
WriteConsole EQU <WriteConsoleA>
```

这样就可以通过正常的函数名来调用WriteConsole函数了。

### 高级操作和底层操作

对控制台可以有两种层次的操作，使用者可以在简易性和全面性之间折衷选择：

- 高级操作函数从输入缓冲区中读取字符流，输出字符则被写到屏幕缓冲区中输入和输出都可以被重新定向到对一个文本文件的读写操作中。
- 底层操作用来获取键盘和鼠标操作的详细信息，以及用户和控制台窗口的交互动作（如动窗口、改变窗口大小等）。通过底层操作，也可以对控制台窗口的位置和大小、窗口中的字符颜色进行控制。

### Windows的数据类型

在文档中，Windows API函数的声明以C/C++的语法形式出现，在这些声明中，所有函数的参数类型都是基于标准C的数据类型或者Windows的预定义类型的（如表11.1所示）。正确区数据类型中的数据值和数据值指针是很重要的，这些数据类型中以LP开头的都是指向其他对象的长指针。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.7rcx4uuytu8.webp)

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.71cxmo2110s0.webp)

### SmallWin.inc包含文件

SmallWin.inc文件是本书作者创建的，其中包含了用于Win32API编程的常量定义、文本宏和函数原型。本书例子代码自始至终在使用的Irvine32.inc就包含了该文件，因此任何包含了Irvine32.inc的程序都自动包含了SmallWin.inc。如果安装了本书附带的例子代码，则可以在\Examples\Lib32目录下找到该文件，其中的大多数常量定义都可以在用于C/C++编程的SDK头文件Windows.h中找到。与SmallWin.inc这个名字的含义截然相反，该文件非常大，因此这里只给出一些示例：

```assembly
DO_NOT_SHARE = 0
NULL  = 0
TRUE  = 1
FALSE = 0
; Win32 Console handles
STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11
STD_ERROR_HANDLE EQU -12
```

==HANDLE类型实际上是DWORD类型的别名==，有助于使汇编语言的函数原型声明与MicrosoftWin32文档中给出的尽量一致：

```assembly
HANDLE TEXTEQU <DWORD>
```

SmallWin.inc中也包含了Win32调用中使用的结构的定义，下面是两个例子：

```assembly
COORD STRUCT
	X WORD ?
	Y WORD ?
COORD ENDS
SYSTEMTIME STRUCT
	wYear 		WORD 	?
	wMonth 		WORD 	?
	wDayOfWeek 	WORD 	?
	wDay 		WORD 	?
	wHour 		WORD 	?
	wMinute 	WORD 	?
	wSecond 	WORD 	?
	wMilliseconds WORD 	?
SYSTEMTIME ENDS
```

最后要说明的是，SmallWin.inc中包含了本章介绍的所有Win32函数的原型声明。

### 控制台句柄

几乎所有的控制台函数都要求把控制台句柄作为第一个参数传递给它们，句柄是一个32位的无符号整数，唯一地标识了一个对象：如位图、画笔或者某个输入输出设备等。在这里我们可以使用下列句柄：

```assembly
STD_INPUT_HANDLE	;标准输入句柄
STD_OUTPUT_HANDLE	;标准输出句柄
STD_ERROR_HANDLE	;标准错误输出句柄
```

后面两个句柄用于向当前活跃的屏幕缓冲区输出数据。
GetStdHandle函数用于获取一个对应控制台输入、输出或者错误输出流的句柄，在控制台程序中进行任何的输入输出操作都需要用到这样一个句柄，这里是函数原型：

```assembly
GetStdHandle PROTO,
		nStdHandle:HANDLE	;句柄的类型
```

nStdHandle参数可以是STD_INPUT_HANDLE,STD_OUTPUT_HANDLE或者STD_ERROR_HANDLE。函数在EAX中返回句柄，应该把它复制到一个变量中保存起来。下面是调用示例：

```assembly
.data
inputHandle DWORD?
.code
INVOKE GetStdHandle,STD_INPUT_HANDLE
		 mov inputHandle,eax
```

## 11.1.2 Win32控制台函数

表11.2是所有Win32控制台函数的速查列表，可以在MSDN网站（www.msdn.microsoft.com)中找到这些函数的完整说明。
提示：Win32API函数不保护EAX,EBX,ECX,EDX寄存器，因此必须自己保护这些
寄存器。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.36kh5u8pnsu0.webp)

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.o80ht4rc7qo.webp)

## 11.1.3显示消息框

在Win32程序中产生输出的最简单方法之一就是调用MessageBoxA函数：

```
MessageBoxA PROTO,
hWnd:DWORD,
;窗口句柄（可以为空）
1pText:PTR BYTE,
;消息框内的字符串
1pCaption:PTR BYTE,
;对话框标题字符串
uType:DWORD
;内容和行为类型
```

在基于控制台的应用程序中，可以把hWnd设为NULL,以表示消息框没有所有者；IpText参数是要显示在消息框内的（空字符结尾的）字符串的指针；lpCaption参数是要显示的对话框标题字符串（空字符结尾的）的指针；uType参数指定对话框的内容和行为。

#### 对话框的内容和行为：

uType参数是一个位映射整数，包含了三类选项：要显示的按钮、图标以及默认的按钮。可显示按钮的可能组合值如下：

- ·MB_OK
- ·MB_OKCANCEL
- ·MB_YESNO
- ·MB_YESNOCANCEL
- ·MB_RETRYCANCEL
- ·MB_ABORTRETRYIGNORE
- ·MB_CANCELTRYCONTINUE

#### 默认按钮：

可以指定在用户按下Enter键时自动选择哪个按钮。可用的选项包括MB_DEFBUTTON1(默认）,MB_DEFBUTTON2,MB_DEFBUTTON3和MB_DEFBUTTON4。按钮是从左到右计数的，第一个按钮的计数是1。

#### 图标：

有4类图标可以选用，有时候多个常量表示同样的图标：

- ·停止标志：MB_ICONSTOP,MB_ICONHAND和MB_ICONERROR。
- ·问号（?):MB_ICONQUESTION。
- ·信息（i):MB_ICONINFORMATION,MB_ICONASTERISK。
- ·惊叹号（!):MB_ICONEXCLAMATION,MB_ICONWARNING。

#### 返回值：

如果MessageBoxA失败，返回0,否则返回一个整数，指明在关闭对话框时用户点击了哪个按钮，相关的常量包括：IDABORT,IDCANCEL,IDCONTINUE,IDIGNORE,IDNO,
IDOK,IDRETRY,IDTRYAGAIN和IDYES。所有这些常量都在SmallWin.inc中定义了。
SmallWin.inc把MessageBoXA重新定义为MessageBox,后者看起来对用户更友好一些。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.wbnwpa5rg5c.webp)

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.2g57rwxy4nbw.webp)

#### 程序清单：

下面是程序的清单，由于MessageBox是MessageBoxA的别名，因此程序中使用了前者：

```
TITLE Demonstrate MessageBoxA
(MessageBox.asm)
INCLUDE Irvine32.inc
.data
captionw BYTE."Attempt to Divide by Zero",0
warningMsg BYTE "Please check your denominator.",0
captionQ BYTE "Question",0
questionMsg BYTE "Do you want to know my name?",0
showMyName BYTE "My name is MASM", Odh, Oah, 0
captionC BYTE "Information",0
infoMsg BYTE "Your file was erased . " , Odh , Oah
BYTE "Notify system admin, or restore backup?",0
.code
main PROC
;显示一条警告信息
INVOKE MessageBox, NULL, ADDR warningMsg,
ADDR captionw,
MB_OK+MB_ICONEXCLAMATION
;询问一个问题，等待回应
INVOKE MessageBox, NULL, ADDR questionMsg,
ADDR captionQ,MB_YESNO+MB_ICONQUESTION
cmp eax,IDYES
;单击了YES按钮？
jne L2
;如果没有，则跳走
;向控制台窗口写名称
mov edx, OFFSET showMyName
call WriteString
L2:
;更复杂的按钮，可能会让用户迷惑
INVOKE MessageBox, NULL, ADDR infoMsg,
ADDR captionC,MB_YESNOCANCEL+MB_ICONEXCLAMATION\
+MB_DEFBUTTON2
exit
main ENDP
END main
```

如果想让对话框位于桌面上所有其他窗口之上，那么可以在最后一个参数uType中多传递一个（或操作）MB_SYSTEMMODEL选项。

## 11.1.4控制台输入

到现在为止，我们已经数次用到ReadString和ReadChar过程，这两个过程是由本书附带的链接库提供的，它们的使用相当简单，这样读者就可以把注意力集中在其他问题上了。这两个过程都是对Win32API函数ReadConsole的封装（封装过程隐藏了被封装过程中的一些细节）。

### 控制台输入缓冲区：

Win32控制台有一个输入缓冲区，其中包含一个输入动作记录的队列，每个输入动作，如键盘敲击、鼠标移动、按下鼠标键等，都会在缓冲区中产生一条记录。高级操作函数如ReadConsole等过滤并处理这些输入数据，只返回字符流。

#### ReadConsole函数

ReadConsole函数提供了一种把文本输入读取到一个缓冲区中的便捷方法，函数原型如下：

```
ReadConsole PROTO,
hConsoleInput:HANDLE,
;输入句柄
1pBuffer:PTR BYTE,
;缓冲区地址指针
nNumberofCharsToRead:DWORD,
;要读取的字符数量
1pNumberOfCharsRead:PTR DWORD
;指向返回实际读取数量大小的指针
1pReserved:DWORD
;(保留）
```

hConsoleInput参数是一个由GetStdHandle函数返回的有效输入句柄；IpBuffer参数指向一个字符缓冲区；nNumberOfCharsToRead参数是一个32位的整数，指定了要读取字符的最大数量；IpNumberOfCharsRead参数是指向一个双字变量的指针，函数运行时会填写该变量，它返回实际读取到缓冲区中的字符数量。最后一个参数未使用，使用时要传递一个数值（比如0)。
除了用户的输入以外，调用ReadConsole读入输入缓冲区中的文本还包含两个额外的字符行结束字符（回车和换行符）。欲使输入缓冲区中的文本以0结尾，那么应该把包含0Dh(回车）的字节替换为0,ReadString过程就是这样做的。
注：Win32API函数不保留EAX,EBX,ECX和EDX寄存器。
例子程序：设想一下，我们要写一个程序来读取用户输人的字符。首先，需要调用GetStdHandle函数获取控制台的标准输入句柄，然后使用这个句柄调用ReadConsole函数。下面的程序ReadConsole.asm演示了这项技术。注意，Win32API函数调用和对Irvine32库过程的调用是可以共存的，因此，下面的代码在调用Win32API的同时还调用了DumpMem过程：

```
TITLE Read From the Console
(ReadConsole.asm)
INCLUDE Irvine32.inc
BufSize=80
.data
buffer BYTE BufSize DUP(?),0,0
stdInHandle HANDLE?
bytesRead DWORD ?
.code
main PROC
;获取标准输入的句柄
INVOKE GetStdHandle,STD_INPUT_HANDLE
mov stdInHandle,eax
;等待用户输
INVOKE ReadConsole, stdInHandle, ADDR buffer,
BufSize-2,ADDR bytesRead,0
;显示缓冲区的内容
mov esi, OFFSET buffer
mov ecx,bytesRead
mov ebx, TYPE buffer
call DumpMem
exit
main ENDP
END main
```

如果用户输入了“abcdefg”，程序将产生下面的输出。输入缓冲区中包含了9个字符："abcdefg"以及0Dh和0Ah,行结束符（0Dh,0Ah)是用户按下回车键时输入缓冲区的。在这个例子中，bytesRead等于9。

```
Dump of offset 00404000
616263646566670D0A
```

### 错误的检查

如果WidnowsAPI函数返回了一个出错值（如NULL),可以调用GetLastError API函数获取关于该错误的更多信息。GetLastError在EAX中返回一个32位的错误码（一个整数）:

```
.data
messageId DWORD ?
.code
call GetLastError
mov messageId,eax
```

MS-Windows有成千上万个错误码，一个人不可能记住所有错误码的含义，因此这时获取能够描述该错误码含义的字符串就非常有意义了，这可以通过调用FormatMessage函数做到：

```
FormatMessage PROTO,
;格式化一条消息
dwFlags:DWORD,
;格式化选项
1pSource:DWORD,
;消息定义的位置
dwMsgID:DWORD,
;消息ID
dwLanguageID:DWORD,
;语言ID
1pBuffer:PTR BYTE,
;指向接收字符串缓冲区的指针
nSize:DWORD,
;缓冲区的大小
va_list:DWORD
;参数列表的指针
```

参数有些复杂，因此必须阅读SDK文档，以获取其全貌。以下是最有用的值的简要描述。除了lpBuffer为输出参数外，其余均为输入参数。

- dwFlags,一个双字整数，用于存放格式化选项，如应该如何解释1pSource参数。这个参
- 数指定了应如何处理换行以及格式化后的输出行的最大宽度，推荐的选项值FORMAT_MESSAGE_ALLOCATE_BUFFER和FORMAT_MESSAGE_FROM_SYSTEM。
- · IpSource,指向消息定义的位置的指针，对于上面推荐的 dwFlags 选项值，应把该值设为NULL(0)。
- ·dwMsgID,调用GetLastError返回的双字整数值。
- ·dwLanguageld,语言标识符。如果该值为0,则消息的语言是中性的，也就是说消息的语言是用户的默认本地语言
- · IpBuffer,指向接收消息字符串缓冲区的指针，这是一个输出参数。如果 dwFlags 指定了FORMAT_MESSAGE_ALLOCATE_BUFFER选项，输出缓冲区将自动分配，这个参数也就无须指定了。
- nSize,指定用于存放消息字符串的lpBuffer指向的缓冲区的大小。如果dwFlags指定了
- FORMAT_MESSAGE_ALLOCATE_BUFFER选项，则该参数可以传递0。
- ·va_list,要插入到格式化后消息内的值的列表。由于我们通常不格式化出错消息，因此该参数可设为0。

下面是FormatMessage函数的调用示例：

```
.data
messageId DWORD ?
pErrorMsg DWORD ?
;指向错误消息
.code
call GetLastError
mov messageId,eax
INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER+\
FORMAT_MESSAGE_FROM_SYSTEM,NULL,messageID,0,
ADDR pErrorMsg, 0, NULL
```

如果dwFlags指定了FORMAT_MESSAGE_ALLOCATE_BUFFER选项，那么在调用FormatMessage函数之后，还要调用LocalFree释放FormatMessage分配的内存：

```
INVOKE LocalFree, pErrorMsg
```

WriteWindowsMsg过程：本书链接库中包含了下面的WriteWindowsMsg过程，封装了API
函数调用的细节：

```assembly
WritewindowsMsg PROC USES eax edx
:Displays a string containing the most recent error
; generated by MS-Windows.
Receives:nothing
:Returns:nothing
data
WritewindowsMsg_1 BYTE"Error",0
WritewindowsMsg_2 BYTE":",0
pErrorMsg DWORD ?
;指向错误消息
messageId DWORD ?
. code
call GetLastError
mov messageId, eax
;显示出错码数字
mov edx, OFFSET WriteWindowsMsg_1
call writestring
call WriteDec
mov edx, OFFSET WriteWindowsMsg_2
call writestring
;获取对应的消息字符串
INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER+\
FORMAT_MESSACE_FROM_SYSTEM,NULL,messageID,NULL,
ADDR pErrorMsg, NULL, NULL
;显示MS-Windows产生的错误消息
mov edx,pErrorMsg
call WriteString
;释放错误消息字符串占用的内存
INVOKE LocalFree, pErrorMsg
ret
WritewindowsMsg ENDP
```

### 单字符的输入

在控制台下进行单字符输入需要一点技巧。MS-Windows为当前安装的键盘提供了一个设备驱动程序，在按键按下的时候，一个8位的扫描码被送到键盘端口；在按键释放时，又有一个扫描码被送到键盘端口。MS-Windows使用设备驱动把扫描码转换成16位的虚拟键码（virtual-key code)。虚拟键码是MS-Windows定义的设备相关的值，用于标识按键的功用。MS-Windows将创建一个包含了按键的扫描码、虚拟键码以及其他相关信息的消息，然后把这个消息放在Windows消息队列中，最后通过某种方式送达当前正在执行程序的线程（这里用控制台输入句柄标识）。如果想了解键盘输入过程方面的更多信息，请阅读Platform SDK文档中的主题“About Keyboard Input”。要想查看虚拟键码常量值列表，可参看本书附带代码\Exampleslchll目录下的VirtualKey.inc文件。
Irvine32库中键盘相关的过程：Irvine32库中有两个与键盘相关的过程：

- ReadChar等待键盘输入一个ASCII字符并在AL中返回该字符。
- ·ReadKey过程检查键盘输入，但不等待。如果键盘输入缓冲区中没有按键，零标志置位；如果输入缓冲区中有按键，则零标志清零并且在AL中返回0或按键的ASCII码。EAX和EDX的高半部分会被改写。

ReadKey过程返回时，如果AL中返回的是0,则表明按下的是一个特殊的键（功能键、光标键等）,AH寄存器中包含了按键的扫描码，在本书的前言部分可以找到特殊按键的扫描码表。DX中包含了虚拟键码，EBX包含了键盘控制键的状态信息。在调用ReadKey后，可以使用TEST指令检查各个特殊键的值。ReadKey的实现有点穴长，这里就不再重复给出其代码了，感兴趣的读者可自行查阅\Examples\Lib32目录下的Irvine32.asm文件中的相应代码。键盘控制键的状态值如表11.3所示。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.9xu1sb87b4w.webp)

ReadKey测试程序：下面的程序测试ReadKey,程序使用一个循环延时等待按键，然后报告是否按下了CapsLock键。正如第5章所提到的，应该延时以留给MS-Windows处理消息循环的时间。

```
TITLE Testing ReadKey
(TestReadkey.asm)
INCLUDE Irvine32.inc
INCLUDE Macros . inc
.code
main PROC
L1:mov eax,10
;为消息处理延时
call Delay
call ReadKey
;等待按键
jz L1
test ebx, CAPSLOCK_ON
jz L2
mwrite < " CapsLock is ON " , odh , 0ah >
jmp L3
L2: mWrite &lt;"CapsLock is OFF", Odh, Oah&gt;
L3:exit
main ENDP
END main
```

### 获取键盘状态

调用GetKeyStateAPI函数可以测试单个按键的状态，查看其是否正被按下。函数原刑如下.

```
GetKeyState PROTO, nVirtKey: DWORD
```

调用GetKeyState时，应传递一个要检查按键的虚拟键码，在函数返回后，应测试EAX中的相应位是否置位了。一些虚拟键码值以及应检查的对应数据位如表11.4所示。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.5h1r9dqxpvo0.webp)

下面的例子程序演示了GetKeyState的用法，程序检查了NumLock和左Shift按键的状态：

```
TITLE Keyboard Toggle Keys
(Keybd.asm)
INCLUDE Irvine32.inc
INCLUDE Macros . inc
; GetKeyState sets bit 0 in EAX if a toggle key is
; currently on ( CapsLock , NumLock , ScrollLock ) .
; Sets bit 15 in EAX if another specified key is
; currently down .
.code
main PROC
INVOKE GetKeyState,VK_NUMLOCK
test al , 1
.IF !Zero?
mWrite < " The NumLock key is ON " , Odh , Oah >
.ENDIF
INVOKE GetKeyState,VK_LSHIFT
test al,80h
.IF !Zero?
mwrite < " The Left Shift key is currently DOWN " , Odh , Oah >
.ENDIF
exit
main ENDP
END main
```

## 11.1.5控制台输出

在前面的章节中，我们尽量使控制台输出尽可能简单，第5章中介绍的Irvine32链接库中的WriteString过程只要求一个参数：通过EDX传递的字符串地址。事实上，WriteString过程是对Win32函数WriteConsole的封装，调用后者时处理的细节要更多一些。
不过本节还是要讲述如何直接调用WriteConsole和WriteConsoleOutputCharacter等Win32函数，直接调用这些函数需要了解更多的细节，但比使用Irvine32中的过程灵活性更大。

### 相关的数据结构

一些Win32控制台函数使用预定义的数据结构，如COORD和SMALL_RECT结构。COORD
结构用于存放字符在控制台屏幕缓冲区中的坐标，坐标系的原点（0,0)在屏幕的左上角：

```
COORD STRUCT
X WORD ?
Y WORD ?
COORD ENDS
```

SMALL_RECT结构用于存放矩形区域的左上角和右下角坐标，它指定了控制台窗口中的一块矩形区域：

```
SMALL_RECT STRUCT
Left WORD ?
Top WORD ?
Right WORD ?
Bottom WORD ?
SMALL_RECT ENDS
```

### WriteConsole函数

WriteConsole函数在控制台窗口中的当前光标位置显示一个字符串并前进光标，支持标准的ASCII控制字符，如制表符、回车、换行符等。要显示的字符串不必以0结尾。函数原型如下：

```
WriteConsole PROTO,
hConsoleOutput:HANDLE,
1pBuffer:PTR BYTE,
nNumberOfCharsToWrite:DWORD,
1pNumberOfCharsWritten:PTR DWORD,
1pReserved:DWORD
```

第一个参数hConsoleOutput是控制台输出的句柄；第二个参数IpBuffer是指向要显示的字符串的指针；第三个参数 nNumberOfCharsToWrite指定了要显示的字符串的长度；第四个参数IpNumberOfCharsWritten指向一个整数变量，函数通过该变量返回实际输出的字符数量；最后一个参数是保留未用的，在使用的时候把它设置为0。

#### 例子程序：Console1

下面的Consolel.asm程序在控制台窗口中显示一个字符串，以此示范了GetStdHandle,ExitProcess和WriteConsole函数的用法：

```
TITLE Win32 Console Example #1
(Console1.asm)
; This program calls the following Win32 Console functions:
; CetStdHandle, ExitProcess, WriteConsole
INCLUDE Irvine32.inc
.data
endl EQU < Odh , Oah >
;行结束符
message LABEL BYTE
BYTE"This program is a simple demonstration of"
BYTE"console mode output, using the GetStdHandle"
BYTE"and WriteConsole functions.",end1
messageSize DWORD ( $-message )
consoleHandle HANDLE 0
;标准输出设备的句柄
byteswritten DWORD ?
;已输出的字符数量
.code
main PROC
;获取控制台输出的句柄
INVOKE GetStdHandle,STD_OUTPUT_HANDLE
mov consoleHandle , eax
;在控制台上显示一个字符串
INVOKE WriteConsole,
consoleHandle,
;控制台输出句柄
ADDR message
;字符串的指针
messageSize,
;字符串的长度
ADDR byteswritten,
;返回已输出的字节数
;未用
INVOKE ExitProcess,0
main ENDP
END main
```

程序输出的内容如下所示：

```
This program is a simple demonstration of console mode output, using the
GetStdHandle and WriteConsole functions.
```

### WriteConsoleOutputCharacter函数

WriteConsoleOutputCharacter函数将一定数量的字符复制到屏幕缓冲区从指定位置开始的连续空间中。函数原型如下所示：

```
WriteConsoleOutputCharacter PROTO,
hConsoleOutput:HANDLE,
;控制台输出句柄
7pCharacter:PTR BYTE,
;字符缓冲区的地址
nLength:DWORD,
;缓冲区的大小
dwwriteCoord:COORD,
;首字符的坐标
1pNumberofCharsWritten:PTRDWORD;实际输出字符的数量
```

输出字符的时候，如果到达了屏幕行的末尾，那么自动换行。该函数不影响控制台缓冲区中原有字符的属性值。如果函数无法输出字符，返回值为0,函数忽略字符串中的ASCII控制字符，如制表符、回车符和换行符。

## 11.1.6文件的读写

### CreateFile函数

CreateFile函数既可以用于创建一个文件，也可以用于打开一个文件。如果函数执行成功，那么它返回文件句柄，否则返回的是INVALID_HANDLE_VALUE常量。函数原型如下所示：

```
CreateFile PROTO,
;创建新文件或打开已存在的文件
;文件名字符串指针
1pFilename:PTR BYTE,
dwDesiredAccess:DWORD,
;存取模式
;共享模式
dwShareMode : DWORD .
1pSecurityAttributes:DWORD,;指向安全属性结构
dwCreationDisposition.DWORD,;选项
dwFlagsAndAttributes:DWORD,文件属性
hTemplateFile:DWORD
;模板文件的句柄
```

函数的参数如表11.5所示。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.e9welshjbe0.webp)

### dwDesiredAccess:

通过设置 dwDesiredAccess参数，可以选择读模式、写模式、读写模式
或者设备查询模式。可以同时选择表11.6列出的各种模式，当然还可以同时再加上很多未列在表中的标志位（在Platform SDK文档中搜索CreateFile):

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.6xj6l6s4vf00.webp)

dwCreationDisposition:当文件已经存在或者不存在时，dwCreationDisposition参数指定了要采取何种动作，参数必须指定为表11.7中所列的一种。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.6nev6lfoksc0.webp)

表11.8列出了dwflagsAndAttributes参数最常用的取值（完整的取值列表可在Platform SDK文档中查询CreateFile)。这些取值可以组合起来使用，只不过任何其他的标志都会覆盖掉FILE_ATTRIBUTE_NORMAL属性。这些属性值都是2的暴值，因此可以使用汇编时的OR操作符或+操作符把多个标志组合成一个参数：

```
FILE_ATTRIBUTE_HIDDENORFILE_ATTRIBUTE_READONLY
FILE_ATTRIBUTE_HIDDEN+FILE_ATTRIBUTE_READONLY
```

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.4sdbe7zjg3k0.webp)

例子：以下的例子演示了如何创建或者打开文件，但仅仅是说明性的，更多选项的使用方法请参考MSDN文档中的CreateFile部分。

```
·打开一个现存的文件进行读操作（输入）:
INVOKE CreateFile,
ADDR filename
;文件名指针
GENERIC_READ,
;读取模式
DO_NOT_SHARE,
;共享模式为不共享
NULL,
;安全属性的指针
OPEN EXISTING
;打开已存在的文件
FILE_ATTRIBUTE_NORMAL,
;普通文件属性
;未用
·打开一个现存的文件进行写操作（输出）。文件打开之后，可以覆盖已存在的数据，也可
以把文件指针移动到文件的末尾，追加新的数据（参见SetFilePointer函数，11.1.6节）:
INVOKE CreateFile
GENERIC_WRITE,
;写入文件
UO_NOT_SHARE,
OPEN_EXISTING,
;文件必须存在
CILE_ATT IBUTE_NORMAL,
·创建一个普通属性的新文件，如果文件存在则覆盖：
INVOKE CreateFile
ADDR filename,
GENERIC_WRITE,
;写入文件
DO_NOT_SHARE,
NULI
CREATE_ALWAYS,
;覆盖现存的文件
FILE_ATTRIBUTE_NORMAL,
·如果文件不存在则创建一个新文件，否则就打开现存的文件进行输出：
[NVOKE CreateFile
ADDR filename,
GENERIC_WRITE,
;写入文件
DO_NOT_SHARE,
NULL,
CREATE NEW
;不会删除现存文件
FILE ATTRIBUTE NORMAL,
```

(常量DO_NOT_SHARE和NULL已经在SmallWin.inc文件中定义了，SmallWin.inc被Irvine32.文件自动包含了。）

### CloseHandle函数

CloseHandle函数关闭一个已经打开对象的句柄。函数原型如下所示：

```
CloseHandle PROTO,
hobject:HANDLE
;对象句柄
```

可利用CloseHandle来关闭当前打开文件的名柄，如果失败则返回0。

### ReadFile函数

ReadFile函数从一个输入文件中读取数据。函数原型如下所示：

```
ReadFile PROTO,
hFile:HANDLE,
;输入文件句柄
1pBuffer:PTR BYTE,
;缓冲区指针
nNumberOfBytesToRead:DWORD,
;要读取的字节数
1pNumberOfBytesRead:PTR DWORD
;实际读取的数量
1 poverl apped : PTR DWORD
;异步信息的指针
```

其中hFile参数是CreateFile函数返回的已经打开的文件句柄；1pBuffer参数指向用于接收读取的数据的缓冲区；nNumberOfBytesToRead参数指定了最多要读取多少字节的数据；IpNumber-OfBytesRead参数是一个指针，指向一个整数变量，函数返回的时候会在此填入最终实际读取的字节数；IpOverlapped参数是可选的，它指向一个描述如何在异步操作方式下读取文件的数据结构在同步模式下（这是默认使用的方式）应设为NULL(0)。如果函数失败则返回0
ReadFile内部维护了一个指向当前文件位置的指针。如果针对同一个文件句柄多次调用ReadFile函数，则ReadFile能够记住上次读之后的位置并从该位置开始继续读。ReadFile也可在异步模式下运行，这意味着程序可以不必一直等待直到操作完成。

### WriteFile函数

WriteFile函数把数据写入文件，它使用一个输出句柄，这个句柄可以是一个控制台的屏幕缓冲区句柄，也可以是一个文本文件（或二进制文件）的句柄。数据的写入位置取决于文件内部的读写指针。写操作完成后，读写指针将根据实际写人的字节数做调整。函数原型如下所示：

```
WriteFile PROTO,
hFile:HANDLE,
;输出句柄
1pBuffer:PTR BYTE,
;缓冲区指针
nNumberofBytesToWrite:DWORD,
;缓冲区大小
1pNumberOfBytesWritten:PTR DWORD,
;实际写入的字节数
1poverlapped:PTR DWORD
;异步信息的指针
```

其中hFile是以前打开的文件的句柄；1pBuffer是指向存放要写入文件的数据缓冲区的指针；nNumberOfBytesToWrite指定了要写入文件多少个字节；IpNumberOfBytesWritten参数是一个指针，指向一个整数变量，函数返回的时候会在此填入最终实际写人的字节数；1pOverlapped是指向异步操作信息的指针，对于同步操作应设置为NULL。如果函数失败则返回0。

### SetFilePointer函数

SetFilePointer函数移动一个已打开的文件的读写指针位置，这个函数可以用来在文件最后添加数据或者对文件进行随机记录处理操作：

```
SetFilePointer PROTO,
hFile:HANDLE,
;文件句柄
1DistanceToMove:SDWORD,
;文件指针要移动多少个字节
1pDistanceToMoveHigh:PTR SDWORD,
;指向包含移动字节数高位部分的指针
dwMoveMethod:DWORD
;开始位置
```

如果函数失败则返回0。dwMoveMethod参数指定了从哪个位置开始移动读写指针，它可以有3种取值：FILE_BEGIN,FILE_CURRENT和FILE_END。要移动的字节数是一个64位的带符号整数，它被分为两个部分：

- · IpDistance ToMove——低32位；
- ·IpDistanceToMoveHigh——指向一个变量，里面存放高32位。

如果1pDistanceToMoveHigh的值是NULL(0)的话，则移动文件指针的时候函数只使用1pDistanceToMove中的值。下面的例子代码准备在文件尾部添加数据：

```
INVOKE SetFilePointer,
fileHandle,
;文件句柄
0,
;要移动字节数的低32位
0,
;要移动字节数的高32位
FILE_END
;移动模式
```

参见AppendFile.asm例子程序。

## 11.1.7 Irvine32库的文件I/O过程

Irvine32库包含了一些用于文件输入输出的过程，在第5章已经介绍过了。这些过程是对本章中已经介绍过的Win32API函数的封装。下面列出了CreateOutputFile,OpenFile,WriteToFile,Read-FromFile和CloseFile的源码。

```
CreateOutputFile PROC
Creates a new file and opens it in output mode.
: Receives : EDX points to the filename .
; Returns : If the file was created successfully , EAX
contains a valid file handle. Otherwise, EAX
equals INVALID_HANDLE_VALUE.
INVOKE CreateFile,
edx, GENERIC_WRITE, DO_NOT_SHARE, NULL,
CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
ret
CreateOutputFile ENDP
OpenFile PROC
Opens a new text file and opens for input.
Receives:EDXpointstothefilename.
: Returns : If the file was opened successfully , EAX
contains a valid file handle. Otherwise, EAX equals
INVALID_HANDLE_VALUE.
INVOKE CreateFile
edx, GENERIC_READ, DO_NOT_SHARE, NULL,
OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
ret
OpenFile ENDP
WriteToFile PROC
; Writes a buffer to an output file .
; Receives : EAX = file handle , EDX = buffer offset ,
; ECX = number of bytes to write
; Returns : EAX = number of bytes written to the file .
If the value returned in EAX is less than the
; argument passed in ECX, an error likely occurred.
.data
WriteToFile_1 DWORD ?
; number of bytes written
.code
INVOKE WriteFile,
; write buffer to file
eax,
; file handle
edx,
; buffer pointer
ecx,
; number of bytes to write
ADDR WriteToFile_1, ; number of bytes written
0
; overlapped execution flag
mov eax,WriteToFile_1
; return value
ret
WriteToFile ENDP
ReadFromFile PROC
; Reads an input file into a buffer .
Receives:EAX=file handle,EDX=buffer offset,
ECX=number of bytes to read
; Returns : If CF = 0 , EAX = number of bytes read ; if
CF=1,EAX contains the system error code returned
by the GetLastError Win32 API function.
.data
ReadFromFile_1 DWORD ?
; number of bytes read
.code
INVOKE ReadFile,
eax,
; file handle
edx,
; buffer pointer
ecx,
; max bytes to read
ADDR ReadFromFile_1,
; number of bytes read
;overlapped execution flag
mov eax,ReadFromFile_1
ret
ReadFromFile ENDP
CloseFile PROC
' closes a file using its handle as an identifier .
Receives:EAX=file handle
Returns:EAX=nonzero if the file is successfully
closed.
INVOKE CloseHandle,eax
ret
CloseFile ENDP
```

## 11.1.8测试文件I/O过程

演示创建文件的例子程序
下面的程序创建了一个输出文件，要求用户输入一段文本，然后把文本写入输出文件并报告已写入的字节数，最后关闭文件。程序在尝试创建文件之后检查是否发生了错误：

```
TITLE Creating a File
(CreateFile.asm)
INCLUDE Irvine32.inc
BUFFER_SIZE=501
.data
buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE"output.txt",0
fileHandle HANDLE ?
stringLength DWORD ?
byteswritten DWORD ?
str1 BYTE "Cannot create file", Odh, Oah, 0
str2 BYTE"Bytes written to file [output.txt]:",0
str3 BYTE "Enter up to 500 characters and press"
BYTE"[Enter]:",0dh,0ah,0
.code
nain PROC
;创建一个新的文本文件
mov edx, OFFSET filename
call CreateOutputFile
mov fileHandle,eax
;检查错误
cmp eax, INVALID_HANDLE_VALUE
;是否发生了错误？
jne file_ok
;否：跳过
mov edx, OFFSET str1
;显示错误
call WriteString
jmp quit
file_ok:
;要求用户输人一个字符串
mov edx, OFFSET str3
;"Enter up to ...."
call WriteString
mov ecx, BUFFER_SIZE
;输入一个字符串
mov edx, OFFSET buffer
call ReadString
mov stringLength,eax
;计算输入的字符的数目
;把缓冲区写入输出文件
mov eax, fileHandle
mov edx, OFFSET buffer
mov ecx,stringLength
call WriteToFile
mov.byteswritten,eax
;保存返回值
call CloseFile
;显示返回值
mov edx, OFFSET str2
;"Bytes written"
call WriteString
mov eax,byteswritten
call WriteDec
call Crlf
quit:
exit
main ENDP
END main
```

### 演示读取文件的例子程序

下面的程序打开一个文件用于输入，把它的内容读入一个缓冲区，然后显示缓冲区的内容调用的所有过程都是Irvine32库中的过程：

```
TITLE Reading a File
(ReadFile.asm)
; Opens, reads, and displays a text file using
; procedures from Irvine32. lib
INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE=5000
.data
buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE 80 DUP(0)
fileHandle HANDLE ?
.code
main PROC
;允许用户输入一个文件名
mwrite"Enter an input filename:"
mov edx , OFFSET filename
mov ecx, SIZEOF filename
call ReadString
;打开文件用于输入
mov edx, OFFSET ti lename
call OpenInputFile
mov fileHandle,eax
;检查错误
cmp eax,INVALID_HANDLE_VALUE
;打开文件错误？
jne file_ok
mwrite <"Cannot open file",Odh,Oah> ;否：跳过
jmp quit
;退出
file_ok:
;把文件内容读入一个缓冲区
mov edx, OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size
;读取错误？
mWrite"Error reading file."
;是：显示一条错误信息
call WritewindowsMsg
jmp close_file
check_buffer_size:
cmp eax,BUFFER_SIZE
;缓冲区足够大吗？
jb buf_size_ok
mWrite < " Error : Buffer too small for the file " , odh , 0ah >
jmp quit
;退出
buf_size_ok:
mov buffer[eax],0
;插入一个nu11(0)结束符
mWrite"File size:"
call WriteDec
;显示文件的大小
call Crlf
;显示缓冲区的内容
mWrite &lt;"Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer
;显示缓冲区的内容
call WriteString
call Crlf
close_file:
mov eax,fileHandle
call CloseFile
quit:
exit
main ENDP
END main
```

如果文件无法打开，程序就会报告一个类似下面的错误：

```
Enter an input filename : crazy . txt
Cannot open file
```

如果无法读取文件，程序也会报告错误。假设如果程序使用了错误的文件句柄，就会报告类似下面的错误：

```
Enter an input filename: infile. txt
Error reading file . Error 6 : The handle is invalid .
```

也有可能文件太大而缓冲区太小，这时也会报告一个错误：

```
Enter an input filename: infile. txt
Error: Buffer too small for the file
```

## 11.1.9控制台窗口的操作

通过Win32API可以对控制台窗口及其缓冲区进行非常多的控制操作，图11.1表明屏幕缓冲区有可能大于控制台窗口当前显示的行数。控制台窗口就像一个“视图”，仅仅显示部分缓冲区的内容。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.7ctznw0j1yg0.webp)

有几个函数可以影响控制台窗口以及它在与之关联的屏幕缓冲区中的位置：

- ·SetConsoleWindowInfo函数设置控制台窗口在与之相关的屏幕缓冲区中的大小和位置。
- GetConsoleScreenBufferInfo函数返回控制台窗口矩形在与之相关屏幕缓冲区中的坐标（当然这个函数还返回其他的一些数据）。
- SetConsoleCursorPosition函数把光标定位到屏幕缓冲区中的指定位置，如果这个位置不在可视区域内，控制台窗口会滚动直到光标可见为止。
- ScrollConsoleScreenBuffer函数将屏幕缓冲区中的部分或者全部文本移动出去，这个函数可能会影响到控制台窗口中显示的文本。

### SetConsoleTitle函数

SetConsoleTitle函数允许改变控制台窗口的标题栏文字，例如：

```
.data
titlestr BYTE "Console title",0
.code
INVOKE SetConsoleTitle, ADDR titlestr
```



### GetConsoleScreenBufferInfo函数

GetConsoleScreenBufferInfo函数返回控制台窗口当前状态的相关信息，这个函数有两个参数：控制台屏幕的句柄以及指向一个结构的指针，这个结构将由下列函数填写：

```
Get ConsoleScreenButferInfo PROTO,
hConsoleOutput:HANDLE,
1pConsoleScreenBufferInfo:PIR CONSOLE_SCREEN_BUFFER_INFO
```

下面是CONSOLE_SCREEN_BUFFER_INFO结构的定义：

```
CONSOLE SCREEN_BUFFER_INFO STRUCT
dwSize
COORD<>
dwCursorPosition
COORD<>
wAttributes
WORD?
srwindow
SMALL_RECT<>
dwMaximumWindowSize COORD<>
CONSOLE_SCREEN_BUFFER_INFOENDS
```

dwSize字段中返回屏幕缓冲区的大小，它们是以字符数为单位进行度量的行数和列数；dwCursorPosition字段返回光标的位置。这两个字段都是用COORD结构定义的。WAttributes返回WriteConsole和WriteFile等函数将字符写入控制台窗口时使用的前景和背景颜色；srWindow字段返回控制台窗口在屏幕缓冲区中的坐标；dwMaximumWindowSize字段返回控制台窗口的最大可能尺寸，这个数据是根据当前屏幕缓冲区的大小、字体和视频显示的尺寸综合得出的。下面是使用该函数的简单例子：

```
.data
consoleInfo CONSOLE SCREEN BUFFER INFO
outHandle HANDLE?
.code
INVOKE GetConsoleScreenBufferInfo,outHandle,
ADDR consoleInfo
```

图11.2是Microsoft Visual Studio的调试器里面显示的该数据结构的图例。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.ay61mwxq3s8.webp)

### SetConsoleWindowInfo函数

SetConsoleWindowInfo函数用来设置控制台窗口在与其相关的屏幕缓冲区中的大小和位置。函数原型如下所示：

```
SetConsoleWindowInfo PROTO,
hConsoleOutput:HANDLE,
;屏幕输出句柄
bAbsolute:DWORD,
;坐标类型
1pConsoleWindow:PTR SMALL_RECT
;指向窗口矩形的坐标
```

bAbsolute参数指定了IpConsoleWindow参数指定的坐标应如何解释，如果bAbsolute的值是TRUE,那么坐标代表控制台窗口新的左上角和右下角的位置；如果bAbsolute的值是FALSE,那么新的坐标将被加到当前控制台坐标上面使用。

下面的Scroll.asm程序在屏幕缓冲区上显示50行文本，然后改变控制台窗口的位置和大小，这达到了有效地回滚文字的效果。程序中用到了SetConsoleWindowInfo函数：

```
TITLE Scrolling the Console Window
(Scro11.asm)
INCLUDE Irvine32.inc
data
message BYTE " : This line of text was written "
BYTE"to the screen buffer", odh, Oah
messageSize DWORD($-message)
outHandle HANDLE 0
;标准输出句柄
byteswritten DWORD ?
;已写的字节数
lineNum DWORD 0
windowRect SMALL_RECT<0,0,60,11>
;左、上、右、下
code
main PROC
INVOKE GetStdHandle,STD_OUTPUT_HANDLE
mov outHandle,eax
.REPEAT
mov eax, lineNum
call WriteDec
;显示每行的行号
INVOKE WriteConsole,
outHandle,
;控制台输出句柄
ADDR message,
;字符串指针
messageSize,
;字符串长度
ADDR byteswritten,
;返回已写的字节数
inc lineNum
;下一行的行号
.UNTIL lineNum>50
; Resize and reposition the console window relative to the
; screen buffer .
INVOKE SetConsoleWindowInfo,
outHandle,
TRUE,
ADDR windowRect; window rectangle
call Readchar
;等待按键
call Clrscr
;清除屏幕缓冲区
call Readchar
;等待第二次按键
INVOKE ExitProcess,0
main ENDP
END main
```

由于集成开发（编辑）环境可能会影响控制台窗口的外观和动作，因此最好是在MS-Windows的资源管理器中或命令行上直接运行这个程序，而不是通过IDE运行。另外，在程序运行后读者必须按下两次键盘：第一次是为了清除屏幕缓冲区，另一次程序将退出（这个功能是为了测试而加上的）。

### SetConsoleScreenBufferSize函数

SetConsoleScreenBufferSize函数允许将屏幕缓冲区的大小设置为X列Y行。函数原型如下所示：

```
SetConsoleScreenBufferSize PROTO,
hConsoleOutput:HANDLE,到屏幕缓冲区的句柄
dwSize:COORD
;新的屏幕缓冲区的大小
```

## 11.1.10光标的控制

Win32 API提供了设置光标的大小、可见性和屏幕位置的函数，与这些函数相关的一个重要的数据结构称为CONSOLE_CURSOR_INFO,其中包含了光标大小和可见性等相关信息：

```
CONSOLE_CURSOR_INFO STRUCT
dwSize DWORD ?
bVisible DWORD ?
CONSOLE_CURSOR_INFO ENDS
```

dwSize字段是光标占字符方格大小的百分比（1~100);bVisible等于TRUE(1)的时候，光
标是可见的。

### GetConsoleCursorInfo函数

GetConsoleCursorlnfo函数返回控制台光标的大小和可见性等信息，调用的时候需要传递给函数一个指向CONSOLE_CURSOR_INFO结构的指针：

```
GetConsoleCursorInfo PROTO,
hConsoleOutput:HANDLE,
1pConsoleCursorInfo:PTR CONSOLE_CURSOR_INFO
```

在默认状态下，光标尺寸等于25,也就是说光标占一个字符方格的25%大小。

### SetConsoleCursorInfo函数

SetConsoleCursorlnfo函数设置控制台光标的大小和可见性。同样，调用的时候需要传递给函数一个CONSOLE_CURSOR_INFO结构的指针：

```
SetConsoleCursorInfo PROTO
ConsoleOutput:HANDLE,
1pConsoleCursorInfo:PTR CONSOLE_CURSOR_INFO
```

### SetConsoleCursorPosition函数

SetConsoleCursorPosition函数设置光标的X和Y坐标位置，调用的时候需要传递给函数一个COORD结构和控制台输出句柄：

```
SetConsoleCursorPosition PROTO,
hConsoleOutput:DWORD,
;输出句柄
dwCursorPosition:COORD
;屏幕X和Y坐标位置
```

## 11.1.11 文本颜色的控制

有两种方式用来设置控制台窗口中的文本颜色，可以调用SetConsoleTextAttribute函数来设置当前的文本颜色，这样以后输出的所有文本的颜色都会改变。或者，也可以使用WriteConsoleOutputAttribute函数来设置指定位置字符位置的颜色属性。GetConsoleScreenBufferInfo函数（11.1.9节）返回当前屏幕的颜色以及其他的控制台信息。

### SetConsoleTextAttribute函数

SetConsoleTextAtribute函数用来设置以后输出到控制台窗口的字符的前景和背景颜色。函数原型如下所示：

```
SetConsoleTextAttribute PROTO,
hConsoleOutput:HANDLE,
;控制输出句柄
wAttributes:WORD
;颜色属性
```

颜色值存放于wAttributes参数的低位，其定义和15.3.2节中演示视频BIOS使用时的取值含义相同。

### WriteConsoleOutputAttribute函数

WriteConsoleOutputAttribute函数复制一个颜色属性数组的值到控制台屏幕缓冲区中连续位置的字符格中，字符格的位置是可以指定的。函数原型如下所示：

```
WriteConsoleOutputAttribute PROTO,
hConsoleOutput:DWORD,
;输出句柄
1pAttribute:PTR WORD,
;要输出的属性
nLength:DWORD,
;颜色属性的数量
dwwriteCoord:COORD,
;首个字符格的坐标
1pNumberOfAttrsWritten:PTRDWORD;实际输出的数量
```

IpAttribute指向一个颜色属性数组，每个数组元素的低字节中存放颜色值；nLength是数组的长度；dwWriteCoord是屏幕中要接收这些属性的字符格的起始坐标；IpNumberOfAttrsWritten指向一个变量，函数返回的时候将在此填写实际被设置了颜色属性的字符格的数量。

### WriteColors例子程序

为了演示如何使用颜色属性，例子程序WriteColors.asm创建了一个字符数组和一个属性数组，属性数组里面的每个属性对应字符数组里面的一个字符。程序调用WriteConsoleOutputAttribute数把颜色属性复制到屏幕缓冲区中，然后调用WriteConsoleOutputCharacter函数把字符复制到屏幕缓冲区的同样位置：

```
TITLE Writing Text Colors
(writeColors.asm)
INCLUDE Irvine32.inc
.data
outHandle HANDLE ?
cellswritten DWORD ?
xyPos COORD &lt;10,2&gt;
;字符代码数组
buffer BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
BYTE 16,17,18,19,20
BufSize DWORD($-buffer)
; Array of attributes :
attributes WORD OFh , OEh , ODh , OCh , 0Bh , 0Ah , 9 , 8 , 7 , 6
WORD 5,4,3,2,1,0F0h,0E0h,0D0h,0C0h,0B0h
.code
main PROC
;获取控制台标准输出的句柄
INVOKE CetStdHandle,STD_OUTPUT_HANDLE
mov outHandle,eax
;设置相邻连续字符格的颜色
INVOKE WriteConsoleOutputAttribute,
outHandle, ADDR attributes
BufSize, xyPos
ADDR cellswritten
;输出1到20的字符代码
INVOKE WriteConsoleOutputCharacter,
outHandle, ADDR buffer, BufSize,
xyPos,ADDR cellswritten
INVOKE ExitProcess,0
;结束程序
main ENDP
END main
```

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.2y8gg5hkvk80.webp)

## 11.1.12 时间和日期函数

Win32 API提供了大量的时间和日期函数。对于初学者来说，可以用它们来获取或者设置当前日期和时间。本节的内容仅仅示范了一小部分的时间和日期函数，读者可以查阅Platform SDK文档，进一步了解表11.9中列出的这些函数。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.12j9xj9dwx5s.webp)

#### SYSTEMTIME结构：

与日期和时间相关的Win32API函数常常会用到SYSTEMTIME结构：

```
SYSTEMTIME STRUCT
wYear WORD ?
;年（4位数）
wMonth WORD ?
;月（1~12)
wDayOfWeek WORD ?
;星期（0~6)
wDay WORD ?
;日（1~31)
wHour WORD ?
;小时（0~23)
wMinute WORD ?
;分钟（0~59)
wSecond WORD ?
;秒（0~59)
wMilliseconds WORD ?
;毫秒（0~999)
SYSTEMTIME ENDS
```

wDayOfWeek字段的值含义为：0=星期日，1=星期一，依次类推。由于计算机的内部时钟是每经过一个时间间隔定期与外部时钟源同步更新时钟的，所以wMilliseconds字段的值并不是完全精确的。

### GetLocalTime和SetLocalTime函数

GetLocalTime函数获取当前的日期和时间，该时间已经按照系统日期和时间转换成了本地时区的时间。当调用这个函数的时候，需要传递给函数一个指向SYSTEMTIME结构的指针：

```
GetLocalTime PROTO,
pSystemTime:PTR SYSTEMTIME
```

下面是GetLocalTime函数的调用示例：

```
.data
sysTime SYSTEMTIME
.code
INVOKE GetLocalTime, ADDR sysTime
```

SetLocalTime函数设置系统的当前时间和日期，调用的时候也需要传递一个指向SYSTEMTIME结构的指针，其中包含了要设置的时间值：

```
SetLocalTime PROTO,
pSystemTime:PTR SYSTEMTIME
```

如果函数执行成功，返回值是非0值；如果执行失败，函数返回0。

### GetTickCount函数

GetTickCount函数返回系统启动以来所经过的毫秒数：

```
GetTickCount PROTO
;返回值在EAX中
```

由于计数值是一个双字，所以当系统连续运行49.7天后，计数值将归0。可以在一个循环中使用这个函数来监控经过的时间，并在某个时间到达的时候退出循环。
下面的例子程序Timer.asm测量两次调用GetTickCount之间经过的时间，并检查时间计数器值是否发生了回滚（超过了49.7天）。类似的代码可以用在很多不同的程序中：

```
TITLE Calculate Elapsed Time
(Timer.asm)
; Demonstrate a simple stopwatch timer, using
; the Win32 GetTickCount function.
INCLUDE Irvine32.inc
INCLUDE macros . inc
.data
startTime DWORD ?
.code
main PROC
INVOKE GetTickCount
;获取起始的时间计数值
mov startTime,eax
;保存之
; Create a useless calculation loop .
mov ecx,10000100h
L1:imulebx
imulebx
imulebx
loop L1
INVOKE CetTickCount
;获取新的时间计数值
cmp eax,startTime
;小于起始时间？
jb error
;时间回滚了
sub eax,startTime
;获取经过的毫秒数
call WriteDec
;显示
mwrite <" milliseconds have elapsed", Odh, 0ah>
jmp quit
error:
mwrite"Error:GetTickCount invalid--system has"
mwrite <"been active for more than 49.7 days", odh, Oah>
quit:
exit
main ENDP
END main
```

### Sleep函数

程序有时需要暂停或延迟一小段时间。可以编写一个循环达到延时的目的，但循环的执行时间在不同的处理器上是不同的。除此之外，循环计算还会大量消耗CPU资源，同时降低其他程序的执行速度。Sleep函数挂起当前的线程指定的毫秒数：

```
Sleep PROTO,
dwMilliseconds:DWORD
```

(由于大多数汇编语言程序通常是单线程的，因此这里假设一个线程就代表一个程序。）线程在睡眠的时候不会占用处理器时间。

### GetDateTime子程序

Irvine32库中的GetDateTime过程返回了一个64位的整数，这个数值是自1601年1月1日开始的以100 ns为单位的计数值。这看起来有些奇怪，因为在那个时候人们还不知道计算机是什么，但是Microsoft却使用这个数值来跟踪文件的日期和时间。Win32 SDK文档中建议读者使用下面的步骤来准备系统日期和时间，以便进行其他的日期和时间计算：

1. 1.调用一个函数（例如GetLocalTime)来填写SYSTEMTIME结构。
2. 2.用SystemTimeToFileTime函数把SYSTEMTIME结构转换到FILETIME结构。
3. 3.把FILETIME结构中的结果复制到一个64位的QWORD中。

FILETIME结构把一个64位的QWORD值划分为两个DWORD值：

```
FILETIME STRUCT
loDateTime DWORD ?
hiDateTime DWORD ?
FILETIME ENDS
```

下面的GetDateTime接收一个指向64位QWORD变量的参数，并把当前的日期和时间存储
在这个变量中，时间格式使用FILETIME格式：

```
GetDateTime PROC,
pStartTime:PTR QWORD
LOCAL sysTime:SYSTEMTIME,f1Time:FILETIME
; Gets and saves the current local date / time as a
; 64-bit integer ( in the Win32 FILETIME format ) .
;获取本地系统时间
INVOKE GetLocalTime,
ADDR sysTime
;把SYSTEMTIME转换成FILETIME
INVOKE SystemTimeToFileTime,
ADDR sysTime,
ADDR f1Time
;把FILETIME转换成一个64位的整数
mov esi, pStartTime
mov eax,flTime.loDateTime
mov DWORD PTR [esi],eax
mov eax,flTime.hiDateTime
mov DWORD PTR [esi+4],eax
ret
GetDateTime ENDP
```

由于返回的时间值是一个64位的整数，因此可以使用7.5节讲述的扩展精度算术运算技术进行日期的算术运算。

# 11.2编写Windows图形界面应用程序

在本节中，我们来演示如何写出一个简单的Windows下的图形界面应用程序，这个程序将创建并显示一个主窗口，显示一些消息框，而且可以响应鼠标动作。下面的内容仅仅是一个简要的介绍，因为即使是要描述清楚一个最简单的Windows应用程序中的事件，也需要至少一整章的篇幅。如果读者需要更详尽的信息，请参阅Platform SDK的文档。另一份很好的文献资料是Charles Petzold所著的Programming in Windows:The Definitive Guide to the Win32API一书。
表11.10列出了构建该程序时使用的各种库和包含文件，可以使用本书附带代码Examples\Ch11\WinApp目录下的Visual Studio项目文件构建和运行该程序。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.13fklegj2v1c.webp)

编译时应使用选项/SUBSYSTEM:WINDOWS代替我们在前面章节中使用的/SUBSYSTEM:CONSOLE选项。程序调用了两个标准Windows库文件：kernel32.lib和user32.lib文件。

### 主窗口：

程序将显示一个填满整个屏幕的主窗口。下面的图例已经缩小了，以便于在书
中印刷。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.2xzsij2i78s0.webp)

## 11.2.1必须了解的数据结构

POINT结构定义了以像素为单位的屏幕上某个点的X和Y坐标，它可以用来定位屏幕上的某个对象的坐标，如图形对象、窗口、鼠标单击时的位置等：

```
POINT STRUCT
ptX DWORD ?
ptY DWORD ?
POINT ENDS
```

RECT结构定义了一个矩形的边界，left字段为矩形左边界的X坐标，top字段为矩形顶边的Y坐标。类似地，right和bottom字段的值定义了矩形右下角的坐标：

```
RECT STRUCT
left
DWORD ?
top
DWORD ?
right
DWORD?
bottom
DWORD ?
RECT ENDS
;MSGStruct结构定义了Windows消息需要的相关数据：
MSCStruct STRUCT
msgwnd
DWORD ?
msgMessage DWORD ?
msgWparam DWORD ?
msgLparam DWORD ?
msgTime
DWORD ?
msgPt
POINT<>
MSCStruct ENDS
```

WNDCLASS结构定义了一个窗口类，程序中的每个窗口必须属于一个窗口类，所以每个程序必须为它的主窗口创建窗口类。在能够显示主窗口之前，窗口类必须首先在系统里面注册：

```
WNDCLASS STRUC
style
DWORD?
;窗口风格
1pfnWndProc
DWORD ?
;窗口过程地址
cbClsExtra
DWORD ?
;共享内存
cbwndExtra
DWORD ?
;额外定义的数据
hInstance
DWORD ?
;当前程序的句柄
hIcon
DWORD ?
;图标句柄
hCursor
DWORD ?
;光标句柄
hbrBackground DWORD ?
;背景画刷句柄
1pszMenuName
DWORD ?
;菜单名称的指针
IpszClassName DWORD ?
;类名称的指针
WNDCLASS ENDS
```

以下是这些字段的简要介绍：
style是一些不同风格选项的组合，如WS_CAPTION和WS_BORDER,这个字段影响窗口的外观和行为。

- ·IpfnWndProc是指向一个子程序的指针，这个子程序在我们自己的程序中，用来接收由用户触发的事件消息。
- cbClsExtra定义了这个窗口类所属的所有窗口都可以共享的内存，这个参数可以指定为NULL。
- ·cbWndExtra参数为每个窗口实例分配一些额外的内存。
- ·hInstance参数用来保存当前运行程序的句柄。
- ·hIcon和hCursor参数为当前程序使用的图标和光标句柄。
- ·hbrBackground参数为背景颜色画刷的句柄。
- IpszMenuName指向一个菜单名称字符串。
- IpszClassName指向一个以0结尾的窗口类名称字符串。

## 11.2.2 MessageBox函数

程序显示文本的最简单方法是把文本放到一个消息框中，消息框会弹出并直到用户按下了上面的某个按钮为止。Win32API中的MessageBox函数显示一个简单的消息框，它的函数原型如下所示：

```
MessageBox PROTO,
hwnd : DWORD ,
1pText:PTR BYTE,
7pCaption:PTR BYTE,
uType:DWORD
```

hWnd是当前窗口的句柄；lpText指向要在消息框中显示的以0结尾的字符串；IpCaption指向要显示在消息框标题栏上的以0结尾的字符串；style参数是一个整数，用来描述消息框中的图标（可选）和按钮（必选）的样式。按钮由MB_OK或MB_YESNO等常量定义，图标由MB_ICONQUESTION等常量定义。当想要显示一个消息框的时候，可以把这些常量加在一起以便同时显示图标和按钮：

```
INVOKE MessageBox, hwnd, ADDR QuestionText,
ADDR QuestionTitle,MB_OK+MB_ICONQUESTION
```

## 11.2.3 WinMain 过程

每个Windows应用程序都需要一个启动过程，通常名为WinMain,它负责以下的工作：

- ·获取当前程序的句柄。
- ·装载程序使用的图标和鼠标光标。
- ·注册主窗口使用的窗口类，并且指定用来接收窗口事件消息的过程。
- 创建主窗口。
- 显示并更新主窗口。
- ·开始一个消息循环来接收和分派处理消息，循环会一直持续到用户关闭了应用程序窗口。

WinMain中包含一个消息循环，使用GetMessage从程序的消息队列中返回下一个可用的消息。如果GetMessage取到WM_QUIT消息，那么函数返回0,通知WinMain终止程序。对于其他消息，WinMain会把它们传递给DispatchMessage函数，由该函数把消息分发给程序的WinProc过程。要了解更多关于消息方面的知识，可在Platform SDK文档中搜索“Windows Messages"。

### 11.2.4WinProc过程

WinProc过程接收并处理所有和窗口相关的事件消息，大部分的事件是由用户单击、拖动鼠标或按下了一个键盘按键等动作而引起的。该过程的任务是解译每个消息。如果某个消息是可以辨认的，那么运行和该消息对应的任务。下面是过程的声明：

```
WinProc PROC,
hwnd:DWORD,
;窗口句柄
localMsg:DWORD,
;消息ID
wParam:DWORD,
;参数1(可变）
1Param:DWORD
;参数2(可变）
```

根据不同的消息ID,第3个参数和第4个参数的含义是不同的。如当鼠标被按下的时候，IParam参数里面包含的是鼠标按下点的X和Y坐标。在下面马上要看到的例子中，WinProc过程处理了三种消息：

- ·WM_LBUTTONDOWN,用户按下鼠标左键的时候产生。
- ·WM_CREATE,表明主窗口刚刚被创建。
- ·WM_CLOSE,表明主窗口即将被关闭。

举例来说，过程中的下面几行代码处理WM_LBUTTONDOWN消息，处理方法是调用MessageBox函数向用户显示一条提示信息：

```
.IF eax==WM_LBUTTONDOWN
INVOKE MessageBox, hwnd, ADDR PopupText,
ADDR PopupTitle, MB_OK
jmp WinProcExit
```

用户看到的结果如图11.5所示。任何我们不想处理的消息都应该传递给Windows的默认消息处理函数DefWindowProc。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.7klq61u7f740.webp)

## 11.2.5 ErrorHandler 过程

ErrorHandler过程是可选的，如果程序的主窗口在注册和创建的过程中发生错误，就会调用这个过程。举例来说，调用RegisterClass函数时，如果窗口类成功注册，那么函数会返回一个非0值。若函数返回0,则可调用ErrorHandler来显示出错信息并退出程序的执行：

```
INVOKE RegisterClass, ADDR Mainwin
.IF eax==0
call ErrorHandler
jmp Exit_Program
.ENDIF
```

ErrorHandler过程完成下面几件重要的事情：

- ·调用GetLastError函数获取系统错误代码。
- ·调用FormatMessage函数获取操作系统格式化的出错信息字符串。
- ·调用MessageBox显示包含出错信息的消息框。
- ·调用LocalFree函数释放为出错信息字符串分配的内存。

## 11.2.6 程序清单

看到下面程序的篇幅请不要伤心！因为里面的大部分代码都可以在任何的Windows应用程序中重复使用：

```
TITLE Windows Application
(WinApp.asm)
; This program displays a resizable application window and
several popup message boxes . Special thanks to Tom Joyce
; for the first version of this program.
386
model flat,STDCALL
INCLUDE Graphwin . inc
;==###########*****= DATA ===#==#*===============
data
AppLoadMsgTitle BYTE "Application Loaded",0
AppLoadMsgText BYTE "This window displays when the WM_CREATE"
BYTE "message is received",0
PopupTitle BYTE"Popup Window",0
PopupText BYTE "This window was activated by a "
BYTE "WM_LBUTTONDOWN message",0
GreetTitle BYTE "Main Window Active",0
GreetText BYTE "This window is shown immediately after "
BYTE"CreateWindow and UpdateWindow are called.",0
CloseMsg BYTE "WM_CLOSE message received",0
ErrorTitle BYTE "Error",0
WindowName BYTE "ASM Windows App", 0
className BYTE "ASMWin",0
; Define the Application's Window class structure .
Mainwin WNDCLASS <NULL,WinProc,NULL,NULL,NULL,NULL,NULL,\
COLOR_WINDOW,NULL,className>
msg MSGStruct < >
winRect RECT &lt;&gt;
hMainWnd DWORD ?
hInstance DWORD ?
;
.code
WinMain PROC
;获取当前进程的句柄
INVOKE GetModuleHandle, NULL
mov hinstance,eax
mov MainWin.hInstance,eax
;加载程序的光标和图标
INVOKE LoadIcon,NULL,IDI_APPLICATION
mov MainWin. hIcon, eax
INVOKE LoadCursor,NULL,IDC_ARROW
mov MainWin . hCursor , eax
;注册窗口类
INVOKE RegisterClass, ADDR Mainwin
.IF eax==0
call ErrorHandler
jmp Exit_Program
.ENDIF
;创建应用程序的主窗口
INVOKE CreateWindowEx, 0, ADDR className,
ADDR WindowName,MAIN_WINDOW_STYLE,
CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,
CW_USEDEFAULT,NULL,NULL,hInstance,NULL
;如果CreateWindowEx失败，显示一条消息并退出
.IF eax==0
call ErrorHandler
jmp Exit_Program
.ENDIF
;保存窗口句柄，显示并绘制窗口
mov hMainwnd,eax
INVOKE ShowWindow, hMainwnd, SW SHOW
INVOKE UpdateWindow, hMainwnd
;显示欢迎消息
INVOKE MessageBox, hMainwnd, ADDR GreetText,
ADDR GreetTitle,MB_OK
;开始程序的持续消息处理循环
Message Loop :
;从队列中获取下一条消息
INVOKE GetMessage, ADDR msg, NULL, NULL, NULL
;若无消息则退出
.IF eax==0
jmp Exit Program
ENDIF
;把消息转发给程序的WinProc过程
INVOKE DispatchMessage, ADDR msg
jmp Message_Loop
Exit Program:
INVOKE ExitProcess,0
WinMain ENDP
```

在上面的循环循环代码中，msg结构被传递给GetMessage函数，该函数将填写这个结构，接下来该结构被传递给了DispatchMessage函数。

```
WinProc PROC,
hwnd:DWORD,localMsg:DWORD,wParam:DWORD,1Param:DWORD
;The application's message handler,which handles
; application-specific messages. All other messages
; are forwarded to the default Windows message
; handler .
mov eax, localMsg
.IF eax==WM_LBUTTONDOWN;鼠标按键消息？
INVOKE MessageBox, hwnd, ADDR PopupText,
ADDR PopupTitle, MB_OK
jmp WinProcExit
ELSEIFeax==WM_CREATE;创建窗口消息？
INVOKE MessageBox, hwnd, ADDR AppLoadMsgText,
ADDR AppLoadMsgTitle,MB_OK
jmp WinProcExit
ELSEIFeax==WM_CLOSE;关闭窗口消息？
INVOKE MessageBox, hWnd, ADDR. CloseMsg,
ADDR WindowName,MB_OK
INVOKE PostQuitMessage,0
jmp WinProcExit
.ELSE
;其他消息？
INVOKE DefWindowProc, hwnd, localMsg, wParam, 1Param
jmp WinProcExit
.ENDIF
WinProcExit:
ret
WinProc ENDP
ErrorHandler PROC
;Display the appropriate system error message.
.data
pErrorMsg DWORD ?
;指向错误消息的指针
messageID DWORD ?
.code
INVOKE GetLastError;在EAX中返回消息ID
mov messageID,eax
;获取对应的消息字符串
INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
FORMAT_MESSAGE_FROM_SYSTEM,NULL,messageID,NULL,
ADDR pErrorMsg, NULL, NULI
;显示错误消息
INVOKE MessageBox, NULL, pErrorMsg, ADDR ErrorTitle,
MB_ICONERROR+MB_OK
;释放消息字符串
INVOKE LocalFree, pErrorMsg
ret
ErrorHandler ENDP
END WinMain
```

### 运行例子程序

程序运行的时候首先显示下面的消息框：

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.3ni2fbm4tlc0.webp)

当用户按下了OK按钮来关闭这个ApplicationLoaded(程序已加载）消息框后，另一个消息框将会弹出：

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.75oi9fuxs2c0.webp)

这是Main Window Active(主窗口激活）消息框，按OK按钮关闭它以后，程序的主窗口就显示出来了：

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.32xbm6q2ybu0.webp)

当用户在主窗口的任何地方按下鼠标左键的时候，程序会显示下面的消息框：

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.wh6etqjxfq8.webp)

当用户按下主窗口右上角的X按钮来关闭对话框的时候，窗口关闭之前会显示下面的消息框：

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.24j4ym8brwxs.webp)

当用户关闭了这个消息框以后，程序结束运行。

# 11.3 动态内存分配

动态内存分配也称为堆（内存）分配（Heap Allocation),是程序设计语言提供的一种非常有用的工具，用于为创建的对象、数组和其他结构保留内存。例如，在Java中，类似下面的语句会导致程序为创建的String对象保留内存：

```
String str=new String("abcde");
```

类似地，在C++中，可能会需要为一个整数数组分配内存空间，其大小来自于个变量：

```
int size;
cin>>size;
//用户输入的大小
int array[]=new int[size];
```

C/C++和Java都有内建的运行时堆管理器，用于处理程序的存储分配和存储释放请求，堆管理器通常在程序启动时请求操作系统分配一大块内存，堆管理器创建一个空闲存储块指针链表在接到分配请求时，把一个合适的内存块标记为保留并返回指向该内存块的指针，其后在接到针对同一内存块的释放请求时，堆管理器把该内存块放回空闲存储块的指针链表中（或释放该内存块）。每次新的分配请求到达时，堆管理器都会首先扫描空闲存储块链表，查找第一个足够大的为存块以满足分配请求。
汇编语言可通过多种方式进行动态内存分配：第一种方式是通过系统调用让操作系统为其分配内存块，第二种方式是实现字节堆管理器以处理小对象的内存分配请求。本节讲述如何使用一种方法，例子程序都是32位的保护模式应用程序。
使用表11.11中列出的Windows API函数请求MS-Windows分配不同大小的内存块，表中所有的函数都会改写通用寄存器，因此可能需要封装这些函数以保护重要的寄存器。要想了解更关于内存管理方面的内容，请在Platform SDK文档中搜索“Memory Management Reference”。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.c8jln1p0lz4.webp)

### GetProcessHeap:

如果对使用程序当前拥有的默认堆满意，可以使用GetProcessHeap函数，该函数无参数，在EAX中返回默认堆的句柄。函数原型如下：

```
GetProcessHeap PROTO
调用示例：
.data
hHeap HANDLE ?
.code
INVOKE GetProcessHeap
.IF eax==NULL
;不能获取句柄
jmp quit
.ELSE
mov hHeap,eax
;成功获取句柄
.ENDIF
;HeapCreate:HeapCreate允许为当前程序创建一个新的私有堆。函数原型如下：
HeapCreate PROTO,
f10ptions:DWORD,
堆分配选项
dwInitialSize:DWORD,
堆的初始大小，以字节为单位es
dwMaximumSize:DWORD
堆的最大尺寸值，以字节为单位，es
```

调用时把f1Options设为NULL,把dwInitialSize设置为堆的初始大小，实际的初始大小是该值按页边界向上舍人后的值。当调用HeapAlloc分配内存块时，如果堆的大小超过堆的初始大小，堆将自动增长，上限是dwMaximumSize参数（按页边界向上舍入）指定的值。在调用该函数之后，如果堆未成功创建，则在EAX中返回NULL。下面是调用示例：

```
HEAP_START=2000000
;2MB
HEAP_MAX=400000000
;400MB
.data
hHeap HANDLE?
;堆的句柄
.code
INVOKE HeapCreate,0,HEAP_START,HEAP_MAX
.IF eax==NULL
;堆未创建
call WritewindowsMsg
;显示错误信息
jmp quit
.ELSE
mov hHeap,eax
;成功获取句柄
.ENDIF
```

### HeapDestroy:

HeapDestroy销毁一个现存的私有堆（通过调用HeapCreate创建的）。调用
月时传递要销毁的堆的句柄：

```
.data
hHeap HANDLE ?
;堆的句柄
.code
INVOKE HeapDestroy, hHeap
.IF eax == NULL
call WritewindowsMsg
;显示错误消息
.ENDIF
HeapAlloc:HeapAlloc从堆中分配一块内存。函数原型如下：
HeapA11oc PROTO,
hHeap:HANDLE,
;堆的句柄
dwFlags:DWORD,
;堆分配控制标志
dwBytes:DWORD
;要分配的字节数
```

调用时传递下面的参数：

- ·hHeap是通过调用GetProcessHeap或HeapCreate获取的32位堆句柄
- dwFlags是包含一个或多个标志值的双字，可以把该值设为HEAP_ZERO_MEMORY,此时分配的内存块将以0初始化。
- dwBytes是表示要分配的内存块大小的双字，大小是以字节为单位计算的。如果调用成功，EAX中返回分配的内存块的指针；

如果调用失败，EAX中返回NULL。下面的代码从hHeap标识的堆中分配1000个字节并以0初始化：

```
.data
hHeap HANDLE ?
;堆句柄
pArray DWORD ?
;指向数组的指针
.code
INVOKE HeapAlloc,hHeap,HEAP_ZERO_MEMORY,1000
.IF eax == NULL
mwrite"HeapAlloc failed"
jmp quit
.ELSE
mov pArray,eax
.ENDIF
```

### HeapFree:

HeapFree释放以前从堆中分配的内存块，内存块是以堆句柄和内存块的地址标
识的：

```
HeapFree PROTO,
hHeap:HANDLE,
dwFlags:DWORD,
1 pMem : DWORD
```

第一个参数是包含要释放内存块的堆的句柄，第二个参数通常是0,第三个参数是指向要释放内存块的指针。如果内存块成功释放，返回非0值；如果释放失败，则返回0。下面是调用示例：

```
INVOKE HeapFree,hHeap,0,pArray
```

### 错误处理：

如果调用HeapCreate,HeapDestroy,GetProcessHeap时出错，可以调用GetLastError API函数或调用Irvine32库中的WriteWindowsMsg函数获取出错的细节。下面的代码调用了Heap Create函数，其中包含了错误处理代码：

```
INVOKE HeapCreate, 0, HEAP_START, HEAP_MAX
IFeax==NULL
;失败了？
call writewindowsMsg
;显示错误消息
.ELSE
mov hHeap , eax
;成功
.ENDIF
```

另一方面，当HeapAlloc函数执行失败时，它不设置系统错误代码，因此不能调用GetLastError或WriteWindowsMsg。

## 11.3.1堆测试程序

下面的例子（Heaptestl.asm)使用动态内存分配的方法创建了一个1000字节的数组，使用的是进程的默认堆：

```
Title Heap Test #1
(Heaptest1.asm)
INCLUDE Irvine32.inc
; This program uses dynamic memory allocation to allocate and
; fill an array of bytes.
.data
ARRAY_SIZE=1000
FILL_VAL EQU OFFh
hHeap HANDLE?
;进程堆的句柄
pArray DWORD ?
内存块的指针
newHeap DWORD ?
;新堆的句柄
str1 BYTE"Heap size is:",0
.code
main PROC
INVOKE GetProcessHeap
;获取程序默认堆的句柄
.IF eax==NULL
;失败了？
call WritewindowsMsg
jmp quit
.ELSE
mov hHeap , eax
;成功
.ENDIF
call allocate_array
jnc arrayok
;失败了（CF=1)?
call WriteWindowsMsg
call Crlf
jmp quit
arrayok:
;成功，可以填充数组了
call fill_array
call display_array
call Crlf
; free the array
INVOKE HeapFree, hHeap, 0, pArray
quit:
exit
main ENDP
allocate_array PROC USES eax
; Dynamically allocates space for the array .
; Receives : nothing
; Returns : CF = 0 if allocation succeeds .
INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, ARRAY_SIZE
.IF eax==NULL
stc
;返回时CF=1
.ELSE
mov pArray , eax
;保存指针
clc
;返回时CF=0
.ENDIF
ret
allocate_array ENDP
fill_array PROC USES ecx edx esi
; Fills all array positions with a single character .
; Receives : nothing
; Returns : nothing
mov ecx, ARRAY_SIZE
;循环计数器
mov esi,pArray
;指向数组
L1: mov BYTE PTR [esi], FILL_VAL
;填充每个字节
incesi
;下一个字节
loop L1
ret
fill_array ENDP
display_array PROC USES eax ebx ecx esi
; Displays the array
; Receives : nothing
; Returns : nothing
mov ecx,ARRAY_SIZE;循环计数器
mov esi, pArray
;指向数组
L1: mov al,[esi]
;取一个字节
mov ebx, TYPE BYTE
call WriteHexB
;显示之
inc esi
;下一个字节
loop L1
ret
display_array ENDP
END main
```

下面的例子（Heaptest2.asm)使用动态内存分配的方法循环分配2000个大约0.5MB的内存块：

```
Title Heap Test #2
(Heaptest2.asm)
INCLUDE Irvine32.inc
; Creates a heap and allocates multiple memory blocks,
; expanding the heap until it fails.
.data
HEAP_START=2000000
;2MB
HEAP_MAX=400000000
;400MB
BLOCK_SIZE = 500000
;.5MB
hHeap HANDLE ?
;堆的句柄
pData DWORD ?
;内存块指针
str1 BYTE Odh, Oah, "Memory allocation failed", Odh, Oah, 0
.code
main PROC
INVOKE HeapCreate, 0, HEAP_START, HEAP_MAX
IFeax==NULL
;失败了？
call WritewindowsMsg
call Crlf
jmp quit
.ELSE
mov hHeap,eax
;成功
.ENDIF
mov ecx,2000
;循环计数器
L1: call allocate_block
;分配一块内存
.IF Carry?
;失败了？
mov edx, OFFSET str1
;显示出错消息
call WriteString
jmp quit
.ELSE
;否：打印一个点
mov al,'.'
;显示进度
call WriteChar
.ENDIF
;call free_block
;可以注释/反注释该行观察效果
loop L1
quit:
INVOKE HeapDestroy,hHeap;销毁堆
.IF eax == NULL
;失败了？
call WritewindowsMsg
;是：显示错误消息
call Crlf
.ENDIF
exit
main ENDP
allocate_block PROC USES ecx
;分配一块内存并以0填充
INVOKE HeapAlloc,hHeap,HEAP_ZERO_MEMORY,BLOCK_SIZE
.IF eax==NULL
stc
;返回时CF=1
.ELSE
mov pData,eax
;保存指针
clc
;返回时CF=0
.ENDIF
ret
allocate_block ENDP
free_block PROC USES ecx
INVOKE HeapFree, hHeap, 0, pData
ret
free_block ENDP
END main
```

# 11.4 IA-32内存管理

在Windows 3.0首次发布的时候，从实模式转换到保护模式是程序员们很感兴趣的事情（在Windows 2.x下面写过程序的人都会记得实模式下的640KB内存限制是一件多么麻烦的事情）。随着Windows保护模式（接下来是虚拟内存模式）的到来，全新的可能性出现了，Intel386处理器（IA-32系列处理器里面的第一种）使这一切成为可能。在操作系统方面，我们现在看到的是，从不稳定的Windows3.0到今天流行的、久经考验（并且稳定）的Windows及Linux操作系统经过了十多年的逐步演变。
本节的内容主要集中在内存管理的两个主要方面：

- ·从逻辑地址到线性地址的转换。
- ·从线性地址到物理地址的转换（分页）。

本节的内容主要集中在内存管理的两个主要方面：

- ·从逻辑地址到线性地址的转换。
- ·从线性地址到物理地址的转换（分页）。

让我们简要回顾一下在第2章中介绍的关于IA-32内存管理的几个术语，它们是：

- ·多任务——允许同时运行多个程序（或任务）。处理器把时间分片划分并分配给每个运行中的程序。
- ·段——是一块供程序存放代码或者数据的长度不定的内存。
- ·分段——把多个内存段互相隔离的方法，这使多个程序可以互相隔离地运行而不会干扰。
- ·段描述符——是用来描述一个内存段的64位值，其中包含了段的基地址、访问权限、长度限制、段的类型和使用方式等信息。

现在加入两个新的概念：

- ·段选择子—存放在段寄存器（CS,DS,SS,ES,FS和GS)里面的16位值。
- ·逻辑地址——个段选择子和一个32位的偏移地址的组合。

本书几乎所有的内容都忽略了段寄存器而只用到了32位的数据偏移地址，因为用户程序从不直接修改段寄存器。不过，从系统程序员的视角来看，段寄存器是很重要的，因为它间接地和内存中的段相关。

## 11.4.1 线性地址

### 逻辑地址到线性地址的转换

多任务操作系统允许多个程序（任务）同时在内存中运行，每个程序拥有属于它自己的唯一的数据空间。假设有三个程序，每个程序都在偏移地址200h处有一个变量，这三个变量是如何互相隔离的呢？答案是：IA-32处理器使用了一个经过一步或者两个步骤的过程把每个变量的地址转换到另一个唯一的偏移地址上去。
第一步是把变量的段和偏移地址合成一个线性地址，线性地址有可能就是变量的物理地址，但是有些操作系统（如Windows或者Linux)使用一种称为IA-32的分页技术，使程序能够使用七计算机中实际物理内存更多的线性地址空间。如果情况是这样，就要经过第二个步骤，使用页面转换的方法把线性地址转换到物理地址。有关页面转换的内容将在11.4.2节介绍。
首先，我们来看看处理器是如何使用段和偏移地址来确定一个变量的线性地址的。每个段选择子指向描述符表里面的一个段描述符，段描述符包含了段的基址（起始地址）,如图11.6所示，逻辑地址中的32位偏移地址和段的基址相加就得到了线性地址。

### 线性地址：

线性地址是一个介于0到FFFFFFFFh的32位整数，它代表内存中的一个位置。如果分页机制没有打开的话，那么线性地址实际上就是数据的物理地址。

### 分页

分页机制是IA-32系列处理器的一个重要特征，它使得计算机同时在内存中运行原本无法装人的一堆程序成为可能。在一开始，处理器仅仅装入程序的一部分，剩余的部分保留在磁盘上面。程序要用到的内存被划分成称为页的小块，通常每块的大小为4KB。运行每个程序的时候，处理器有选择地在内存中释放一些不用的页面，然后装入其他马上要被用到的页面
操作系统使用一个页目录和一系列的页表来追踪内存中所有程序的页面使用情况。当一个程序尝试访问线性地址空间中的某个地址的时候，处理器自动把线性地址转换成物理地址，这个转换就称为页面转换。如果需要的页面尚未在内存中，处理器打断程序的执行并引发一个页错误，操作系统捕获这个错误并在程序恢复运行前把所需的页面从磁盘复制到内存中。从应用程序的角度来看，页错误和页面转换是自动发生的。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.6i63zh0ppzk0.webp)

举例来说，读者可以在Windows2000中打开任务管理器程序并看看其中显示的物理内存和虚拟内存之间的差别。图11.7显示了一个装有256MB物理内存的计算机的情况。当前使用中的虚拟内存的总数量显示在任务管理器的Commit Charge一栏中，请注意图中显示的最大可用虚拟内存为633MB,明显大于计算机的物理内存数量。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.2qzq2lfe70g0.webp)

### 描述符表

段描述符存在于两种类型的表中：全局描述符表（GDT)和局部描述符表（LDT)。

#### 全局描述符表（GDT,Global Descriptor Table):

系统中只存在一个全局描述符表，系统在处理器切换到保护模式时创建全局描述符表，表的基址存放在GDTR(全局描述符表寄存器）里面表中的项目（称为段描述符）指向各个段。操作系统可以把所有程序都要使用的段存放在GDT中

#### 局部描述符表（LDT,Local Descriptor Tables):

在一个多任务的操作系统中，每个程序或任务都有它自己的段描述符表，这个表称为局部描述符表（LDT)。当前程序的LDT的基址存放在LDTR(局部描述符表寄存器）中。每个段描述符都包含了段在线性地址空间中的基址。如图11.8所示，一个段和其他段通常是不同的。图中显示了三个不同的逻辑地址，每个地址分别对应于LDT中的不同表项。在这个例子中，我们假设分页机制是关闭的，所以线性地址空间也就是物理地址空间。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.zbvjdlbccw0.webp)

### 段描述符的细节

段描述符中除了包含段的基址以外，有些数据位定义了段的限长和段类型。代码段是一个只读段的例子，如果一个程序尝试去修改代码段的内容，那么处理器会产生一个页异常。段描述符中也包含保护级别，这样可以防止应用程序访问操作系统使用的数据。下面是段描述符中各个域的含义。

#### 基地址：

是一个32位的整数，定义了段在4GB的线性地址空间中的起始地址。

#### 特权级：

每个段都有一个0~3级之间的权限等级，其中0级是最高级，通常被操作系统的核心代码所使用。如果一个低优先级（优先级数字大）的程序尝试去存取高优先级（优先级数字小）的段，那么处理器会产生一个异常。

#### 段类型：

用来指明段的类型以及可以对这个段进行的访问方式，还有段的扩展方向（向上或向下）。数据段（包括堆栈段）可以是只读或者是可读写的，可以向上或向下扩展。代码段可以仅仅是可执行的或者是可执行/可读的。

#### 段存在标志：

这个数据位指明段当前是否在物理内存中存在。

#### 粒度标志：

用来决定如何解释段限长域的数值，如果标志位清零，那么段限长的单位是字节如果该标志位置位，那么段限长的单位是4096字节。

#### 段限长：

是一个20位的整数，表示段的长度，它根据粒度标志的值按下面的两种方式解释：

- ·1字节到1MB字节的段长度。
- ·4096字节到4GB字节的段长度。

## 11.4.2页面地址转换

当分页机制被允许的时候，处理器必须把32位的线性地址转换到32位的物理地址，在这个过程中要用到以下三个数据结构：

- 页目录：一个最多包含1024个32位表项的页表地址表。
- 页表：一个最多包含1024个32位表项的页地址表。
- 页：一个4KB或者4MB的地址空间。

为了简单起见，在接下来的讨论中假设使用4KB的页。
一个线性地址可以被划分为三个部分：指向页目录的指针、指向页表的指针和在页中的偏移地址。页目录的起始地址存放在控制寄存器（CR3)中。如图11.9所示，当线性地址被转换到物理地址的时候，处理器执行了以下的步骤。

![image](https://cdn.staticaly.com/gh/YangLuchao/img_host@master/20230301/image.576ef8n0lis0.webp)

1.线性地址代表线性地址空间中的一个位置。
2.以线性地址中10位的页目录域作为索引，从页目录表中得到页表入口项，页表入口项中包含了页表的基址。

3.以线性地址中10位的页表域作为索引，从页表人口项指定的表项中得到页在物理内存中的基址。
4.线性地址中12位的偏移地址域加上页的基址，就得到了操作数确切的物理地址。操作系统可以选择让所有的程序或任务使用同一个页目录，或者让每个任务使用单独的页目录，也可以混合使用两种方式。

### MS-Windows的虚拟机管理器

现在我们已经有了IA-32处理器如何管理内存的总体概念了，Windows又是如何管理内存的呢？这也应该是个令人感兴趣的问题。下面的小段摘自 Microsoft Platform SDK文档。
虚拟机管理器（VMM,Virtual Machine Manager)是位于MS-Windows核心的32位保护模式操作系统，它的主要职责是创建、运行、监控和终止虚拟机。虚拟机提供了内存管理、进程、中断和异常等服务，它和虚拟设备（32位的保护模式模块）协同工作，使虚拟设备能够以截取中断和异常的方式来控制应用程序对硬件和所安装软件的操作。不管是VMM还是虚拟设备，都运行在特权级0下的同一个32位平坦模式的地址空间中，系统在全局描述符中创建了两个入口（段描述符）,一个给代码段，另一个给数据段。两个段的基址都是从线性地址0开始的，并且永远不会被改变。VMM支持多线程和抢先式的多任务机制，它在多个虚拟机之间共享CPU时间，这样在这些虚拟机之中运行的应用程序就能够同时运行。
在上面一段话中，我们可以把虚拟机解释为Intel称之为“进程”或者“任务”的东西，它由程序代码、支持软件、内存和寄存器等组成。每个虚拟机都有属于它自己的地址空间、I/O地址空间、中断向量表和局部描述符表。在虚拟8086模式下运行的应用程序在特权级3下运行。在MS-Windows中，保护模式程序可以在特权级级0和特权级3下面运行（特权级1和2在Windows下未使用）。

# 11.5 本章小结

从表面看，32位的控制台程序和16位的MS-DOS应用程序在外观和行为上都是很相似的，它们都使用标准的输入输出设备，都支持命令行的重定向操作，也都可以输出彩色的文本。但实质上，32位控制台程序和MS-DOS程序却是完全不同的，前者在保护模式下运行，而后者在实模式下运行。另外，它们使用的也是完全不同的函数库，Win32控制台程序使用的就是Windows图形界面程序使用的那些库文件，而MS-DOS程序被限制于使用BIOS和MS-DOS中断，这些中断在IBM-PC的那个年代就已经在使用了。
在Win32API中可以使用两种字符集：8位的ASCH/ANSI字符集和16位的宽字符/Unicode
字符集。
写汇编程序的时候，API函数中使用的标准Windows数据类型必须先转换成MASM数据类
型（参见表11.1)。
控制台句柄是一个用于控制台输入输出的32位整数。GetStdHandle函数用来得到控制台句柄高级的控制台输入使用ReadConsole函数，高级的控制台输出使用WriteConsole函数。我们使用CreateFile函数来创建或者打开一个文件，用ReadFile函数读取文件，用WriteFile函数写文件，并且使用CloseHandle函数来关闭文件。如果要移动文件读写指针，可以使用SetFilePointer函数
SetConsoleScreenBufferSize用来控制控制台屏幕缓冲区。SetConsoleTextAtribute函数用来改变文本颜色。本章中的WriteColors例子程序演示了WriteConsoleOutputAttribute函数和WriteConsole OutputCharacter函数的用法。
GetLocalTime函数可以用来获取系统时间，SetLocalTime用来设置系统时间，两个函数都用到了SYSTEMTIME结构。本章例子中的GetDateTime例子程序返回一个以64位整数表示的系统时间，这个数值是自1601年1月1日开始的以100ns为单位的计数值。
当要创建一个图形界面的Windows应用程序的时候，我们需要填写包含主窗口的窗口类信息的WNDCLASS结构，还必须创建一个WinMain过程来获取当前程序的句柄，并加载图标和鼠标光标，然后注册窗口类，创建主窗口，接下来显示并更新主窗口，最后，我们开始一个消息循环来接收并分派消息。

WinProc过程负责接收并处理输入的窗口消息，这些消息通常由按动鼠标或按下键盘等用户动作而激发。本章中的例子程序处理WM_LBUTTONDOWN消息、WM_CREATE消息和WM_CLOSE消息，当检测到这些消息的时候，程序会显示一个消息框。
动态内存分配，也称为堆（内存）分配（Heap Allocation),是程序用于保留和释放内存的有用工具。汇编语言可通过多种方式进行动态内存分配：第一种方式是通过系统调用让操作系统为其分配内存块；第二种方式是实现自己的堆管理器以处理小对象的内存分配请求。下面是一些用于动态内存分配的最重要的Win32API调用：

- ·GetProcessHeap返回程序默认堆的句柄，该句柄是一个32位整数值。
- ·HeapAlloc从堆中分配一块内存。
- ·HeapCreate创建一个新的堆。
- ·HeapDestroy销毁一个堆。
- ·HeapFree释放以前从堆中分配的内存块。
- ·HeapReAlloc调整堆中内存块的大小，必要时重新进行分配。
- ·HeapSize返回以前分配的内存块的大小。

本章的内存管理一节集中讨论两个主题：逻辑地址到线性地址的转换和线性地址到物理地址的转换。
逻辑地址中的选择子部分指向段描述符表中的一个表项，这个表项指向线性内存中的一个段。段描述符中包含了这个段的相关信息，如界限、访问类型等。系统中有两种描述符表：一个全局描述符表（GDT)和一个或多个局部描述符表（LDT)。
分页是IA-32系列处理器的一个重要特征，它使得计算机同时在内存中运行原本无法装入的一堆程序成为可能。在一开始，处理器仅仅装入程序的一部分，剩余的部分保留在磁盘上面。处理器使用页目录、页表和页得到一个数据的物理地址。一个页目录表包含了指向各个页表的指针，而一个页表包含了指向多个页的指针。