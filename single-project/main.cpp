#include <iostream>

extern "C" 
{
#include "md5.h"
#include "rsa.h"
} // extern "C" 
#include "crc.h"

#include "Proto.h"
#include "Define.h"

#include "Module1.hpp"
#include "Module2.hpp"

int main()
{
	#ifdef DEBUG
	std::cout << "is debug mod" << std::endl;
	#endif
	// 需要把so文件放在当前目前或者系统lib目录才能调用
	//GetCRC();
	GetMD5();
	GetRSA();

	std::cout << CLUSTER_NAME"->" << PROS_NAME"[info]" << Module1::GetName() << std::endl;
	std::cout << CLUSTER_NAME"->" << PROS_NAME"[info]" << Module2::GetName() << std::endl;

	return 0;
}
