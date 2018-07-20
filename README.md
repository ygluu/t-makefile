auto makefile

一、目录树：
    ProjectName
	├── 01-lib
	│   ├── crc.so
	│   │   └── test
	│   │       └── Makefile（file）
	│   ├── md5.a
	│   │   └── test
	│   │       └── Makefile（file）
	│   ├── rsa
	│   └── Syscall
	├── 02-com
	├── client
	│   ├── 01-lib
	│   ├── 02-com
	│   ├── Module1
	│   │   └── test
	│   │       └── Makefile（file）
	│   ├── Module2
	│   │   └── test
	│   │       └── Makefile（file）
	│   └── Makefile（file）
	├── server
	│
	├── build.mk（file）
	└── Makefile（file）


二、功能说明
# 功能（配置好相关变量后方可具有自动功能）：
#     1、自动以makefile的父目录名为Target文件名称
#     2、自动搜索源码(*.c/*.cpp)文件
#     3、自动搜索有效头文件(*.h/*.hpp)目录
#     4、自动搜索库文件(*.a/*.so)
#     5、自动搜索有效库文件目录
#     6、根据目录名可自动生成.a和.so文件
#     7、手动自动兼容
#     8、自动识别总makefile功能
#     9、可设置排他性目录列表（不加入编译范围）
#    10、可以避免无用符号链接到目标程序中造成体积臃肿
#    11、无需任何设置也可以编译可执行文件
#    12、具有test目录识别功能，可用于模块独立测试
#    13、自动识别交叉编译链的库文件
#    14、在项目目录框架内可自由移动makefile仍具有自动功能
#    15、不限制死目录框架，可自由设定
#	 16、手动增加模块仅需增加目录即可（参考变量TOP_MODULE_DIR_NAMES的设置）
#
# 使用方法： 
#      1、make 					# 正常编译
#      2、make clean 			# 清除临时文件及TARGET文件
#      3、make INFO=1 			# 编译时打印详细信息
#      4、make INFO=2 			# 静默编译
#      5、make CROSS_COMPILE=... #交叉编译设置


