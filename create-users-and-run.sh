#!/bin/sh
set -eu

GROUPID="${GROUPID:-1000}"
addgroup -g "$GROUPID" rsync

if [ -n "$USERNAME" ]; then
    adduser -G rsync -s /bin/sh -D "$USERNAME"
    echo "$USERNAME":$(head -c30 /dev/urandom | base64) | chpasswd
    mkdir /home/"$USERNAME"/.ssh
    for GITHUB_USER in $GITHUB_USERS; do
        wget -q -O /home/"$USERNAME"/.ssh/authorized_keys https://github.com/"$GITHUB_USER".keys
    done
    echo "${SSH_KEY:-}" >> /home/"$USERNAME"/.ssh/authorized_keys
    chown -R "$USERNAME":rsync /home/"$USERNAME"/.ssh
    chmod -R go-wx /home/"$USERNAME"/.ssh
else
    if [ ! -z "${GITHUB_USERS:-}" ]; then
        for GITHUB_USER in $GITHUB_USERS; do
            USERNAME="$GITHUB_USER"
            adduser -G rsync -s /bin/sh -D "$USERNAME"
            echo "$USERNAME":$(head -c30 /dev/urandom | base64) | chpasswd
            mkdir /home/"$USERNAME"/.ssh
            wget -q -O /home/"$USERNAME"/.ssh/authorized_keys https://github.com/"$GITHUB_USER".keys
            chown -R "$USERNAME":rsync /home/"$USERNAME"/.ssh
            chmod -R go-wx /home/"$USERNAME"/.ssh
        done
    fi
fi

exec /usr/sbin/sshd -eD
