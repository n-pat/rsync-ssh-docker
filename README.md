# Rsync SSH Docker

Docker image to allow SSH and rsync access to volumes.
Authentication is configured using github public keys- the container creates users and downloads their github keys at runtime.

## Environment variables

- `GROUPID`: The numeric ID of the group all users will be added to, default `1000`.
- `USERID`: The numeric ID of the user which will be created, default `1000`.
- `USERNAME`: Username to be used.
- `GITHUB_USER`:  GitHub user from which the ssh public keys are taken and for which the username is created if no `USERNAME` is given.
- `SSH_KEY`: ssh key used for authentication if no `GITHUB_USER` is given or additionally to the GitHub user keys.

### Required variables

- If `USERNAME` is given, additionally `SSH_KEY` and/or `GITHUB_USER` have to be specified as well to use the keys from GitHub and/or the one from the `SSH_KEY` variable
- If no `USERNAME` is given, `GITHUB_USER` has be specified so that the username and ssh keys are taken from there.
- Specifying only `SSH_KEY` and no other variable is not possible. `SSH_KEY` can be used together with `USERNAME` or `GITHUB_USER` or both.
- `GROUPID` is fully optional.
- `USERID` is fully optional.

## Example

### Container creation
With the following a container is created where the user `freiheitsnetz` is created and its respective ssh public keys from GitHub are added.

    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e GITHUB_USERS="freiheitsnetz" -p 10022:22 rsync-ssh

With the following a container is created where the user `myuser` is created and this user can login using the keys from the GitHub user `freiheitsnetz` or the one in the `SSH_KEY` variable.

    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e GITHUB_USERS="freiheitsnetz" -e USERNAME="myuser" -e SSH_KEYS="ssh-ed25519 AAAAC3....a4" -p 10022:22 rsync-ssh

With the following a container is created where the user `myuser` is created and this user can login using the key in the `SSH_KEY` variable.

    docker run -d --name rsync-ssh-access -v shared-volume:/volume -e USERNAME="myuser" -e SSH_KEYS="ssh-ed25519 AAAAC3....a4" -p 10022:22 rsync-ssh

### Usage

    rsync -v -e 'ssh -p 10022' freiheitsnetz@localhost:/volume
    ssh -p 10022 freiheitsnetz@localhost
