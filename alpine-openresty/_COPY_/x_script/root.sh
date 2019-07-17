#!/bin/sh

set -xe

echo "root.sh START"

if [ -f /x_script/etc/resolv.conf ] && [ "$(cat /x_script/etc/resolv.conf | grep '###ANEW:')" != "$(cat /etc/resolv.conf | grep '###ANEW:')" ]  ; then
	cat /x_script/etc/resolv.conf > /etc/resolv.conf
fi

echo "root.sh End!!"



set +e

printf "\n\033[1;1mRunning Nginx PHP-FPM web mode\033[0m\n\n"

# printf "%-30s %-30s\n" "Key" "Value"

# Container info:
printf "%-30s %-30s\n" "Site:" "$SITE_NAME"
if [ ! -z "$SITE_NAME" ]; then SITE_NAME="TEST_NAME" ;fi

printf "%-30s %-30s\n" "Branch:" "$SITE_BRANCH"
if [ ! -z "$SITE_BRANCH" ]; then SITE_NAME="TEST_BRANCH" ;fi

printf "%-30s %-30s\n" "Environment:" "$ENVIRONMENT"
if [ ! -z "$ENVIRONMENT" ]; then ENVIRONMENT="qa" ;fi

# Enable Nginx
#cp /etc/supervisor.d/nginx.conf /etc/supervisord-enabled/

# Enable PHP-FPM
#cp /etc/supervisor.d/php-fpm.conf /etc/supervisord-enabled/

# Whether to send cache headers automatically for PHP scripts
if [ ! -z "$PHP_DISABLE_CACHE_HEADERS" ]; then
    sed -i -e "s#session.cache_limiter = nocache#session.cache_limiter = ''#g" /etc/php/php.ini
fi

# Version numbers:
printf "%-30s %-30s\n" "PHP Version:" "`php -r 'echo phpversion();'`"
printf "%-30s %-30s\n" "Nginx Version:" "`/usr/sbin/nginx -v 2>&1 | sed -e 's/nginx version: nginx\///g'`"


# PHP Max Memory
# If set
if [ ! -z "$PHP_MEMORY_MAX" ]; then
    # Set PHP.ini accordingly
    sed -i -e "s#memory_limit = 128M#memory_limit = ${PHP_MEMORY_MAX}M#g" /etc/php/php.ini
fi

# Print the real value
printf "%-30s %-30s\n" "PHP Memory Max:" "`php -r 'echo ini_get("memory_limit");'`"

# PHP Opcache
# If not set
if [ -z "$DISABLE_OPCACHE" ]; then
    printf "%-30s %-30s\n" "PHP Opcache:" "Enabled"

fi
# If set
if [ ! -z "$DISABLE_OPCACHE" ]; then
    printf "%-30s %-30s\n" "PHP Opcache:" "Disabled"
    # Set PHP.ini accordingly
    sed -i -e "s#opcache.enable=1#opcache.enable=0#g" /etc/php/php.ini
    sed -i -e "s#opcache.enable_cli=1#opcache.enable_cli=0#g" /etc/php/php.ini

fi

# PHP Opcache Memory
# If set
if [ ! -z "$PHP_OPCACHE_MEMORY" ]; then
    
    # Set PHP.ini accordingly
    sed -i -e "s#opcache.memory_consumption=16#opcache.memory_consumption=${PHP_OPCACHE_MEMORY}#g" /etc/php/php.ini

fi

# Print the real value
printf "%-30s %-30s\n" "Opcache Memory Max:" "`php -r 'echo ini_get("opcache.memory_consumption");'`M"

