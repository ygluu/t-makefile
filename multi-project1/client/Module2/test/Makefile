############################################################
# Copyleft ©2018 freetoo(yigui-lu)
# name: t-makefile automatic makefile for ubuntu
# qq/wx: 48092788    e-mail: gcode@qq.com
# cn-help: https://blog.csdn.net/guestcode/article/details/81151921
# download: https://github.com/freetoo/t-makefile
# create: 2018-7-7
############################################################

# t-makefile功能说明：
#     1、自动搜索源码、头文件、库文件目录并形成有效目录列表和文件列表
#     2、自动识别总makefile功能，可批量执行子目录的makefile
#     3、自动以目录名为TTARGET文件名
#     4、可动态和静态混合链接成TARGET文件
#     5、可设置排除目录，避免搜索编译无关源码
#     6、目录框架灵活设定，框架内可自由移动子makefile仍具有自动功能
#     7、可避免链接无关符号（函数和变量），避免TARGET体积臃肿

# 使用方法（usage）： 
#     1、make                             # 正常编译 
#     2、make clean                       # 清除临时文件及TARGET文件 
#     3、make INFO=1                      # 编译时打印详细信息 
#     4、make INFO=2                      # 静默编译 
#     5、make CROSS_COMPILE=...           #交叉编译设置

# 自动makefile作用域（示例）:
# Automatic makefile scope(demo)：
#
# │───Project───│───Process───│───Module───│───Test───│
#
#	├── 01-lib
#	├── 02-com
#	├── tcp-client
#	│     ├──────── 01-lib
#	│     ├──────── 02-inc
#	│     ├──────── Module1
#	│     ├──────── Module2
#	│     │            └────────── test
#	│     │                          └──────── Makefile(test)
#	│     └──────── Makefile(Process)
#	├── tcp-server
#	├── build.mk
#	└── Makefile
#
# Makefile Scope：current directory(subdirectory) + upper common directory(subdirectory)
# Process Makefile:
# 		upper common directory = ../01-lib ../02-com
# Test Makefile:
#       upper common directory = ../../01-lib ../../02-inc ../../../01-lib ../../../02-com
# The setting of the upper common directory reference variable COMMON_DIR_NAMES
#
# makefile的作用域是：当前目录及子其目录+上层公共目录及其子目录，
# 公共目录的设置参考变量COMMON_DIR_NAMES的设置。

# 名词解释：
#   上层、向上：是指由makefile所在目录向系统根目录方向到build.mk文件
#             所在的目录位置的若干层目录。

############################################################
# 常用设置项
############################################################
# 输出目标文件名，不设置则默认使用makefile所在的目录名
# 注意：makefile要和main.c/main.cpp文件同级目录
#TARGET ?=
TARGET ?=

# 要包含的上层模块目录名列表（在makefile作用域内）
# 但要确保名称的唯一性，且为上层目录的一级目录名。
# 对于要包含的模块，makefile会为其增加宏定义用于条件编译：INC_MODULENAME
#INCLUDE_MODULE_NAMES += ModuleName
INCLUDE_MODULE_NAMES += Module1

# 要排除的模块目录名列表（在makefile作用域内）
# 对于要排除的模块，makefile会为其增加宏定义用于条件编译：EXC_MODULENAME
#EXCLUDE_DIR_NAMES += ModuleName
EXCLUDE_MODULE_NAMES +=

# 可以手动配置变量LIB_DIRS、INC_DIRS和SRC_DIRS做补充
# 注意：是全路径名(可以用PROJECT_ROOT_DIR作为前缀就不要担心移动
#      makefile以后需要修改路径名了)，且makefile不会搜索它们的子目录
# 库文件所在目录
#LIB_DIRS += $(PROJECT_ROOT_DIR)/...
LIB_DIRS +=
# 头文件所在目录
#INC_DIRS += $(PROJECT_ROOT_DIR)/...
INC_DIRS +=
# 源码文件所在目录
#SRC_DIRS += $(PROJECT_ROOT_DIR)/...
SRC_DIRS +=

############################################################
# 编译设置部分(Compile setup part)
############################################################
# 设置调试编译选项(Setting the debug compilation options)
#DEBUG ?= y
DEBUG ?= y

# 宏定义列表(macro definition)，用于代码条件编译，不需要前面加-D，makefile会自动补上-D
#DEFS ?= DEBUG WIN32 ...
DEFS +=

# C代码编译标志(C code compile flag)
#CCFLAGS  ?= -Wall -Wfatal-errors -MMD
CCFLAGS  ?= -Wall -Wfatal-errors -MMD

# C++代码编译标志(C++ code compile flag)，注：最终CXXFLAGS += $(CCFLAGS)()
#CXXFLAGS ?= -std=c++11
CXXFLAGS ?= -std=c++11

# 编译静态库文件设置标志(Compiling a static library file setting flag)
#ARFLAGS ?= -cr
ARFLAGS ?= -cr

# 链接标志，默认纯动态链接模式(Link flag, default pure dynamic link mode)
# static  mode: DYMAMIC_LDFLAG ?=        STATIC_LDFLAGS ?=
#               DYMAMIC_LDFLAG ?= ...    STATIC_LDFLAGS ?=
# dynamic mode: DYMAMIC_LDFLAG ?=        STATIC_LDFLAGS ?= ... 
# bland   mode: DYMAMIC_LDFLAG ?= ...    STATIC_LDFLAGS ?= ... 
#
# 动态链接标志(dynamic link flag)
#DYMAMIC_LDFLAGS += -lrt -lpthread
DYMAMIC_LDFLAGS ?= -lrt -lpthread
# 静态链接标志(static link flag)
#STATIC_LDFLAGS += -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
STATIC_LDFLAGS ?=

# 交叉编译设置，关联设置：CROSS_COMPILE_LIB_KEY
#CROSS_COMPILE ?= arm-linux-gnueabihf-
#CROSS_COMPILE ?= /usr/bin/arm-linux-gnueabihf-
CROSS_COMPILE ?=

# 交叉编译链库文件的关键字变量设置，用于识别交叉编译链的库文件
# 例如项目中有同样功能的库文件libcrc.a和libarm-linux-gnueabihf-crc.a，
# makefile会根据CROSS_COMPILE_LIB_KEY的设置来选择相应的库文件。
#CROSS_COMPILE_LIB_KEY ?= arm-linux-gnueabihf-
CROSS_COMPILE_LIB_KEY ?= arm-linux-gnueabihf-

############################################################
# 文件和路径信息准备（非常用项，修改需谨慎）
############################################################
# 当前目录
CUR_DIR := $(shell pwd)

# 项目根目录全路径名称，即build.mk文件所在目录，如果没有build.mk则等于当前目录
PROJECT_ROOT_DIR ?= $(shell result=$(CUR_DIR); \
							for dir in $(strip $(subst /, ,$(CUR_DIR))); \
							do \
								dirs=$$dirs/$$dir; \
								if [ -f $$dirs/build.mk ]; then \
									result=$$dirs; \
								fi; \
							done; \
							echo $$result; \
					)
-include $(PROJECT_ROOT_DIR)/build.mk

############################################################
#
# 注意：
#    本文件的变量已经覆盖了build.mk文件的变量，
#    所以build.mk文件的相关变量的设置是无效的。
#
############################################################
