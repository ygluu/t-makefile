#! /bin/bash 

mfs=$(find ./tmf-demo-project/multi-process1 ./tmf-demo-project/multi-process2 -type f -name 'Makefile' -o -type f -name 'build.mk')
for fn in $mfs;
do
	echo "makefile update to: "$fn
	rm -f $fn
	cp ./$(basename $fn) $fn
done

rm -f ./tmf-demo-project/single-process/Makefile
cp ./build.mk ./tmf-demo-project/single-process/Makefile

# multi-process1使用目录根目录名
sed -i 's|^PROJECT_ROOT_DIR_NAME ?=.*$|PROJECT_ROOT_DIR_NAME ?= tmf-demo-project|g' ./tmf-demo-project/multi-process1/build.mk

# multi-process2目录是模拟标准目录结构的项目
sed -i 's|^INC_DIR_NAMES ?=.*$|INC_DIR_NAMES ?= inc include 01-inc 01-include 02-inc 02-include 03-inc 03-include|g' ./tmf-demo-project/multi-process2/build.mk

# multi-process1目录的Module2/test独立测试项目是模拟用到Module1模块的项目
sed -i 's|^INCLUDE_MODULE_NAMES +=.*$|INCLUDE_MODULE_NAMES += Module1|g' ./tmf-demo-project/multi-process1/client/Module2/test/Makefile

# multi-process2目录的Module2/test独立测试项目是模拟用到Module1模块的项目
sed -i 's|^INCLUDE_MODULE_NAMES +=.*$|INCLUDE_MODULE_NAMES += Module1|g' ./tmf-demo-project/multi-process2/src/client/src/Module2/test/Makefile

