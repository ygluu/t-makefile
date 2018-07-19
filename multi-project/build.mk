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
#TOP_MODULE_DIR_NAMES +=

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
# TARGET设置后期处理及杂项设置
############################################################
# makefile所在目录的全路径名称
CUR_DIR ?= $(shell pwd)
# makefile所在的目录名称
CUR_DIR_NAME ?= $(notdir $(CUR_DIR))

# 如果没有手动设置TARGET，则设置为makefile所在的目录名称
ifeq ($(TARGET),)
TARGET := $(CUR_DIR_NAME)
endif
# 如果TMP_TARGET=TARGET认为是编译exec文件，否则是库文件
ifneq ($(suffix $(TARGET)),)
IS_LIB_TARGET := y
TARGET := $(if $(findstring lib,$(TARGET)),$(TARGET),lib$(TARGET))
endif
TMP_TARGET := $(basename $(TARGET))

# 查找main文件
MAIN_FILE := $(shell find ./ -maxdepth 1 -type f -iname "main.c" -o -type f -iname "main.cpp")

# 无main文件也不是编译库文件，则认为是总makefile功能
ifeq ($(MAIN_FILE)$(IS_LIB_TARGET),)
TARGET := EXE_SUB_MAKEFILE
endif

# 编译信息显示设置，1：为全部显示，2：仅显示步骤项，其它：静默无显示
ifeq ($(INFO),1)
BUILD_INFO=
STEP_INFO=echo
else ifeq ($(INFO),2)
BUILD_INFO=@
STEP_INFO=true
else
BUILD_INFO=@
STEP_INFO=echo
endif

# 文件目录操作变量
RM      := rm -rf
MKDIR   := mkdir -p
MAKE    := make

############################################################
# 编译定义项及编译设置项的后期处理（非常用项，修改需谨慎）
############################################################

# c/c++编译器名称，默认为gcc，有cpp文件则被自动改为g++
CC  := $(CROSS_COMPILE)gcc
CXX := $(CROSS_COMPILE)g++
AR  := $(CROSS_COMPILE)ar
# 默认链接器是gcc，如果有cpp文件makefile会自动设置为g++
LDCC := $(CC)

CFLAGS += $(DEFS:%=-D%)
ifeq ($(DEBUG), y)
CFLAGS += -ggdb -rdynamic -g
else
CFLAGS += -O2 -s
endif
# 不使用到的符号不链接到目标文件中
CFLAGS += -ffunction-sections -fdata-sections
LDFLAGS += -Wl,--gc-sections

# 编译动态库设置项
ifeq ($(suffix $(TARGET)),.so)
CFLAGS += -fPIC
LDFLAGS += -shared
endif

# 最终CXXFLAGS包含CFLAGS
CXXFLAGS += $(CFLAGS)

# 检查编译so文件时，是否是错误设置为静态链接标志
CHECK_LDFLAGS := $(if $(findstring static,$(LDFLAGS)),"Error: build file(*.so) not use static flag",)

############################################################
# 文件和路径搜索部分（非常用项，修改需谨慎）
############################################################
# 如果是总makefile
ifeq ($(TARGET),EXE_SUB_MAKEFILE)
# 不包含test目录名的忽略目录名的列表
SKIP_DIR_NAMES_NO_TEST := $(SKIP_DIR_NAMES)
SKIP_DIR_NAMES_NO_TEST := $(shell for item in $(SKIP_DIR_NAMES_NO_TEST); do result=$$result"\|"$$item; done; echo $$result;)
SKIP_DIR_NAMES_NO_TEST := $(TMP_DIR)$(SKIP_DIR_NAMES_NO_TEST)
SKIP_DIR_NAMES_NO_TEST := $(subst |,\\|,$(SKIP_DIR_NAMES_NO_TEST))
# 执行make clean命令的makefile所在目录列表，包含test目录
MF_CLEAN_DIRS := $(dir $(shell find . -type f -iname Makefile | grep -v $(SKIP_DIR_NAMES_NO_TEST)))
MF_CLEAN_DIRS := $(foreach dir,$(MF_CLEAN_DIRS),$(shell if [ ! $(dir) = ./ ]; then echo $(dir); fi;))
endif

