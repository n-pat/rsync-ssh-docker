#!/bin/sh
set -eu

GROUPID="${GROUPID:-1000}"
USERID="${USERID:-1000}"
USER="${USERNAME:-$GITHUB_USER}"
GROUP="sshuser"
addgroup -g "$GROUPID" "$GROUP"

adduser -G sshuser --uid "$USERID" -s /bin/sh -D "$USER"
echo "$USER":"$(head -c30 /dev/urandom | base64)" | chpasswd
mkdir /home/"$USER"/.ssh
if [ ! -z "${GITHUB_USER:-}" ]; then
    wget -q -O /home/"$USER"/.ssh/authorized_keys https://github.com/"$GITHUB_USER".keys
fi
echo "${SSH_KEY:-}" >> /home/"$USER"/.ssh/authorized_keys
chown -R "$USER":"$GROUP" /home/"$USER"/.ssh
chmod -R go-wx /home/"$USER"/.ssh

exec /usr/sbin/sshd -eD
