#!/bin/bash

mfs=$(find . -name "Makefile")
for fn in $mfs;
do
	if [ ! $(dirname $fn) = . ]; then
		echo "makefile update to: "$fn
		rm -f $fn
		cp ./Makefile $fn
	fi
done
