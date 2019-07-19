#!/bin/sh

set -e
#set -x

echo "root.sh START"


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


### PHP and Nginx Version:
if [ ! -f /x_config/php.evn ]; then echo "###ANEW:$ANEW_DATETIME_STRING" > /x_config/php.evn ; fi
printf "%-30s %-30s\n" "Nginx Version:" "`/usr/local/openresty/nginx/sbin/nginx -v 2>&1 | sed -e 's/nginx version: nginx\///g'`"
printf "%-30s %-30s\n" "PHP Version:" "`php -r 'echo phpversion();'`"


### PHP Max Memory Limit
PHP_MAX_MEMORY_LIMIT=`grep '^PHP_MAX_MEMORY_LIMIT=' /x_config/php.evn | sed -e 's#PHP_MAX_MEMORY_LIMIT=##g' | sed -e 's# ##g'`
if [ ! -z "$PHP_MAX_MEMORY_LIMIT" ]; then
	sed -i -e "s#memory_limit = 128M#memory_limit = ${PHP_MAX_MEMORY_LIMIT}M#g" /etc/php/php.ini
fi
printf "%-30s %-30s\n" "PHP Max Memory Limit:" "`php -r 'echo ini_get("memory_limit");'`"


### PHP Max Execution Time
PHP_MAX_EXECUTION_TIME=`grep '^PHP_MAX_EXECUTION_TIME=' /x_config/php.evn | sed -e 's#PHP_MAX_EXECUTION_TIME=##g' | sed -e 's# ##g'`
if [ ! -z "$PHP_MAX_EXECUTION_TIME" ]; then
	sed -i -e "s#max_execution_time = 600#max_execution_time = ${PHP_MAX_EXECUTION_TIME}#g" /etc/php/php.ini

	# Modify the nginx read timeout
	sed -i -e "s#fastcgi_read_timeout 600s;#fastcgi_read_timeout ${PHP_MAX_EXECUTION_TIME}s;#g" /etc/nginx/conf.d/vh_default.conf
fi
printf "%-30s %-30s\n" "Nginx FastCgi Timeout:" "`cat /etc/nginx/conf.d/vh_default.conf | grep 'fastcgi_read_timeout' | sed -e 's/fastcgi_read_timeout//g'`"
printf "%-30s %-30s\n" "PHP Max Execution Time:" "`cat /etc/php/php.ini | grep 'max_execution_time = ' | sed -e 's/max_execution_time = //g'`"


### PHP Opcache
PHP_OPCACHE_DISABLE=`grep '^PHP_OPCACHE_DISABLE=' /x_config/php.evn | sed -e 's#PHP_OPCACHE_DISABLE=##g' | sed -e 's# ##g'`
if [ ! -z "$PHP_OPCACHE_DISABLE" ]; then
	printf "%-30s %-30s\n" "PHP Opcache:" "Disabled"
	sed -i -e "s#opcache.enable=1#opcache.enable=0#g" /etc/php/php.ini
	sed -i -e "s#opcache.enable_cli=1#opcache.enable_cli=0#g" /etc/php/php.ini
else
	printf "%-30s %-30s\n" "PHP Opcache:" "Enabled"
### PHP Opcache Memory
PHP_OPCACHE_MEMORY=`grep '^PHP_OPCACHE_MEMORY=' /x_config/php.evn | sed -e 's#PHP_OPCACHE_MEMORY=##g' | sed -e 's# ##g'`
	if [ ! -z "$PHP_OPCACHE_MEMORY" ]; then
		sed -i -e "s#opcache.memory_consumption=16#opcache.memory_consumption=${PHP_OPCACHE_MEMORY}#g" /etc/php/php.ini
	fi
	printf "%-30s %-30s\n" "Opcache Memory Max:" "`php -r 'echo ini_get("opcache.memory_consumption");'`M"
fi


### PHP Session Cache Header (Whether to send cache headers automatically for PHP scripts)
PHP_SESSION_CACHE_DISABLE=`grep '^PHP_SESSION_CACHE_DISABLE=' /x_config/php.evn | sed -e 's#PHP_SESSION_CACHE_DISABLE=##g' | sed -e 's# ##g'`
if [ ! -z "$PHP_SESSION_CACHE_DISABLE" ]; then
	sed -i -e "s#session.cache_limiter = nocache#session.cache_limiter = ''#g" /etc/php/php.ini
fi


### PHP Session Store (Figure out which session save handler is in use, currently only supports redis)
PHP_SESSION_STORE=`grep '^PHP_SESSION_STORE=' /x_config/php.evn | sed -e 's#PHP_SESSION_STORE=##g' | sed -e 's# ##g'`
if [ ! -z "$PHP_SESSION_STORE" ]; then
	if [ $PHP_SESSION_STORE == 'redis' ] || [ $PHP_SESSION_STORE == 'REDIS' ]; then
		printf "%-30s %-30s\n" "PHP Sessions:" "Redis"
### PHP Session Store To REDIS HOST
PHP_SESSION_STORE_REDIS_HOST=`grep '^PHP_SESSION_STORE_REDIS_HOST=' /x_config/php.evn | sed -e 's#PHP_SESSION_STORE_REDIS_HOST=##g' | sed -e 's# ##g'`
		if [ -z $PHP_SESSION_STORE_REDIS_HOST ]; then
			PHP_SESSION_STORE_REDIS_HOST='127.0.0.1'
		fi
		printf "%-30s %-30s\n" "PHP Redis Host:" "$PHP_SESSION_STORE_REDIS_HOST"
### PHP Session Store To REDIS PORT
PHP_SESSION_STORE_REDIS_PORT=`grep '^PHP_SESSION_STORE_REDIS_PORT=' /x_config/php.evn | sed -e 's#PHP_SESSION_STORE_REDIS_PORT=##g' | sed -e 's# ##g'`
		if [ -z $PHP_SESSION_STORE_REDIS_PORT ]; then
			PHP_SESSION_STORE_REDIS_PORT='6379'
		fi
		printf "%-30s %-30s\n" "PHP Redis Port:" "$PHP_SESSION_STORE_REDIS_PORT"
		sed -i -e "s#session.save_handler = files#session.save_handler = redis\nsession.save_path = \"tcp://$PHP_SESSION_STORE_REDIS_HOST:$PHP_SESSION_STORE_REDIS_PORT\"#g" /etc/php/php.ini
	fi
fi


echo "root.sh End!!"


# Start supervisord and services
printf "\n\033[1;1mStarting supervisord\033[0m\n\n"
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
