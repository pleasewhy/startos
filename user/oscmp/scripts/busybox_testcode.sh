#!/bin/bash

RST=result.txt
if [ -f $RST ];then
	busybox rm $RST
fi
busybox touch $RST
echo "start test"
echo "If the CMD runs incorrectly, return value will put in $RST" >> $RST
# busybox cat $RST
busybox echo -e "Else nothing will put in $RST\n" >> $RST
busybox echo "TEST START" >> $RST

busybox cat ./busybox_cmd.txt | while read line
do
	eval "busybox $line"
	RTN=$?
	if [[ $RTN -ne 0 && $line != "false" ]] ;then
		echo "testcase busybox $line fail"
		# echo "return: $RTN, cmd: $line" >> $RST
	else
		echo "testcase busybox $line success"
	fi
done

echo "TEST END" >> $RST
