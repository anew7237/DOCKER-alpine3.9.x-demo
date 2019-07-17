### https://github.com/anew7237/DOCKER-alpine3.9.x-demo/alpine-openresty

FROM anew7237/alpine3.9.x-anew:anewresty
ARG ALPINE_IMAGE_TAG="3.9.x"
ARG ALPINE_X_SUBNAME="openresty"
ARG ALPINE_X_VERSION="20190716a"
ARG ALPINE_X_MARKING="201907160000"


### RESTY_TARBALL_GETTYPE: coderesty, testresty, anewresty
ARG RESTY_TARBALL_GETTYPE="anewresty"

### ### ANEW7237 END!!! ### ###


# Dockerfile - alpine
# https://github.com/openresty/docker-openresty

#ARG RESTY_IMAGE_BASE="alpine"
#ARG RESTY_IMAGE_TAG="3.9"

#FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

#LABEL maintainer="Evan Wies <evan@neomantra.net>"

# Docker Build Arguments
ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.9"
ARG RESTY_VERSION="1.15.8.1"
ARG RESTY_OPENSSL_VERSION="1.1.1c"
ARG RESTY_PCRE_VERSION="8.42"
ARG RESTY_J="1"
ARG RESTY_CONFIG_OPTIONS="\
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
	--add-module=/tmp/replace-filter-nginx-module \
	--http-proxy-temp-path=/x_husers/proxy_temp \
	--http-client-body-temp-path=/x_husers/client_temp \
	--http-fastcgi-temp-path=/x_husers/fastcgi_temp \
	--http-uwsgi-temp-path=/x_husers/uwsgi_temp \
	--http-scgi-temp-path=/x_husers/scgi_temp \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""
ARG RESTY_ADD_PACKAGE_BUILDDEPS=""
ARG RESTY_ADD_PACKAGE_RUNDEPS=""
ARG RESTY_EVAL_PRE_CONFIGURE=""
ARG RESTY_EVAL_POST_MAKE=""

LABEL resty_image_base="${RESTY_IMAGE_BASE}"
LABEL resty_image_tag="${RESTY_IMAGE_TAG}"
LABEL resty_version="${RESTY_VERSION}"
LABEL resty_openssl_version="${RESTY_OPENSSL_VERSION}"
LABEL resty_pcre_version="${RESTY_PCRE_VERSION}"
LABEL resty_config_options="${RESTY_CONFIG_OPTIONS}"
LABEL resty_config_options_more="${RESTY_CONFIG_OPTIONS_MORE}"
LABEL resty_add_package_builddeps="${RESTY_ADD_PACKAGE_BUILDDEPS}"
LABEL resty_add_package_rundeps="${RESTY_ADD_PACKAGE_RUNDEPS}"
LABEL resty_eval_pre_configure="${RESTY_EVAL_PRE_CONFIGURE}"
LABEL resty_eval_post_make="${RESTY_EVAL_POST_MAKE}"

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-openssl=/tmp/openssl-${RESTY_OPENSSL_VERSION} --with-pcre=/tmp/pcre-${RESTY_PCRE_VERSION}"


### ### ANEW7237 START ### ###
ARG RESTY_TARBALL_VERSION="$RESTY_VERSION"
ARG RESTY_NGINX_VERSION="1.15.8"
LABEL description="Alpine ${ALPINE_IMAGE_TAG} + OpenResty(TarBall)" \
	maintainer="Andrew Hsieh<anew7237@gmail.com>" \
	ALPINE_X_${ALPINE_X_SUBNAME}_version="${ALPINE_X_VERSION} - ${ALPINE_X_MARKING}" \
	ALPINE_X_${ALPINE_X_SUBNAME}_openresty="${RESTY_TARBALL_VERSION} Build from TarBall" \
	ALPINE_X_${ALPINE_X_SUBNAME}_redis="apk add redis"

