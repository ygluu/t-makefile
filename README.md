Automatic makefile
===========================
	
|Author|freetoo|
|---|---
|E-mail|gcode@qq.com

cn-help: https://blog.csdn.net/guestcode/article/details/81151921

# 1. Function Description:

* automatically search source code, header file, library file directory and form valid directory list and file list.
* automatic identification of the total makefile function, batch execution of sub directory makefile.
* The name of the directory is automatically named TTARGET file name.
* Dynamic and static mixed links into TARGET files.
* you can set up the exclude directory, avoid search and compilation no source code.
* The directory framework is set flexibly. The free mobile sub makefile in the framework still has automatic functions.
* avoid link unrelated symbols (functions and variables) to avoid TARGET bloated volume.
****

# 2. Automatic makefile scope(demo):
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
* Makefile Scope：
*          current directory(subdirectory) + upper common directory(subdirectory)
* Process Makefile:
*          upper common directory = ../01-lib ../02-com
* Test Makefile:
*          upper common directory = ../../01-lib ../../02-inc ../../../01-lib ../../../02-com
* The setting of the upper common directory reference variable COMMON_DIR_NAMES

# 3. Usage:
* make
* make clean
* make INFO=1                   # Detailed compilation of information
* make INFO=2                   # Silent mode
* make CROSS_COMPILE=...        # Cross compilation settings

