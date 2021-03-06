#!/bin/sh
###ANEW:20190904a

set -e
#set -x

PATH_SCRIPT_THIS=$(readlink -f "$0")
printf "\033[1;1m vvv START $PATH_SCRIPT_THIS vvv \033[0m\n"


### Hosts Backup
if [ ! -f /etc/hosts.docker ] ; then
	cat /etc/hosts > /etc/hosts.docker
fi


### Resolv & Bind9 Reset
ANEW_DATETIME_STRING=`date +"%Y-%m-%dT%H:%M:%SZ"`
if [ ! -f /etc/resolv.conf.docker ] ; then
	cp /etc/resolv.conf /etc/resolv.conf.docker
	echo "###ANEW:$ANEW_DATETIME_STRING" > /etc/resolv.conf
	echo 'nameserver 127.0.0.1' >> /etc/resolv.conf
	echo 'options single-request-reopen' >> /etc/resolv.conf
	if [ ! -f /x_config/etc/resolv.conf ] ; then 
		cp /etc/resolv.conf /x_config/etc/resolv.conf
	fi

	ANEW_NAMESERVER_DOCKER=`grep '^nameserver ' /etc/resolv.conf.docker | sed -e 's#nameserver##g' | sed -e 's# ##g'`
	sed -i -e "s#forwarders { 127.0.0.11; };#forwarders { $ANEW_NAMESERVER_DOCKER; };#g" /var/bind/bind.conf
fi
printf "%-30s %-30s\n" "Bind9 Forwarders:" "`cat /var/bind/bind.conf | grep forwarders`"


### Resolv Sync Form /x_config/etc/resolv.conf
if [ -f /x_config/etc/resolv.conf ] && [ "$(cat /x_config/etc/resolv.conf | grep '###ANEW:')" != "$(cat /etc/resolv.conf | grep '###ANEW:')" ]  ; then
	cat /x_config/etc/resolv.conf > /etc/resolv.conf
fi
printf "%-30s %-30s\n" "Resolv (/etc/resolv.conf):"
cat /etc/resolv.conf


printf "\033[1;1m ^^^ END.. $PATH_SCRIPT_THIS ^^^ \033[0m\n"


/bin/sh /x_script/init.sh


# Start supervisord and services
printf "\n\033[1;1m >>> Starting supervisord <<< \033[0m\n\n"
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
