############################################################
# Copyleft ©2018 freetoo(yigui-lu)
# name: t-makefile automatic makefile for ubuntu
# qq/wx: 48092788    e-mail: gcode@qq.com
# cn-help: https://blog.csdn.net/guestcode/article/details/81229127
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
#     5、make CROSS_COMPILE=...           # 交叉编译设置
#     6、make [clean] ALL=y               # 执行本目录和子目录的makefile

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
INCLUDE_MODULE_NAMES +=

# 要排除的模块目录名列表（在makefile作用域内）
# 对于要排除的模块，makefile会为其增加宏定义用于条件编译：EXC_MODULENAME
#EXCLUDE_DIR_NAMES += ModuleName
EXCLUDE_MODULE_NAMES +=

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
# 项目规划初期设置
############################################################
# 测试目录的目录名称，makefile会排除在搜索范围之外（makefile所在目录例外）
#TEST_DIR_NAME ?= test
TEST_DIR_NAME ?= test

# 临时目录的目录名称，makefile会排除在搜索范围之外
# 编译时临时文件（.o/.d等文件）所在的目录，如果不设置则默认为tmp
#TMP_DIR ?= tmp
TMP_DIR ?= tmp

# 要包含的上层公共目录名列表，包含库目录、头文件目录等的目录名
#COMMON_DIR_NAMES += lib inc include com comment \
#					01-lib 01-inc 01-include 01-com 01-comment \
#					02-lib 02-inc 02-include 02-com 02-comment \
#					03-lib 03-inc 03-include 03-com 03-comment
COMMON_DIR_NAMES ?= lib inc include com comment \
					01-lib 01-inc 01-include 01-com 01-comment \
					02-lib 02-inc 02-include 02-com 02-comment \
					03-lib 03-inc 03-include 03-com 03-comment

# 头文件目录名列表，INC_DIR_NAMES是COMMON_DIR_NAMES的子集，
# 一旦设置了本变量，makefile只将其及其子目录加入编译参数-I中。
# 如果不设置，makefile会自动搜含有头文件的目录加入编译参数-I中。
#INC_DIR_NAMES ?= inc include 01-inc 01-include 02-inc 02-include 03-inc 03-include
INC_DIR_NAMES ?=

# 要排除的目录名列表，比如文档目录、备份目录等
#EXCLUDE_DIR_NAMES += .git tmp temp doc docs bak
EXCLUDE_DIR_NAMES ?= .git tmp temp doc docs bak

############################################################
# TARGET后置处理及杂项设置
############################################################
# makefile所在目录的全路径名称
CUR_DIR ?= $(shell pwd)
# makefile所在的目录名称
CUR_DIR_NAME := $(notdir $(CUR_DIR))

# 如果是test目录，SRC_DIR则向上跳一层
ifeq ($(CUR_DIR_NAME),$(TEST_DIR_NAME))
SRC_DIR := $(shell dirname $(CUR_DIR))
else
SRC_DIR := $(CUR_DIR)
endif

# 如果没有手动设置TARGET，则设置为makefile所在的目录名称
ifeq ($(TARGET),)
TARGET := $(basename $(notdir $(SRC_DIR)))
ifeq ($(CUR_DIR_NAME),$(TEST_DIR_NAME))
TARGET := $(TARGET)_$(TEST_DIR_NAME)
endif
endif

# 是编译exec文件还是库文件
IS_LIB_TARGET := $(suffix $(TARGET))
# 目标文件是库文件？
ifneq ($(IS_LIB_TARGET),)
IS_LIB_TARGET := $(shell if [ $(IS_LIB_TARGET) = .a ] || [ $(IS_LIB_TARGET) = .so ]; then echo y; fi;)
endif

ifeq ($(IS_LIB_TARGET),y)
# 补充lib前缀
TARGET := $(if $(findstring lib,$(TARGET)),$(TARGET),lib$(TARGET))
TMP_TARGET := $(basename $(TARGET))
else
TMP_TARGET := $(TARGET)
endif

# 查找main文件
MAIN_FILE := $(shell find $(CUR_DIR) -maxdepth 1 -type f -iname 'main.c' -o -type f -iname 'main.cpp')
# 无main文件也不是编译库文件，则认为是总makefile功能
ifeq ($(MAIN_FILE)$(IS_LIB_TARGET),)
TARGET :=
MAKE_SUB := y
endif
# 入口参数ALL表示手动设置总makefile功能
ifeq ($(ALL),y)
MAKE_SUB := y
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
# 编译定义项及编译设置项的后置处理（非常用项，修改需谨慎）
############################################################

