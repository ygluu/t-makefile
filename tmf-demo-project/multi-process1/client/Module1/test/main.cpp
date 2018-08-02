#include <iostream>

#include "Proto.h"
#include "Define.h"

#include "Module1.hpp"

int main()
{
	std::cout << CLUSTER_NAME"->" << PROS_NAME"[info]" << Module1::GetName() << std::endl;

	return 0;
}
