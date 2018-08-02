本示例项目示范了不同目录结构的项目，以及多项目时每个子项目可以有独立的build.mk
但又能使用共同的库目录（tmf-demo-project/01-lib）和公共目录的项目（tmf-demo-project/02-com）。

一、目录说明：

1、01-lib：各个子项目的用到的库
2、02-com：各个子项目的公共部分
3、multi-process1：简约目录结构的多进程项目工程，设置了项目根目录名（tmf-demo-project）
   所以可以用到tmf-demo-project/02-com目录
4、multi-process2：标准目录结构的多进程项目工程
5、single-process：单一进程的项目工程