# c/c++编译器名称，默认为gcc，有cpp文件则被自动改为g++
CC  := $(CROSS_COMPILE)gcc
CXX := $(CROSS_COMPILE)g++
AR  := $(CROSS_COMPILE)ar
CC  := gcc
CXX := g++
AR  := ar
# 默认链接器是gcc，如果有cpp文件makefile会自动设置为g++
ifeq ($(suffix $(MAIN_FILE)),.cpp)
LD := $(CXX)
else
LD := $(CC)
endif

# 宏定义列表
# 转大写，+INC前缀
tmp := $(shell echo $(INCLUDE_MODULE_NAMES) | tr '[a-z]' '[A-Z]')
DEFS := $(DEFS) $(tmp:%=INC_%)
# 转大写，+EXC前缀
tmp := $(shell echo $(EXCLUDE_MODULE_NAMES) | tr '[a-z]' '[A-Z]')
DEFS := $(DEFS) $(tmp:%=EXC_%)
DEFS := $(DEFS:%=-D%)

# C代码编译设置标志
CCFLAGS += $(DEFS)
ifeq ($(DEBUG), y)
CCFLAGS += -ggdb -rdynamic -g
else
CCFLAGS += -O2 -s
endif
# 不使用到的符号不链接到目标文件中
CCFLAGS += -ffunction-sections -fdata-sections

# 链接标志和链接库设置（除TOP_MODULE_DIRS目录下的*.a和*.so文件之外的链接库设置）
# STATIC_LIB_FILES和DYNAMIC_LIB_FILES变量是makefile作用域里面的.a和.so文件列表，请一定保留
DYMAMIC_LDFLAGS := $(strip $(DYMAMIC_LDFLAGS))
STATIC_LDFLAGS := $(strip $(STATIC_LDFLAGS))
ifeq ($(DYMAMIC_LDFLAGS)$(STATIC_LDFLAGS),$(DYMAMIC_LDFLAGS))
# 纯动态链接模式
#LDFLAGS ?= -Wl,--as-needed -lrt -lpthread $(DYNAMIC_LIB_FILES) $(STATIC_LIB_FILES)
LDFLAGS ?= $(DYMAMIC_LDFLAGS) $(DYNAMIC_LIB_FILES) $(STATIC_LIB_FILES)
else ifeq ($(DYMAMIC_LDFLAGS)$(STATIC_LDFLAGS),$(STATIC_LDFLAGS))
# 纯静态链接模式
#LDFLAGS ?= -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive $(STATIC_LIB_FILES)
LDFLAGS ?= -static $(STATIC_LDFLAGS) $(STATIC_LIB_FILES)
else
# 动态静态混合链接模式
# 模板：LDFLAGS = -Wl,-Bstatic ... $(STATIC_LIB_FILES) -Wl,--as-needed -Wl,-Bdynamic ... $(DYNAMIC_LIB_FILES)
#LDFLAGS ?= -Wl,-Bstatic -lpthread $(STATIC_LIB_FILES) -Wl,--as-needed -Wl,-Bdynamic -lrt $(DYNAMIC_LIB_FILES)
LDFLAGS ?= -Wl,-Bstatic $(STATIC_LDFLAGS) $(STATIC_LIB_FILES) -Wl,-Bdynamic $(STATIC_LDFLAGS) $(DYNAMIC_LIB_FILES)
endif
LDFLAGS += -Wl,--gc-sections

# 编译动态库设置项
ifeq ($(suffix $(TARGET)),.so)
CCFLAGS += -fPIC
LDFLAGS += -shared
endif

# 最终CXXFLAGS包含CCFLAGS
CXXFLAGS += $(CCFLAGS)

# 检查编译so文件时，是否是错误设置为静态链接标志
CHECK_LDFLAGS := $(if $(findstring static,$(LDFLAGS)),'Error: build file(*.so) not use static flag',)

############################################################
# 文件和路径搜索部分（非常用项，修改需谨慎）
############################################################
INCLUDE_MODULE_NAMES := $(strip $(INCLUDE_MODULE_NAMES))
EXCLUDE_MODULE_NAMES := $(strip $(EXCLUDE_MODULE_NAMES))
COMMON_DIR_NAMES := $(strip $(COMMON_DIR_NAMES))
EXCLUDE_DIR_NAMES := $(strip $(EXCLUDE_DIR_NAMES))
SPACE :=
SPACE:= $(SPACE) $(SPACE)

