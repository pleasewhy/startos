#!/bin/bash
busybox cat ./busybox_cmd.txt | while read line
do
	eval "busybox $line"
	RTN=$?
	if [[ $RTN -ne 0 && $line != "false" ]] ;then
		echo "testcase busybox $line fail"
	else
		echo "testcase busybox $line success"
	fi
done