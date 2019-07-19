#!/bin/sh

set -e
#set -x

echo "root_01.sh START"


if [ -f /x_script/root.pwd ] ; then
	cat /x_script/root.pwd | chpasswd -e
	rm -rf /x_script/root.pwd
fi


echo "root_01.sh END!!"
