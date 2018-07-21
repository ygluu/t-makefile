############################################################
# Copyright ©2018
# name: t-makefile auto makefile (ubuntu/gcc/g++）
# author: freetoo(yigui-lu)
# qq/wx: 48092788
# e-mail: gcode@qq.com
# help: https://blog.csdn.net/guestcode
# download: https://github.com/freetoo/t-makefile
# create: 2018-7-7
############################################################

# 名词解释：
#   上层、向上：是指由makefile所在目录向根目录方向到build.mk文件
#             所在的目录方向（和makefile所在目录有共同目录树分支的）。

############################################################
# 常用设置项
############################################################
# 输出目标文件名，不设置则默认使用makefile所在的目录名
# 注意：makefile要和main.c/main.cpp文件同级目录
#TARGET ?=
TARGET ?=

# 需要包含的上层模块目录名列表，但要确保目录名的唯一性
#INCLUDE_MODULE_NAMES += ModuleName
INCLUDE_MODULE_NAMES +=

# 要排除的模块目录名列表，makefile会排除在搜索范围之外
#EXCLUDE_DIR_NAMES += ModuleName
EXCLUDE_MODULE_NAMES +=

############################################################
# 编译设置部分
############################################################
# 设置调试编译选项
#DEBUG ?= y
DEBUG ?= y

# 宏定义列表，用于代码条件编译，不需要前面加-D，makefile会自动补上-D
#DEFS ?= DEBUG WIN32 ...
DEFS +=

# C代码编译标志
#CCFLAGS  ?= -Wall -Wfatal-errors -MMD
CCFLAGS  ?= -Wall -Wfatal-errors -MMD

# C++代码编译标志，注：最终CXXFLAGS += $(CCFLAGS)
#CXXFLAGS ?= -std=c++11
CXXFLAGS ?= -std=c++11

# 编译静态库文件设置标志
#ARFLAGS ?= -cr
ARFLAGS ?= -cr

# 链接标志，默认纯动态链接模式
# static  mode: DYMAMIC_LDFLAG ?=        STATIC_LDFLAGS ?=
#               DYMAMIC_LDFLAG ?= ...    STATIC_LDFLAGS ?=
# dynamic mode: DYMAMIC_LDFLAG ?=        STATIC_LDFLAGS ?= ... 
# bland   mode: DYMAMIC_LDFLAG ?= ...    STATIC_LDFLAGS ?= ... 
#
# 动态链接标志
#DYMAMIC_LDFLAGS += -lrt -lpthread
DYMAMIC_LDFLAGS += -lrt -lpthread
# 静态链接标志
#STATIC_LDFLAGS += -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
STATIC_LDFLAGS +=

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
									break; \
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
