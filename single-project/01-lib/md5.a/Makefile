############################################################
# 名称：t-makefile 自动万能makefile模板（linux ubuntu gcc/g++）
# 作者：freetoo 码客(卢益贵)
# qqwx：48092788
# e-mail：gcode@qq.com
# csdn：https://blog.csdn.net/guestcode
# github：https://github.com/freetoo/t-makefile
# 时间：2018-7-7
#
# 声明：
#	1、转载、使用或修改等，必须保留作者相关信息
#   2、本文件不对您的代码编译结果担负任何法律和道德责任，使用时需谨慎
#
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
#
# 注意事项：
#      1、使用前请阅读手动和自动部分的makefile的作用域说明
#      2、main函数文件名称必须为main.c或main.cpp
#	   3、makefile文件必须和main函数文件在一起
#	   4、makefile和build.mk结合makefile才能自动向上层目录搜索
#
# demo目录框架：
# ProjectName
#		├── 01-lib
#		│   ├── crc.so
#		│   │   └── test
#		│   │       └── Makefile（file）
#		│   ├── md5.a
#		│   │   └── test
#		│   │       └── Makefile（file）
#		│   ├── rsa
#		│   └── Syscall
#		├── 02-com
#		├── client
#		│   ├── 01-lib
#		│   ├── 02-com
#		│   ├── Module1
#		│   │   └── test
#		│   │       └── Makefile（file）
#		│   ├── Module2
#		│   │   └── test
#		│   │       └── Makefile（file）
#		│   └── Makefile（file）
#		├── server
#		│
#		├── build.mk（file）
#		└── Makefile（file）
#
############################################################


############################################################
# TARGET
############################################################
# 输出目标文件名，不设置则默认使用makefile所在的目录名
# 自动编译时：
#     如果目录带.a/.so后缀的，则自动认为是编译库文件，自动编译库
#	  文件时，makefile自动功能的作用域为：当前目录及其子目录。
# 注意：makefile要和main.c/main.cpp文件同级目录
#TARGET ?=
TARGET ?=

############################################################
# 手动设置搜索部分
############################################################
# makefile的手动作用域说明：
#	1、maekfile手动作用域仅为变量SRC_ROOT_DIRS、LIB_ROOT_DIRS和
#     INC_ROOT_DIRS设置的目录及其子目录。
#   2、临时目录变量（TMP_DIR）、测试目录变量（TEST_DIR_NAME）和
#     忽略目录变量（SKIP_DIR_NAMES）指定名称的目录不在作用域范围内。

# 源码文件的根目录列表，如果没有特殊要求的，建议头文件和实现文件放一起
# makefile会搜索子目录，设置后makefile不会搜索其他目录的源码文件
#SRC_ROOT_DIRS := . ..
#SRC_ROOT_DIRS := src ../src
SRC_ROOT_DIRS ?=

# 库根目录列表，建议*.c/*.cpp/*.a/*.so和*.h/*.hpp一起放
# makefile会搜索子目录，设置后makefile不会搜索其他目录的库文件
#LIB_ROOT_DIRS ?= ./lib/crc ./lib/md5  ./lib/rsa
LIB_ROOT_DIRS ?=

# 头文件根目录列表（如果头文件独立存放的，请设置此项）
# makefile会搜索子目录，设置后makefile不会搜索其他目录的头文件
#INC_ROOT_DIRS ?= ./inc/crc ./inc/md5  ./inc/rsa
INC_ROOT_DIRS ?=

############################################################
# 自动搜索设置部分
############################################################
# makefile的自动作用域说明：
#   1、makefile会自动搜索其当前目录及其子目录
#   2、如果makefile在test目录，则自动搜索上一层目录及其子目录
#   3、makefile会向上层目录搜索由变量TOP_MODULE_DIR_NAMES指定
#  	  名称的目录及其子目录。
#   4、makefile向上搜索范围：直到核心文件build.mk所在的目录
#   5、makefile向上搜索的目录名是：向上每一层目录的一级子目录
#   6、makefile自动搜索文件范围：*.so/*.a/*.c/*.cpp/*.h/*.hpp
#   7、临时目录变量（TMP_DIR）、测试目录变量（TEST_DIR_NAME）和
#     忽略目录变量（SKIP_DIR_NAMES）指定名称的目录不在搜索范围内。
#   8、自动编译库文件时，makefile自动功能的作用域仅为：当前目录及其子目录。
#
# 上层模块目录名列表，有效前提：没有手动设置变量LIB_ROOT_DIRS
# 包含库目录、公共目录、模块等的目录
#TOP_MODULE_DIR_NAMES ?= lib com 01-lib 01-com 02-lib 02-com 03-lib 03-com
TOP_MODULE_DIR_NAMES ?= lib com 01-lib 01-com 02-lib 02-com 03-lib 03-com
# 如果手动增加上层目录的模块，仅需加入该模块的目录名，但要确保名称在项目目录里的唯一性
#TOP_MODULE_DIR_NAMES += ModuleName
TOP_MODULE_DIR_NAMES +=

