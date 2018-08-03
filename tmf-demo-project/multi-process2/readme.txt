一、目录说明
本级目录为项目级的目录，拥有不同的进程目录。
lib: 本级目录及子目录源码使用到的公共库（含头*.h/*.hpp/*.c/*.cpp）
inc: 本级目录及子目录（除lib外）各个进程间的接口文件（*.h/*.hpp）
client：模拟的客户端源码
server：模拟的服务端源码

二、update-mf.sh文件
update-mf.sh脚本文件是把当前的makefile文件替换子目录的makefile文件，
使用时请注意他会覆盖子目录的所有makefile文件。


三、build.mk文件
build.mk文件内容可以独立成为一个makefile



