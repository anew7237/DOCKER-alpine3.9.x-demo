### https://github.com/anew7237/DOCKER-alpine3.9.x-demo/alpine3.9.x-anew

FROM anew7237/alpine3.9.x-auto:latest
ARG ALPINE_IMAGE_TAG="3.9.x"
ARG ALPINE_X_SUBNAME="anewresty"
ARG ALPINE_X_VERSION="20190712a"
ARG ALPINE_X_MARKING="201907120000"


ARG RESTY_ADD_PACKAGE_BUILDDEPS=""
ARG RESTY_ADD_PACKAGE_RUNDEPS=""

LABEL description="Alpine ${ALPINE_IMAGE_TAG} + Supervisor" \
	maintainer="Andrew Hsieh<anew7237@gmail.com>" \
	ALPINE_X_${ALPINE_X_SUBNAME}_version="${ALPINE_X_VERSION} - ${ALPINE_X_MARKING}" \
	ALPINE_X_${ALPINE_X_SUBNAME}_git="apk add git"

RUN echo "##### ##### ##### #####" >> /_dockerDebug.log \
	&& mkdir -p /x_script && chmod 700 /x_script \
	&& mkdir -p /x_resty && chmod 700 /x_resty \
	&& echo "$(date -u) ${ALPINE_X_MARKING} Alpine${ALPINE_IMAGE_TAG}-${ALPINE_X_SUBNAME}:${ALPINE_X_VERSION}" >> /_dockerDebug.log

RUN apk update \
	&& apk add --no-cache git \
	&& rm -rf /var/cache/apk/*.apk && rm -rf /tmp/* && echo "$(date -u) ${ALPINE_X_MARKING} !!!DONE!!!" >> /_dockerDebug.log
