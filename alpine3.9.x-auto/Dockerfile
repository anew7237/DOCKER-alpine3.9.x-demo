### https://github.com/anew7237/DOCKER-alpine3.9.x-demo/alpine3.9.x-auto

FROM anew7237/alpine3.9.x-sshd:latest
ARG ALPINE_IMAGE_TAG="3.9.x"
ARG ALPINE_X_SUBNAME="auto"
ARG ALPINE_X_VERSION="20190718a"
ARG ALPINE_X_MARKING="201907180000"

LABEL description="Alpine ${ALPINE_IMAGE_TAG} + Supervisor" \
	maintainer="Andrew Hsieh<anew7237@gmail.com>" \
	ALPINE_X_${ALPINE_X_SUBNAME}_version="${ALPINE_X_VERSION} - ${ALPINE_X_MARKING}" \
	ALPINE_X_${ALPINE_X_SUBNAME}_supervisor="apk add supervisor & copy /etc/supervisor.d/root.ini" \
	ALPINE_X_${ALPINE_X_SUBNAME}_cron="copy /etc/crontabs/root & copy /x_script/root.pwd" \
	ALPINE_X_${ALPINE_X_SUBNAME}_bash="apk add bash" \
	ALPINE_X_${ALPINE_X_SUBNAME}_sudo="apk add sudo" \
	ALPINE_X_${ALPINE_X_SUBNAME}_bash="apk add curl" \
	ALPINE_X_${ALPINE_X_SUBNAME}_bind="apk add bind & bind-tools" \
	ALPINE_X_${ALPINE_X_SUBNAME}_root="copy /x_script/root.pwd & chpasswd -e By /x_script/root.pwd"

RUN echo "##### ##### ##### #####" >> /_dockerDebug.log \
	&& mkdir -p /x_script && chmod 700 /x_script \
	&& mkdir -p /x_config && chmod 700 /x_config \
	&& mkdir -p /x_config/etc && mkdir -p /x_config/bind \
	&& echo "$(date -u) ${ALPINE_X_MARKING} Alpine${ALPINE_IMAGE_TAG}-${ALPINE_X_SUBNAME}:${ALPINE_X_VERSION}" >> /_dockerDebug.log

COPY _COPY_/x_script/*				/x_script/
COPY _COPY_/x_config/bind/*			/x_config/bind/
COPY _COPY_/etc/crontabs/root			/etc/crontabs/root
COPY _COPY_/etc/supervisor.d/00-root.ini	/etc/supervisor.d/00-root.ini
COPY _COPY_/etc/supervisor.d/05-bind.ini	/etc/supervisor.d/05-bind.ini
COPY _COPY_/etc/supervisor.d/10-sshd.ini	/etc/supervisor.d/10-sshd.ini
COPY _COPY_/etc/supervisor.d/50-crond.ini	/etc/supervisor.d/50-crond.ini

RUN apk update \
	&& apk add --no-cache supervisor \
	&& apk add --no-cache bash sudo curl \
	&& cd /x_script && chmod 700 *.sh && export X_SCRIPT="$(ls root_*.sh)" \
	&& for S in $X_SCRIPT ; do sh $S ; done \
	&& apk add --no-cache bind bind-tools \
	&& chmod -R 744 /x_config/bind && chown -R root:named /x_config/bind && mv /x_config/bind/* /var/bind/ \
	&& mkdir -p /var/log/named && chmod 770 /var/log/named  && chown -R root:named /var/log/named \
	&& rm -rf /var/cache/apk/*.apk && rm -rf /tmp/* && echo "$(date -u) ${ALPINE_X_MARKING} !!!DONE!!!" >> /_dockerDebug.log

EXPOSE 53/udp

CMD ["/x_script/root.sh"]
