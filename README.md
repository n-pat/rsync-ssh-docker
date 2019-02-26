# Rsync SSH Docker

Docker image to allow SSH and rsync access to volumes.
Authentication is configured using github public keys- the container creates users and downloads their github keys at runtime.

## Environment variables

- `GROUPID`: The numeric ID of the group all users will be added to, default `1000`
- `GITHUB_USERS`: **List** of GitHub user from which the ssh public keys are taken and for which the usernames are created if no `USERNAME` is given.
- `USERNAME`: Username to be used for either the ssh keys taken from the GitHub users list or `SSH_KEYS` variable
- `SSH_KEY`: ssh key used for authentication if you specify `USERNAME`

## Required variables

- If `USERNAME` is given, additionally `SSH_KEY` and/or `GITHUB_USERS` have to be specified as well to use the keys from GitHub and/or the one from the `SSH_KEY` variable
- If no `USERNAME` is given, `GITHUB_USERS` has be specified so that the username and ssh keys are taken from there.
- If you want to specify more than one username this is only possible by using the `GITHUB_USERS` variable.
- Specifying only `SSH_KEY` and no other variable is not possible.
- `GROUPID` is fully optional.

## Example

### Container creation
With the following a container is created where the users `microscopepony` `snoopycrimecop` are created and their respective ssh public keys from GitHub are added.
    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e GITHUB_USERS="microscopepony snoopycrimecop" -p 10022:22 rsync-ssh

With the following a container is created where the user `myuser` is created and this user can login using the keys from the GitHub users `microscopepony`, `snoopycrimecop` or the one in the `SSH_KEY` variable.
    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e GITHUB_USERS="microscopepony snoopycrimecop" -e USERNAME="myuser" -e SSH_KEYS="ssh-ed25519 AAAAC3....a4" -p 10022:22 rsync-ssh

With the following a container is created where the user `myuser` is created and this user can login using the key in the `SSH_KEY` variable.
    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e USERNAME="myuser" -e SSH_KEYS="ssh-ed25519 AAAAC3....a4" -p 10022:22 rsync-ssh

### Usage
    rsync -v -e 'ssh -p 10022' microscopepony@localhost:/volume
    ssh -p 10022 microscopepony@localhost