# 如果是总makefile
ifneq ($(MAKE_SUB),)
# 不包含test目录名的排除目录名的列表
tmp := $(subst $(SPACE),\\\|,$(strip $(EXCLUDE_DIR_NAMES)))
# 执行make clean命令的makefile所在目录列表，包含test目录
MF_CLEAN_DIRS := $(dir $(shell find . -type f -iname Makefile | grep -v $(tmp)))
MF_CLEAN_DIRS := $(foreach dir,$(MF_CLEAN_DIRS),$(shell if [ ! $(dir) = ./ ]; then echo $(dir); fi;))
endif

# 要排除的目录名列表
EXCLUDE_DIR_NAMES += $(EXCLUDE_MODULE_NAMES) $(TEST_DIR_NAME)
EXCLUDE_DIR_NAMES := $(subst $(SPACE),\\\|,$(strip $(EXCLUDE_DIR_NAMES)))
# 如果是总makefile
ifneq ($(MAKE_SUB),)
# 执行make命令的makefile所在目录列表，不包含test目录
MF_MAKE_DIRS := $(dir $(shell find . -type f -iname Makefile | grep -v $(EXCLUDE_DIR_NAMES)))
MF_MAKE_DIRS := $(foreach dir,$(MF_MAKE_DIRS),$(shell if [ ! $(dir) = ./ ]; then echo $(dir); fi;))
endif

# 如果没设置临时，默认等于tmp
ifeq ($(TMP_DIR),)
TMP_DIR := tmp
endif

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

# 向上搜索COMMON_DIR_NAMES指定名称的公共目录，库文件编译除外
ifeq ($(IS_LIB_TARGET),)
COMMON_DIR_NAMES += $(INCLUDE_MODULE_NAMES)
tmp := $(strip $(subst /, ,$(subst $(PROJECT_ROOT_DIR),,$(SRC_DIR))))
tmp := $(shell Dirs=$(PROJECT_ROOT_DIR); \
			echo $$Dirs; \
			for dir in $(tmp); \
			do \
				Dirs=$$Dirs/$$dir; \
				echo $$Dirs; \
			done; \
		)
COMMON_DIRS := $(shell \
					for dir in $(tmp); \
					do \
						for name in $(COMMON_DIR_NAMES); \
						do \
							if [ -d $$dir/$$name ];then \
								echo $$dir/$$name; \
							fi; \
						done; \
					done; \
				)
endif

# 所有文件列表
SRC_DIRS += $(SRC_DIR)
ALL_FILES := $(shell find $(COMMON_DIRS) $(SRC_DIRS)  \
						-type f -name '*.h' -o -type f -name '*.hpp' \
						-o -type f -name '*.c' -o -type f -name '*.cpp' \
						-o -type f -name '*.a' -o -type f -name '*.so' \
						| grep -vw 'main.c\|main.cpp' \
						| grep -vw $(EXCLUDE_DIR_NAMES))
EXCLUDE_DIR_NAMES :=
ifeq ($(CUR_DIR_NAME),$(TEST_DIR_NAME))
ALL_FILES += $(shell find $(SUR_DIR) -type f -name '*.h' -o -type f -name '*.hpp' \
						-o -type f -name '*.c' -o -type f -name '*.cpp' \
						-o -type f -name '*.a' -o -type f -name '*.so' \
						| grep -vw 'main.c\|main.cpp\|'$(TMP_DIR))
endif
ALL_FILES := $(sort $(ALL_FILES))

# 头文件所在目录
tmp := $(dir $(filter %.h %.hpp,$(ALL_FILES)))
tmp := $(shell dirs=/; \
			for item in $(tmp); \
			do \
				if [ ! $$item = $$dirs ]; then \
					echo $$item; \
					dirs=$$item; \
				fi; \
			done; \
		)
# 如果指定头文件目录名，则过滤掉其它的目录
ifneq ($(INC_DIR_NAMES),)
tmp := $(foreach item,$(tmp),\
			$(shell \
				isfind=n; \
				for name1 in $(subst /, ,$(item)); \
				do \
					for name2 in $(INC_DIR_NAMES); \
					do \
						if [ $$name1 = $$name2 ]; then \
							isfind=y; \
							break; \
						fi; \
					done; \
					if [ $$isfind = y ]; then \
						break; \
					fi; \
				done; \
				if [ $$isfind = y ]; then \
					echo $(item); \
				fi; \
			) \
		)
