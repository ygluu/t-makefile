#!/bin/bash

mfs=$(find multi-project1 multi-project2 -type f -name 'Makefile' -o -type f -name 'build.mk')
for fn in $mfs;
do
	echo "makefile update to: "$fn
	rm -f $fn
	cp ./$(basename $fn) $fn
done

rm -f ./single-project/Makefile
cp ./build.mk ./single-project/Makefile



# multi-project2目录是模拟标准目录结构的项目
sed -i 's|^INC_DIR_NAMES ?=.*$|INC_DIR_NAMES ?= inc include 01-inc 01-include 02-inc 02-include 03-inc 03-include|g' ./multi-project2/build.mk

# multi-project1目录的Module2/test独立测试项目是模拟用到Module1模块的项目
sed -i 's|^INCLUDE_MODULE_NAMES +=.*$|INCLUDE_MODULE_NAMES += Module1|g' ./multi-project1/client/Module2/test/Makefile

# multi-project2目录的Module2/test独立测试项目是模拟用到Module1模块的项目
sed -i 's|^INCLUDE_MODULE_NAMES +=.*$|INCLUDE_MODULE_NAMES += Module1|g' ./multi-project2/src/client/src/Module2/test/Makefile

