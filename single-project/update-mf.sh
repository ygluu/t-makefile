#!/bin/bash
dirs=$(find ./ -maxdepth 1 -type d)
mfs=$(find $(dirs) -name "Makefile")
for fn in $mfs;
do
	if [ ! $(dirname $fn) = $(pwd) ]; then
		echo "makefile update to: "$fn
		rm -f $fn
		cp ./Makefile $fn
	fi
done
