#!/bin/sh

set -xe

echo "root.sh START"

if [ -f /x_script/etc/resolv.conf ] && [ "$(cat /x_script/etc/resolv.conf | grep '###ANEW:')" != "$(cat /etc/resolv.conf | grep '###ANEW:')" ]  ; then
	cat /x_script/etc/resolv.conf > /etc/resolv.conf
fi

echo "root.sh End!!"

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