# 头文件目录名列表，有效前提：没有手动设置变量INC_ROOT_DIRS
# 仅需列出目录名称，makefile只搜索其目录下的头文件所在目录
# 如果不设置本变量，makefile会自动搜索作用域下的头文件所在目录
#INC_DIR_NAMES ?= inc include 01-inc 01-include 02-inc 02-include 03-inc 03-include
INC_DIR_NAMES ?=

############################################################
# 手动自动搜索共同设置部分
############################################################
# 测试目录的目录名称，makefile会排除在搜索范围之外（makefile所在目录例外）
#TEST_DIR_NAME ?= test
TEST_DIR_NAME ?= test

# 临时目录的目录名称，makefile会排除在搜索范围之外
# 编译时临时文件（.o/.d等文件）所在的目录，如果不设置则默认为tmp
#TMP_DIR ?= tmp
TMP_DIR ?= tmp

# 忽略目录的名称列表，makefile会排除在搜索范围之外
#SKIP_DIR_NAMES ?= .git doc docs tool tools
SKIP_DIR_NAMES ?= .git

############################################################
# 编译设置部分
############################################################
# 设置调试编译选项
#DEBUG ?= y
DEBUG ?= y

# 宏定义列表，用于代码条件编译，不需要前面加-D，makefile会自动补上-D
#DEFS ?= DEBUG WIN32 ...
DEFS ?=

# 交叉编译设置，关联设置：CROSS_COMPILE_LIB_KEY
#CROSS_COMPILE ?= arm-linux-gnueabihf-
#CROSS_COMPILE ?= /usr/bin/arm-linux-gnueabihf-
CROSS_COMPILE ?=

# 交叉编译链库文件的关键字变量设置，用于识别交叉编译链的库文件
# 如果工程目录中有交叉编译链的库文件，请务必设置本变量。
# 模板lib[key][name].a=libarm-linux-gnueabihf-crc.a（含so文件）
# 例如项目中有同样功能的库文件libcrc.a和libarm-linux-gnueabihf-crc.a，
# makefile会根据CROSS_COMPILE_LIB_KEY的设置来选择相应的库文件
# 来加入链接标志中。
#CROSS_COMPILE_LIB_KEY ?= arm-linux-gnueabihf-
CROSS_COMPILE_LIB_KEY ?= arm-linux-gnueabihf-

# C代码编译标志
#CFLAGS  ?= -Wall -Wfatal-errors -MMD
CFLAGS  ?= -Wall -Wfatal-errors -MMD

# C++代码编译标志，注：最终CXXFLAGS += $(CFLAGS)
#CXXFLAGS ?= -std=c++11
CXXFLAGS ?= -std=c++11

# 编译静态库文件设置标志
#ARFLAGS := -cr
ARFLAGS := -cr

# 链接模式，默认纯动态链接模式
# 1：纯静态链接模式，2：动态静态混合链接模式，其它值：纯动态链接模式
#LDMODE ?=
LDMODE ?=

# 链接标志和链接库设置（除LIB_ROOT_DIRS目录下的*.a和*.so文件之外的链接库设置）
# STATIC_LIB_FILES和DYMAMIC_LIB_FILES变量是makefile作用域里面的.a和.so文件列表，请一定保留
ifeq ($(LDMODE),1)
# 纯动态链接模式
#LDFLAGS ?= -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive $(STATIC_LIB_FILES)
LDFLAGS ?= -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive $(STATIC_LIB_FILES)
else ifeq ($(LDMODE),2)
# 动态静态混合链接模式
# 模板：LDFLAGS = -Wl,-Bstatic ... $(STATIC_LIB_FILES) -Wl,--as-needed -Wl,-Bdynamic ... $(DYMAMIC_LIB_FILES)
#LDFLAGS ?= -Wl,-Bstatic -lpthread $(STATIC_LIB_FILES) -Wl,--as-needed -Wl,-Bdynamic -lrt $(DYMAMIC_LIB_FILES)
LDFLAGS ?= -Wl,-Bstatic -lpthread $(STATIC_LIB_FILES) -Wl,--as-needed -Wl,-Bdynamic -lrt $(DYMAMIC_LIB_FILES)
else
# 纯静态链接模式
#LDFLAGS ?= -Wl,--as-needed -lrt -lpthread $(DYMAMIC_LIB_FILES) $(STATIC_LIB_FILES)
LDFLAGS ?= -Wl,--as-needed -lrt -lpthread $(DYMAMIC_LIB_FILES) $(STATIC_LIB_FILES)
endif

############################################################
# 文件和路径信息准备（非常用项，修改需谨慎）
############################################################
CUR_DIR := $(shell pwd)

PROJECT_ROOT_DIR := $(shell dirs=; for dir in $(strip $(subst /, ,$(CUR_DIR))); do dirs=$$dirs/$$dir; if [ -f $$dirs/build.mk ]; then echo $$dirs; fi; done;)
ifeq ($(PROJECT_ROOT_DIR),)
-include build.mk
else
-include $(PROJECT_ROOT_DIR)/build.mk
endif

############################################################
#
# 注意：
#    本文件的变量已经覆盖了build.mk文件的变量，
#    所以build.mk文件的相关变量的设置是无效的。
#
############################################################
