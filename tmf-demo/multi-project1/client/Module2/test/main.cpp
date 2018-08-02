#include <iostream>

#include "Proto.h"
#include "Define.h"

#include "Module1.hpp"
#include "Module2.hpp"

int main()
{
	std::cout << CLUSTER_NAME"->" << PROS_NAME"[info]" << Module1::GetName() << std::endl;
	std::cout << CLUSTER_NAME"->" << PROS_NAME"[info]" << Module2::GetName() << std::endl;

	return 0;
}