# 搜索忽略跳过的目录名列表设置
SKIP_DIR_NAMES := $(TMP_DIR) $(SKIP_DIR_NAMES)
SKIP_DIR_NAMES := $(shell for item in $(SKIP_DIR_NAMES); do result=$$result"\|"$$item; done; echo $$result;)
SKIP_DIR_NAMES := $(TEST_DIR_NAME)$(SKIP_DIR_NAMES)
SKIP_DIR_NAMES := $(subst |,\\|,$(SKIP_DIR_NAMES))
# 如果是总makefile
ifeq ($(TARGET),EXE_SUB_MAKEFILE)
# 执行make命令的makefile所在目录列表，不包含test目录
MF_MAKE_DIRS := $(dir $(shell find . -type f -iname Makefile | grep -v $(SKIP_DIR_NAMES)))
MF_MAKE_DIRS := $(foreach dir,$(MF_MAKE_DIRS),$(shell if [ ! $(dir) = ./ ]; then echo $(dir); fi;))
endif

# 如果没设置临时，默认等于tmp
ifeq ($(TMP_DIR),)
TMP_DIR := tmp
endif

# 项目根目录全路径名称，即build.mk文件所在目录
PROJECT_ROOT_DIR ?= $(shell dirs=; for dir in $(strip $(subst /, ,$(CUR_DIR))); do dirs=$$dirs/$$dir; if [ -f $$dirs/build.mk ]; then echo $$dirs; fi; done;)

# 如果没有手动设置LIB_ROOT_DIRS，将向上到build.mk所在目录搜索名为TOP_MODULE_DIR_NAMES的目录
ifeq ($(LIB_ROOT_DIRS)$(IS_LIB_TARGET),)
ifneq ($(PROJECT_ROOT_DIR),)
ifneq ($(PROJECT_ROOT_DIR),$(CUR_DIR))
LIB_ROOT_DIRS := $(strip $(subst /, ,$(subst $(PROJECT_ROOT_DIR),,$(CUR_DIR))))
ifneq ($(LIB_ROOT_DIRS),)
LIB_ROOT_DIRS := $(shell Dirs=; \
					isInLib=n; \
					for dir in $(LIB_ROOT_DIRS); \
					do \
						for name in $(TOP_MODULE_DIR_NAMES); \
						do \
							if [ $$dir = $$name ];then \
								isInLib=y; \
							fi; \
						done; \
					done; \
					if [ $$isInLib = n ]; then \
						for dir in $(LIB_ROOT_DIRS); \
						do \
							Dirs=$$Dirs../; \
							for name in $(TOP_MODULE_DIR_NAMES); \
							do \
								if [ -d $$Dirs"$$name" ];then \
									echo $$Dirs"$$name"; \
								fi; \
							done; \
						done; \
					fi;)
endif
endif
endif
endif

# 如果没有手动设置SRC_ROOT_DIRS
ifeq ($(SRC_ROOT_DIRS),)
ifeq ($(CUR_DIR_NAME),$(TEST_DIR_NAME))
SRC_ROOT_DIRS := ..
else
SRC_ROOT_DIRS := .
endif
endif
SRC_ROOT_DIRS += $(LIB_ROOT_DIRS)
ALL_DIR := $(shell find $(SRC_ROOT_DIRS) -type d | grep -v $(SKIP_DIR_NAMES))
ifeq ($(CUR_DIR_NAME),$(TEST_DIR_NAME))
SRC_ROOT_DIRS += .
ALL_DIR += $(shell find . -type d | grep -v $(SKIP_DIR_NAMES))
endif

