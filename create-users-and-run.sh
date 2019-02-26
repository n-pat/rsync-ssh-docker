#!/bin/sh
set -eu

GROUPID="${GROUPID:-1000}"
USERID="${USERID:-1000}"
USER="${$USERNAME:-$GITHUB_USER}"
addgroup -g "$GROUPID" sshuser

adduser -G sshuser --uid "$USERID" -s /bin/sh -D "$USERNAME"
echo "$USERNAME":$(head -c30 /dev/urandom | base64) | chpasswd
mkdir /home/"$USERNAME"/.ssh
if [ ! -z "${GITHUB_USER:-}" ]; then
    wget -q -O /home/"$USERNAME"/.ssh/authorized_keys https://github.com/"$GITHUB_USER".keys
fi
echo "${SSH_KEY:-}" >> /home/"$USERNAME"/.ssh/authorized_keys
chown -R "$USERNAME":rsync /home/"$USERNAME"/.ssh
chmod -R go-wx /home/"$USERNAME"/.ssh

exec /usr/sbin/sshd -eD
