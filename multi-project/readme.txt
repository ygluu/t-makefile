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


二、目录说明
本级目录为项目级的目录，拥有不同的进程目录。
01-lib: 本级目录及子目录源码使用到的公共库（含头*.h/*.c/*.h）
02-com: 本级目录及子目录（除lib外）各个进程间的接口文件（含头*.h/*.c/*.h）
client：模拟的客户端源码
server：模拟的服务端源码


三、手动增加模块示例（设置TOP_MODULE_DIR_NAMES）：
client/Module2/test/Makefile

四、update-mf.sh文件
update-mf.sh脚本文件是把当前的makefile文件替换子目录的makefile文件，
使用时请注意他会覆盖子目录的makefile文件。


五、build.mk文件
build.mk文件内容可以独立成为一个makefile



