### https://github.com/anew7237/DOCKER-alpine3.9.x-demo/alpine3.9.x-sshd

FROM alpine:3.9.4
ARG ALPINE_IMAGE_TAG="3.9.4"
ARG ALPINE_X_SUBNAME="sshd"
ARG ALPINE_X_VERSION="20190718a"
ARG ALPINE_X_MARKING="2019071800"

LABEL description="Alpine ${ALPINE_IMAGE_TAG} + Openssh Server" \
	maintainer="Andrew Hsieh<anew7237@gmail.com>" \
	ALPINE_X_${ALPINE_X_SUBNAME}_version="${ALPINE_X_VERSION} - ${ALPINE_X_MARKING}" \
	ALPINE_X_${ALPINE_X_SUBNAME}_tzdata="apk add & set to Shanghai" \
	ALPINE_X_${ALPINE_X_SUBNAME}_openssh="apk add openssh openssh-server openssh-sftp-server & ssh-keygen rsa ecdsa ed25519 & set sshd_config & set ssh_config" \
	ALPINE_X_${ALPINE_X_SUBNAME}_openssl="apk add openssl && create root passwd by md5" \
	ALPINE_X_${ALPINE_X_SUBNAME}_root="chpasswd -e (md5) & set ~/.ssh/authorized_keys & passwd -l root"

RUN echo "##### ##### ##### #####" >> /_dockerDebug.log \
#	&& mv /etc/apk/repositories /etc/apk/repositories.bak \
#	&& echo "https://mirrors.aliyun.com/alpine/v3.9/main" >> /etc/apk/repositories \
#	&& echo "https://mirrors.aliyun.com/alpine/v3.9/community" >> /etc/apk/repositories \
	&& echo "$(date -u) ${ALPINE_X_MARKING} Alpine${ALPINE_IMAGE_TAG}-${ALPINE_X_SUBNAME}:${ALPINE_X_VERSION}" >> /_dockerDebug.log

COPY _COPY_/root/id_ed25519.pub /root/id_ed25519.pub

RUN apk update \
	&& apk add --no-cache --update busybox-suid \
	&& chmod 4755 /bin/busybox \
	&& apk add --no-cache tzdata \
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& apk add --no-cache openssh openssh-server openssh-sftp-server \
	&& for t in rsa ecdsa ed25519 ; do ssh-keygen -t $t -C root -P '' -f /etc/ssh/ssh_host_${t}_key ; done \
	&& sed -i "s/#PermitRootLogin .*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
	&& sed -i "s/#PubkeyAuthentication .*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config \
	&& sed -i "s/#PasswordAuthentication .*/PasswordAuthentication yes/g" /etc/ssh/sshd_config \
	&& sed -i "s/#ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/g" /etc/ssh/sshd_config \
	&& echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \
	&& apk add --no-cache openssl \
	&& echo "root:$(openssl passwd -1 -salt $(date -u '+%m%d%H%M') 'asdf456qwer789')" > /tmp/root.pwd \
	&& cat /tmp/root.pwd | chpasswd -e && passwd -l root \
	&& mkdir -p /root/.ssh && chmod 700 /root/.ssh \
	&& touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys \
	&& cat /root/id_ed25519.pub >> /root/.ssh/authorized_keys && rm -f /root/id_ed25519.pub \
	&& rm -rf /var/cache/apk/*.apk && rm -rf /tmp/* && echo "$(date -u) ${ALPINE_X_MARKING} !!!DONE!!!" >> /_dockerDebug.log

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]