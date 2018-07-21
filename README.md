#Automatic makefile

# 自动makefile作用域（示例）(Automatic makefile scope(demo)):

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

 Makefile Scope：current directory(subdirectory) + upper common directory(subdirectory)
 Process Makefile:
 		upper common directory = ../01-lib ../02-com
 Test Makefile:
       upper common directory = ../../01-lib ../../02-inc ../../../01-lib ../../../02-com
 The setting of the upper common directory reference variable COMMON_DIR_NAMES

 makefile的作用域是：当前目录及子其目录+上层公共目录及其子目录，
 公共目录的设置参考变量COMMON_DIR_NAMES的设置。


# 使用方法(usage)： 
      1、make 				# 正常编译
      2、make clean 			# 清除临时文件及TARGET文件
      3、make INFO=1 			# 编译时打印详细信息
      4、make INFO=2 			# 静默编译
      5、make CROSS_COMPILE=... #交叉编译设置

