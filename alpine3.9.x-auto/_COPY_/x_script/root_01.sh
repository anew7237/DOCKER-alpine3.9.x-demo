#!/bin/bash
###ANEW:20190904a

set -e
#set -x

PATH_SCRIPT_THIS=$(readlink -f "$0")
printf "\033[1;1m vvv START $PATH_SCRIPT_THIS vvv \033[0m\n"


if [ -f /x_script/root.pwd ] ; then
	cat /x_script/root.pwd | chpasswd -e
	rm -rf /x_script/root.pwd
fi


printf "\033[1;1m ^^^ END.. $PATH_SCRIPT_THIS ^^^ \033[0m\n"