endif
INC_DIRS += $(tmp)
INC_DIRS := $(strip $(INC_DIRS))
INC_DIRS := $(INC_DIRS:%=-I%)

# 如果目标文件不是库文件
ifeq ($(IS_LIB_TARGET),)
# 所有库文件
LIB_FILES := $(filter %.a %.so,$(ALL_FILES))
# 所有库文件目录
LIB_DIRS += $(shell dirs=/; \
				for item in $(dir $(LIB_FILES)); \
				do \
					if [ ! $$item = $$dirs ]; then \
						echo $$item; \
						dirs=$$item; \
					fi; \
				done; \
			)
LIB_DIRS := $(strip $(LIB_DIRS))
# 库文件列表
LIB_FILES := $(notdir $(LIB_FILES))
# 如果是交叉编译，则使用交叉编译链的库文件并排除同名的非交叉编译链的库文件
ifneq ($(CROSS_COMPILE),)
tmp := $(foreach name,$(LIB_FILES),$(if $(findstring $(CROSS_COMPILE_LIB_KEY),$(name)),$(name),))
tmp := $(subst $(CROSS_COMPILE_LIB_KEY),,$(tmp))
LIB_FILES := $(foreach name1,$(LIB_FILES),\
				$(shell isfind=n; \
					for name2 in $(tmp); \
					do \
						if [ $(name1) = $$name2 ]; then \
							isfind=y; \
						fi; \
					done; \
					if [ $$isfind = n ]; then \
						echo $(name1); \
					fi; \
				) \
			)
else
# 不是交叉编译链，排除交叉编译链的库文件
LIB_FILES := $(foreach name,$(LIB_FILES),$(if $(findstring $(CROSS_COMPILE_LIB_KEY),$(name)),,$(name)))
endif
# 静态库文件列表
STATIC_LIB_FILES := $(filter %.a,$(LIB_FILES))
STATIC_LIB_FILES := $(STATIC_LIB_FILES:lib%.a=-l%)
# 动态库文件列表
DYNAMIC_LIB_FILES := $(filter %.so,$(LIB_FILES))
LIB_FILES :=
DYNAMIC_LIB_FILES := $(DYNAMIC_LIB_FILES:lib%.so=-l%)
endif # ifeq ($(IS_LIB_TARGET),)

# 源文件目录及obj文件列表
OBJ_FILES := $(filter %.c %.cpp,$(ALL_FILES))
#SRC_DIRS := $(shell dirs=/; \
#				for item in $(dir $(SRC_FILES)); \
#				do \
#					if [ ! $$item = $$dirs ]; then \
#						echo $$item; \
#						dirs=$$item; \
#					fi; \
#				done; \
#			)
ifneq ($(LIB_DIRS),)
# 过滤译库文件(.a/.so)的源码文件
OBJ_FILES := $(foreach name,$(OBJ_FILES), \
				$(shell \
					dir1=$(dir $(name)); \
					isfind=n; \
					for dir2 in $(LIB_DIRS); \
					do \
						if [ $$dir1 = $$dir2 ]; then \
							isfind=y; \
							break; \
						fi; \
					done; \
					if [ $$isfind = n ]; then \
						echo $(name); \
					fi; \
				) \
			)
endif
# .o文件列表
TMP_DIR := $(TMP_DIR)/
OBJ_FILES := $(OBJ_FILES:%.c=$(TMP_DIR)%.o)
OBJ_FILES := $(OBJ_FILES:%.cpp=$(TMP_DIR)%.o)
MAIN_FILE := $(MAIN_FILE:%.c=$(TMP_DIR)%.o)
MAIN_FILE := $(MAIN_FILE:%.cpp=$(TMP_DIR)%.o)

# 所有库目录
LIB_DIRS := $(LIB_DIRS:%=-L%)

# *.c/*/cpp文件搜索的目录，用于编译设置
#VPATH := $(SRC_DIRS)

# 临时库文件，将所有.o文件合并为一个临时.a文件，再和main.o文件链接，
# 避免链接进无用符号造成TARGET文件体积臃肿。
TMP_LIB_TARGET := libtmp.a
TMP_LDFLAGS := -L$(TMP_DIR) $(TMP_LIB_TARGET:lib%.a=-l%)

############################################################
# 链接成最终文件
############################################################
all: FIRST_EXEC $(TARGET)

