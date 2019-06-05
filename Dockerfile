FROM alpine:latest

RUN apk add -U \
    openssh-server \
    rsync && \
    rm -f /var/cache/apk/*

VOLUME ["/etc/ssh/"]
ADD sshd_config /etc/ssh/
ADD create-users-and-run.sh /usr/local/bin/

EXPOSE 22
ENTRYPOINT ["create-users-and-run.sh"]
#STOPSIGNAL INT