# 如果没有手动设置INC_ROOT_DIRS
ifeq ($(INC_ROOT_DIRS),)
ifeq ($(INC_DIR_NAMES),)
INC_DIRS := $(ALL_DIR)
else
INC_DIRS := $(foreach name,$(INC_DIR_NAMES),$(foreach dir,$(ALL_DIR),$(shell if [ $$(basename $(dir)) = $(name) ]; then echo $(dir);fi;)))
endif
else
INC_DIRS := $(shell find $(INC_ROOT_DIRS) -type d | grep -v $(SKIP_DIR_NAMES))
endif
# 去掉无头文件的目录
INC_DIRS := $(foreach dir,$(INC_DIRS),$(if $(shell find $(dir) -maxdepth 1 -type f -iname "*.h" -o -type f -iname "*.hpp"),$(dir),))
INC_DIRS := $(INC_DIRS:%=-I%)

OBJ_DIR := $(TMP_DIR)$(CUR_DIR)/
TMP_DIR := $(TMP_DIR)/
# 源文件目录及obj文件列表
#SRC_DIRS := $(foreach dir,$(ALL_DIR),$(if $(suffix $(dir)),,$(dir)))
SRC_DIRS := $(foreach dir,$(ALL_DIR),$(if $(shell find $(dir) -maxdepth 1 -type f -iname "*.a" -o -type f -iname "*.so"),,$(dir)))
SRC_DIRS := $(foreach dir,$(SRC_DIRS),$(if $(shell find $(dir) -maxdepth 1 -type f -iname "*.c" -o -type f -iname "*.cpp" | grep -v "main.c" | grep -v "main.cpp"),$(dir),))
OBJ_FILES := $(shell find $(SRC_DIRS) -maxdepth 1 -type f -iname "*.c" -o -type f -iname "*.cpp" | grep -v "main.c" | grep -v "main.cpp")
OBJ_FILES := $(OBJ_FILES:%.c=$(OBJ_DIR)%.o)
OBJ_FILES := $(OBJ_FILES:%.cpp=$(OBJ_DIR)%.o)
MAIN_FILE := $(MAIN_FILE:./%.c=$(OBJ_DIR)%.o)
MAIN_FILE := $(MAIN_FILE:./%.cpp=$(OBJ_DIR)%.o)

# 库文件目录及库文件列表
LIB_DIRS := $(foreach dir,$(ALL_DIR),$(if $(shell find $(dir) -maxdepth 1 -type f -iname "*.a" -o -type f -iname "*.so"),$(dir),))
STATIC_LIB_FILES := $(notdir $(shell find $(LIB_DIRS) -maxdepth 1 -type f -iname "*.a"))
# 如果是交叉编译，则使用交叉编译链的库文件并排除同名的非交叉编译链的库文件
ifneq ($(CROSS_COMPILE),)
tmp := $(notdir $(shell find $(LIB_DIRS) -maxdepth 1 -type f -iname "lib"$(CROSS_COMPILE_LIB_KEY)"*.a"))
tmp := $(tmp:lib$(CROSS_COMPILE_LIB_KEY)%.a=lib%.a)
STATIC_LIB_FILES := $(foreach name1,$(STATIC_LIB_FILES),$(if $(foreach name2,$(tmp),$(shell if [ $(name1) = $(name2) ]; then echo $(name1);fi;)),,$(name1)))
else
# 不是交叉编译链，排除交叉编译链的库文件
STATIC_LIB_FILES := $(foreach name,$(STATIC_LIB_FILES),$(if $(findstring $(CROSS_COMPILE_LIB_KEY),$(name)),,$(name)))
endif
STATIC_LIB_FILES := $(STATIC_LIB_FILES:lib%.a=-l%)