# PHP Session Config
# If set
if [ ! -z "$PHP_SESSION_STORE" ]; then
    
    # Figure out which session save handler is in use, currently only supports redis
    if [ $PHP_SESSION_STORE == 'redis' ] || [ $PHP_SESSION_STORE == 'REDIS' ]; then
        if [ -z $PHP_SESSION_STORE_REDIS_HOST ]; then
            PHP_SESSION_STORE_REDIS_HOST='redis'
        fi
        if [ -z $PHP_SESSION_STORE_REDIS_PORT ]; then
            PHP_SESSION_STORE_REDIS_PORT='6379'
        fi
        printf "%-30s %-30s\n" "PHP Sessions:" "Redis"
        printf "%-30s %-30s\n" "PHP Redis Host:" "$PHP_SESSION_STORE_REDIS_HOST"
        printf "%-30s %-30s\n" "PHP Redis Port:" "$PHP_SESSION_STORE_REDIS_PORT"
        sed -i -e "s#session.save_handler = files#session.save_handler = redis\nsession.save_path = \"tcp://$PHP_SESSION_STORE_REDIS_HOST:$PHP_SESSION_STORE_REDIS_PORT\"#g" /etc/php/php.ini
    fi

fi

# Max Execution Time
# If set
if [ ! -z "$MAX_EXECUTION_TIME" ]; then
    # Set PHP.ini accordingly
    sed -i -e "s#max_execution_time = 600#max_execution_time = ${MAX_EXECUTION_TIME}#g" /etc/php/php.ini

    # Modify the nginx read timeout
    sed -i -e "s#fastcgi_read_timeout 600s;#fastcgi_read_timeout ${MAX_EXECUTION_TIME}s;#g" /etc/nginx/sites-enabled/site.conf
fi

# Print the value
printf "%-30s %-30s\n" "Nginx Max Read:" "`cat /etc/nginx/sites-enabled/site.conf | grep 'fastcgi_read_timeout' | sed -e 's/fastcgi_read_timeout//g'`"

# Print the value
printf "%-30s %-30s\n" "PHP Max Execution Time:" "`cat /etc/php/php.ini | grep 'max_execution_time = ' | sed -e 's/max_execution_time = //g'`"

# PHP-FPM Max Workers
# If set
if [ ! -z "$PHP_FPM_WORKERS" ]; then
    # Set PHP.ini accordingly
    sed -i -e "s#pm.max_children = 4#pm.max_children = $PHP_FPM_WORKERS#g" /etc/php/php-fpm.d/www.conf

fi

# Nginx custom snippets
if [ -f /etc/nginx/custom.conf ]; then
    printf "%-30s %-30s\n" "Custom Nginx Snippet:" "Enabled"
    /usr/bin/php /usr/local/bin/nginx-custom
fi

if [ ! -f /etc/nginx/custom.conf ]; then
    printf "%-30s %-30s\n" "Custom Nginx Snippet:" "Not Found"
fi

# Set SMTP settings
if [ $ENVIRONMENT == 'production' ]; then
    printf "%-30s %-30s\n" "SMTP:" "master-smtp.smtp-production:25"
    sed -i -e "s#sendmail_path = /usr/sbin/sendmail -t -i#sendmail_path = /usr/sbin/sendmail -t -i -S master-smtp.smtp-production:25#g" /etc/php/php.ini
    
    if [ -z "$MAIL_HOST" ]; then
        export MAIL_HOST=master-smtp.smtp-production
    fi

    if [ -z "$MAIL_PORT" ]; then
        export MAIL_PORT=25
    fi
fi

if [ $ENVIRONMENT == 'qa' ]; then
    printf "%-30s %-30s\n" "SMTP:" "master-smtp.mailhog-production:25"
    sed -i -e "s#sendmail_path = /usr/sbin/sendmail -t -i#sendmail_path = /usr/sbin/sendmail -t -i -S master-smtp.mailhog-production:25#g" /etc/php/php.ini
    
    if [ -z "$MAIL_HOST" ]; then
        export MAIL_HOST=master-smtp.mailhog-production
    fi

    if [ -z "$MAIL_PORT" ]; then
        export MAIL_PORT=25
    fi
fi

if [ -z "$MAIL_DRIVER" ]; then
    export MAIL_DRIVER=mail
fi



# Print the value
printf "%-30s %-30s\n" "PHP-FPM Max Workers:" "`cat /etc/php/php-fpm.d/www.conf | grep 'pm.max_children = ' | sed -e 's/pm.max_children = //g'`"
# End PHP-FPM



# Start supervisord and services
printf "\n\033[1;1mStarting supervisord\033[0m\n\n"
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