FIRST_EXEC:
ifdef DEB
	@echo 'ALL_FILES:'$(ALL_FILES)
	@echo '**************************************'
	@echo 'CUR_DIR:'$(CUR_DIR)
	@echo '**************************************'
	@echo 'SRC_DIR:'$(SRC_DIR)
	@echo '**************************************'
	@echo 'COMMON_DIRS:'$(COMMON_DIRS)
	@echo '**************************************'
	@echo 'LIB_DIRS:'$(LIB_DIRS)
	@echo '**************************************'
	@echo 'STATIC_LIB_FILES:'$(STATIC_LIB_FILES)
	@echo '**************************************'
	@echo 'DYNAMIC_LIB_FILES:'$(DYNAMIC_LIB_FILES)
	@echo '**************************************'
	@echo 'INC_DIRS:'$(INC_DIRS)
	@echo '**************************************'
	@echo 'OBJ_FILES:'$(OBJ_FILES)
	@echo '**************************************'
endif
#*********************************************
# 总makefile模式，编译子目录下的所有makefile
ifneq ($(MF_MAKE_DIRS),)
	@$(STEP_INFO) '[step] submakefile is making...'
	@for dir in $(MF_MAKE_DIRS); do $(MAKE) -C $$dir; done;
	@$(STEP_INFO) '[step] submakefile make done'
endif

#*********************************************
# 生成exec程序
$(TMP_TARGET): $(TMP_DIR)$(TMP_LIB_TARGET) $(MAIN_FILE)
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Building exec file: '$@
	$(BUILD_INFO)$(LD) -o $@ $^ $(TMP_LDFLAGS) $(LIB_DIRS) $(LDFLAGS)
ifneq ($(LOAD_LIB_PATH),)
# 如果调用到.so文件，请执行以下命令设置库文件的搜索路径变量:LD_LIBRARY_PATH
	@echo '**********************************************************'
	@echo
	@echo 'Please execute the following command to load the LIB path, if you use it(.so):'
	@echo 'LD_LIBRARY_PATH=$(LOAD_LIB_PATH) && export LD_LIBRARY_PATH'
	@echo
endif

#*********************************************
# 生成临时静态库文件
$(TMP_DIR)$(TMP_LIB_TARGET): $(OBJ_FILES)
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Building temp static lib file: '$@
	$(BUILD_INFO)$(AR) $(ARFLAGS) -o $@ $^

#*********************************************
# 生成静态库文件
$(TMP_TARGET).a: $(OBJ_FILES)
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Building static lib file: '$@
	$(BUILD_INFO)$(AR) $(ARFLAGS) -o $@ $^

#*********************************************
# 生成动态库文件
$(TMP_TARGET).so: $(OBJ_FILES)
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Building dynamic lib file: '$@
ifneq ($(CHECK_LDFLAGS),)
	@echo $(CHECK_LDFLAGS)
endif
	$(BUILD_INFO)$(LD) -o $@ $^ $(LIB_DIRS) $(LDFLAGS) $(DYNC_FLAGS)

#*********************************************
# 编译c代码文件
$(TMP_DIR)%.o: %.c
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Compiling c file: '$<
	@$(MKDIR) $(dir $@)
	$(BUILD_INFO)$(CC) $(CCFLAGS) -c $< -o $@ $(INC_DIRS)

#*********************************************
# 编译c++代码文件
$(TMP_DIR)%.o: %.cpp
ifeq ($(INFO),1)
	@echo '**************************************'
endif
	@$(STEP_INFO) '[step] Compiling cpp file: '$<
	@$(MKDIR) $(dir $@)
	$(BUILD_INFO)$(CXX) $(CXXFLAGS) -c $< -o $@ $(INC_DIRS)

#*********************************************
# 头文件关联
-include $(OBJ_FILES:.o=.d)

############################################################
# 清理临时文件
############################################################
clean:
ifneq ($(MF_CLEAN_DIRS),)
# 总makefile模式
	@$(STEP_INFO) '[step] submakefile cleaning...'
	@for dir in $(MF_CLEAN_DIRS); do $(MAKE) -C $$dir clean; done;
	@$(STEP_INFO) '[step] submakefile cleaned'
endif
#*********************************************
# 不删除库目标文件
ifeq ($(IS_LIB_TARGET),)
	@if [ -f $(TARGET) ]; then $(RM) -f $(TARGET); fi;
endif
# 子makefile模式，删除临时目录
	@if [ -d $(TMP_DIR) ]; then $(RM) -r $(TMP_DIR); fi;
	@echo '[step] cleaned'

.PHONY: all clean