DYMAMIC_LIB_FILES := $(notdir $(shell find $(LIB_DIRS) -maxdepth 1 -type f -iname "*.so"))
# 如果是交叉编译，则使用交叉编译链的库文件并排除同名的非交叉编译链的库文件
ifneq ($(CROSS_COMPILE),)
tmp := $(notdir $(shell find $(LIB_DIRS) -maxdepth 1 -type f -iname "lib"$(CROSS_COMPILE_LIB_KEY)"*.so"))
tmp := $(tmp:lib$(CROSS_COMPILE_LIB_KEY)%.so=lib%.so)
DYMAMIC_LIB_FILES := $(foreach name1,$(DYMAMIC_LIB_FILES),$(if $(foreach name2,$(tmp),$(shell if [ $(name1) = $(name2) ]; then echo $(name1);fi;)),,$(name1)))
else
# 不是交叉编译链，排除交叉编译链的库文件
DYMAMIC_LIB_FILES := $(foreach name,$(DYMAMIC_LIB_FILES),$(if $(findstring $(CROSS_COMPILE_LIB_KEY),$(name)),,$(name)))
endif
DYMAMIC_LIB_FILES := $(DYMAMIC_LIB_FILES:lib%.so=-l%)
LIB_DIRS := $(LIB_DIRS:%=-L%)
#LIB_FILES := $(DYMAMIC_LIB_FILES)
#LIB_FILES += $(STATIC_LIB_FILES)

# *.c/*/cpp文件搜索的目录，用于编译设置
#VPATH := $(SRC_DIRS)

############################################################
# 链接成最终文件
############################################################
all: FIRST_EXEC $(TARGET)

FIRST_EXEC:
	@if [ $(TMP_DIR) ]; then $(MKDIR) $(TMP_DIR); fi;

#*********************************************
# 总makefile模式，编译子目录下的所有makefile
EXE_SUB_MAKEFILE:
	@$(STEP_INFO) "all makefile is making..."
	@for dir in $(MF_MAKE_DIRS); do $(MAKE) -C $$dir; done;
	@$(STEP_INFO) "all makefile make done"

#*********************************************
# 生成exec程序
$(TMP_TARGET): $(OBJ_FILES) $(MAIN_FILE)
	@$(STEP_INFO) "Generating exec file: "$@
	$(BUILD_INFO)$(CXX) $(CXXFLAGS) -o $@ $^ $(LIB_DIRS) $(LDFLAGS)

#*********************************************
# 生成静态库文件
$(TMP_TARGET).a: $(OBJ_FILES)
	@$(STEP_INFO) "Generating static lib file: "$@
	$(BUILD_INFO)$(AR) $(ARFLAGS) -o $@ $^

#*********************************************
# 生成动态库文件
$(TMP_TARGET).so: $(OBJ_FILES)
	@$(STEP_INFO) "Generating dynamic lib file: "$@
ifneq ($(CHECK_LDFLAGS),)
	@echo $(CHECK_LDFLAGS)
endif
	$(BUILD_INFO)$(CXX) $(CXXFLAGS) -o $@ $^ $(LIB_DIRS) $(LDFLAGS) $(DYNC_FLAGS)

#*********************************************
# 编译c代码文件
$(OBJ_DIR)%.o: %.c
	@$(STEP_INFO) "Compiling c file: "$<
	@$(MKDIR) $(dir $@)
	$(BUILD_INFO)$(CC) $(CFLAGS) -c $< -o $@ $(INC_DIRS)

#*********************************************
# 编译c++代码文件
$(OBJ_DIR)%.o: %.cpp
	@$(STEP_INFO) "Compiling cpp file: "$<
	@$(MKDIR) $(dir $@)
	$(BUILD_INFO)$(CXX) $(CXXFLAGS) -c $< -o $@ $(INC_DIRS)

#*********************************************
# 头文件关联
-include $(OBJ_FILES:.o=.d)

############################################################
# 清理临时文件
############################################################
clean:
ifeq ($(TARGET),EXE_SUB_MAKEFILE)
#*********************************************
# 总makefile模式
	@$(STEP_INFO) "all makefile is cleaning..."
	@for dir in $(MF_CLEAN_DIRS); do $(MAKE) -C $$dir clean; done;
	@$(STEP_INFO) "all makefile clean done"
else
#*********************************************
# 子makefile模式，删除临时目录
	@if [ -d $(TMP_DIR) ]; then $(RM) -r $(TMP_DIR); fi;
	@if [ -f $(TARGET) ]; then $(RM) -f $(TARGET); fi;
	@echo "temp file is cleaned"
endif

.PHONY: all clean