RUN echo "##### ##### ##### #####" >> /_dockerDebug.log \
	&& mkdir -p /x_htdocs && chmod 775 /x_htdocs \
	&& mkdir -p /x_husers && chmod 775 /x_husers \
	&& mkdir -p /x_husers/proxy_temp \
	&& mkdir -p /x_husers/client_temp \
	&& mkdir -p /x_husers/fastcgi_temp \
	&& mkdir -p /x_husers/uwsgi_temp \
	&& mkdir -p /x_husers/scgi_temp \
	&& mkdir -p /x_husers/nginx_logs \
	&& addgroup -S -g 990 husers \
	&& adduser -S -D -H -h /x_husers -s /bin/false -g "nginx" -G husers -u 991 nginx \
	&& chmod 770 /x_husers/* && chown -R nginx:husers /x_husers \
	&& mkdir -p /etc/nginx/conf && chmod 775 /etc/nginx/conf \
	&& mkdir -p /etc/nginx/conf.d && chmod 775 /etc/nginx/conf.d \
	&& echo "$(date -u) ${ALPINE_X_MARKING} Alpine${ALPINE_IMAGE_TAG}-${ALPINE_X_SUBNAME}:${ALPINE_X_VERSION}" >> /_dockerDebug.log

COPY _COPY_/x_htdocs/default			/x_htdocs/default
COPY _COPY_/etc/nginx/conf/* 			/etc/nginx/conf/
COPY _COPY_/etc/nginx/conf.d/*			/etc/nginx/conf.d/
COPY _COPY_/etc/supervisor.d/20-redis.ini	/etc/supervisor.d/20-redis.ini
COPY _COPY_/etc/supervisor.d/40-nginx.ini	/etc/supervisor.d/40-nginx.ini

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        coreutils \
        curl \
        gd-dev \
        geoip-dev \
        libxslt-dev \
        linux-headers \
        make \
        perl-dev \
        readline-dev \
        zlib-dev \
        ${RESTY_ADD_PACKAGE_BUILDDEPS} \
    && apk add --no-cache \
        gd \
        geoip \
        libgcc \
        libxslt \
        zlib \
        ${RESTY_ADD_PACKAGE_RUNDEPS} \
    && cd /tmp \
    && if [ -n "${RESTY_EVAL_PRE_CONFIGURE}" ]; then eval $(echo ${RESTY_EVAL_PRE_CONFIGURE}); fi \
	\
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/openresty-${RESTY_TARBALL_VERSION}.tgz 	./openresty-${RESTY_TARBALL_VERSION}.tar.gz	;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/openresty-${RESTY_TARBALL_VERSION}.tar.gz 	./openresty-${RESTY_TARBALL_VERSION}.tar.gz	;\
	 else \
		curl -fSL https://openresty.org/download/openresty-${RESTY_TARBALL_VERSION}.tar.gz -o openresty-${RESTY_TARBALL_VERSION}.tar.gz ;\
	   fi \
	&& tar -xzf openresty-${RESTY_TARBALL_VERSION}.tar.gz \
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/openssl-${RESTY_OPENSSL_VERSION}.tgz	./openssl-${RESTY_OPENSSL_VERSION}.tar.gz	\
		&& sed -i "s#    . auto/lib/openssl/make.*#    . auto/lib/openssl/make.anew#g"	./openresty-${RESTY_TARBALL_VERSION}/bundle/nginx-${RESTY_NGINX_VERSION}/auto/lib/make		\
		&& cp /x_resty/nginx-1.15.8-anew/auto/lib/openssl/make.anew			./openresty-${RESTY_TARBALL_VERSION}/bundle/nginx-${RESTY_NGINX_VERSION}/auto/lib/openssl/	;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/openssl-${RESTY_OPENSSL_VERSION}.tar.gz	./openssl-${RESTY_OPENSSL_VERSION}.tar.gz	;\
	 else \
		curl -fSL https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz -o openssl-${RESTY_OPENSSL_VERSION}.tar.gz ;\
	   fi \
	&& tar -xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/pcre-${RESTY_PCRE_VERSION}.tgz 		./pcre-${RESTY_PCRE_VERSION}.tar.gz		\
		&& sed -i "s#    . auto/lib/pcre/make.*#    . auto/lib/pcre/make.anew#g" 	./openresty-${RESTY_TARBALL_VERSION}/bundle/nginx-${RESTY_NGINX_VERSION}/auto/lib/make		\
		&& cp /x_resty/nginx-1.15.8-anew/auto/lib/pcre/make.anew			./openresty-${RESTY_TARBALL_VERSION}/bundle/nginx-${RESTY_NGINX_VERSION}/auto/lib/pcre/		;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/pcre-${RESTY_PCRE_VERSION}.tar.gz 		./pcre-${RESTY_PCRE_VERSION}.tar.gz		;\
	 else \
		curl -fSL https://ftp.pcre.org/pub/pcre/pcre-${RESTY_PCRE_VERSION}.tar.gz -o pcre-${RESTY_PCRE_VERSION}.tar.gz ;\
	   fi \
	&& tar -xzf pcre-${RESTY_PCRE_VERSION}.tar.gz \
	\
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/sregex.20190711.tgz		. \
		&& tar -xzf sregex.20190711.tgz		\
		&& cd sregex && git fetch && cd /tmp/ ;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/sregex.20190711.tar.gz	. \
		&& tar -xzf sregex.20190711.tar.gz	;\
	 else \
		git clone https://github.com/openresty/sregex.git ;\
	   fi \
	&& cd sregex && make && make install && cd /tmp/ \
	\
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/replace-filter-nginx-module.20190711.tgz		. \
		&& tar -xzf replace-filter-nginx-module.20190711.tgz		\
		&& cd replace-filter-nginx-module && git fetch && cd .. ;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/replace-filter-nginx-module.20190711.tar.gz		. \
		&& tar -xzf replace-filter-nginx-module.20190711.tar.gz		;\
	 else \
		git clone https://github.com/openresty/replace-filter-nginx-module.git ;\
	   fi \
		\
	&& if [ "${RESTY_TARBALL_GETTYPE}" == "coderesty" ] ; then \
		mv /x_resty/ngx_brotli.20190711.tgz		. \
		&& tar -xzf ngx_brotli.20190711.tgz		\
		&& cd ngx_brotli && git fetch && cd /tmp/ ;\
	 elif [ "${RESTY_TARBALL_GETTYPE}" == "testresty" ] ; then \
		mv /x_resty/ngx_brotli.20190711.tar.gz		. \
		&& tar -xzf ngx_brotli.20190711.tar.gz		;\
	 else \
		git clone https://github.com/google/ngx_brotli.git ;\
	   fi \
	\
	&& cd /tmp/openresty-${RESTY_TARBALL_VERSION} \
	&& if [ "${RESTY_TARBALL_GETTYPE}" != "coderesty" ] ; then \
		echo "Patching Nginx ${RESTY_NGINX_VERSION}" \
		&& if [[ "1.1.1" == $(echo -e "${RESTY_OPENSSL_VERSION}\n1.1.1" | sort -V | head -n1) ]] ; then \
			echo 'Patching Nginx for OpenSSL 1.1.1' \
			&& cd bundle/nginx-${RESTY_NGINX_VERSION} \
			&& curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-${RESTY_NGINX_VERSION}-ssl_cert_cb_yield.patch | patch -p1 \
			&& curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-${RESTY_NGINX_VERSION}-ssl_sess_cb_yield.patch | patch -p1 \
			&& cd ../.. ;\
		fi \
		&& echo "Patching Nginx !!!DONE!!!" ;\
	   fi \
    && ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install \
    && apk del .build-deps \
    && if [ -n "${RESTY_EVAL_POST_MAKE}" ]; then eval $(echo ${RESTY_EVAL_POST_MAKE}); fi \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log \
	\
	&& apk add --no-cache redis \
	&& rm -rf /x_resty \
	&& rm -rf /var/cache/apk/*.apk && rm -rf /tmp/* && echo "$(date -u) ${ALPINE_X_MARKING} !!!DONE!!!" >> /_dockerDebug.log
### ### ANEW7237 END!! ### ###

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

# Copy nginx configuration files
#COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
#COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT


### ### ANEW7237 START ### ###

# Test Nginx
RUN nginx -c /etc/nginx/conf/nginx.conf -t

EXPOSE 80 443
