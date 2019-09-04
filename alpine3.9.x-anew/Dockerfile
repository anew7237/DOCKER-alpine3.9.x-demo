### https://github.com/anew7237/DOCKER-alpine3.9.x-demo/alpine3.9.x-anew

FROM anew7237/alpine3.9.x-auto:latest
ARG ALPINE_IMAGE_TAG="3.9.x"
ARG ALPINE_X_SUBNAME="anewresty"
ARG ALPINE_X_VERSION="20190904a"
ARG ALPINE_X_MARKING="201909040000"


LABEL description="Alpine ${ALPINE_IMAGE_TAG} + AnewPackage" \
	maintainer="Andrew Hsieh<anew7237@gmail.com>" \
	ALPINE_X_${ALPINE_X_SUBNAME}_version="${ALPINE_X_VERSION} - ${ALPINE_X_MARKING}" \
	ALPINE_X_${ALPINE_X_SUBNAME}_maxmind="apk add libmaxminddb" \
	ALPINE_X_${ALPINE_X_SUBNAME}_redis="apk add redis" \
	ALPINE_X_${ALPINE_X_SUBNAME}_perl="apk add perl" \
	ALPINE_X_${ALPINE_X_SUBNAME}_git="apk add git"

RUN echo "##### ##### ##### #####" >> /_dockerDebug.log \
	&& mkdir -p /x_resty && chmod 700 /x_resty \
	&& echo "$(date -u) ${ALPINE_X_MARKING} Alpine${ALPINE_IMAGE_TAG}-${ALPINE_X_SUBNAME}:${ALPINE_X_VERSION}" >> /_dockerDebug.log

COPY _COPY_/etc/supervisor.d/20-redis.ini	/etc/supervisor.d/20-redis.ini

RUN apk update \
	&& apk add --no-cache libmaxminddb \
	&& apk add --no-cache redis \
	&& apk add --no-cache perl \
	&& apk add --no-cache git \
	&& rm -rf /var/cache/apk/*.apk && rm -rf /tmp/* && echo "$(date -u) ${ALPINE_X_MARKING} !!!DONE!!!" >> /_dockerDebug.log
