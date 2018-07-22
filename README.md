Automatic makefile
===========================
该文件用来测试和展示书写README的各种markdown语法。GitHub的markdown语法在标准的markdown语法基础上做了扩充，称之为`GitHub Flavored Markdown`。简称`GFM`，GFM在GitHub上有广泛应用，除了README文件外，issues和wiki均支持markdown语法。

****
	
|Author|freetoo|
|---|---
|E-mail|gcode@qq.com


# Automatic makefile scope(demo):
```
 │───Project───│───Process───│───Module───│───Test───│

	├── 01-lib
	├── 02-com
	├── tcp-client
	│     ├──────── 01-lib
	│     ├──────── 02-inc
	│     ├──────── Module1
	│     ├──────── Module2
	│     │            └────────── test
	│     │                          └──────── Makefile(test)
	│     └──────── Makefile(Process)
	├── tcp-server
	├── build.mk
	└── Makefile
```
* Makefile Scope：current directory(subdirectory) + upper common directory(subdirectory)
* Process Makefile:
*  		upper common directory = ../01-lib ../02-com
* Test Makefile:
* 		upper common directory = ../../01-lib ../../02-inc ../../../01-lib ../../../02-com
* The setting of the upper common directory reference variable COMMON_DIR_NAMES
 
 makefile的作用域是：当前目录及子其目录+上层公共目录及其子目录，公共目录的设置参考变量COMMON_DIR_NAMES的设置。

# usage:
*      1、make 				# 正常编译
*      2、make clean 			# 清除临时文件及TARGET文件
*      3、make INFO=1 			# 编译时打印详细信息
*      4、make INFO=2 			# 静默编译
*      5、make CROSS_COMPILE=...          #交叉编译设置

