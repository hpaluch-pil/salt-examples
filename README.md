# Salt-stack examples

Here are Salt stack examples used in Pickering.

Currently there is:
- `srv/salt/pil-vim.sls` - State `pil-vim` that will install text-mode vim on
  any of:
  - Debian (tested version 10)
  - Ubuntu (tested version 20.10)
  - RHEL/CentOS (tested version 7)
  - openSUSE LEAP (tested version 15.2)
- `srv/salt/pil-debloat.sls` - state that will remove bloat from Ubuntu/Debian
  - WARNING! DANGEROUS AND EXPERIMENTAL!
  - use this `pil-debloat` state very carefully!
- `srv/salt/pil-docker.sls` - State `pil-docker` that will add Docker key/repo and install docker packages. Currently works on:
  - Debian 10 only
  - MAY work on Ubuntu 20.04 (focal), but NOT on 20.10 (groovy), because
    there is no Docker repository for 20.10 yet - as of 2020-11-04
  - RHEL/CentOS (tested version 7)
  - openSUSE LEAP (tested version 15.2) - however under SUSE we use
    just stock `docker` package from standard SUSE repo

NOTE: `docker-pil` SLS also supports Pillar variable `pil-docker-users` of
type `list` - list of users to be added to group `docker` (so they can
invoke any docker function without root access).

For example you can create Pillar file `/srv/pillar/custom-pil-docker.sls`
with contents like:

```yaml
# custom-pil-docker.sls
pil-docker-users:
  - user1
  - user2
```

And add this to your Top pillar file `/srv/pillar/top.sls`:

```yaml
# /srv/pillar/top.sls
base:
  '*':
    - custom-pil-docker
```

Above example will add `user1` and `user2` to `docker` group on
all Minions where `pil-docker` state was applied, for example
using command `sudo salt '*' state.apply pil-docker`.

## Setup

You need to have working salt-stack installed. See https://repo.saltstack.com/
for installation instructions. Also
https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html could be
helpful.

Then use standard command to checkout this repository - non-privileged
user/folder recommended:

```bash
mkdir ~/projects
cd ~/projects
git clone https://github.com/hpaluch-pil/salt-examples.git
cd salt-examples
```

Now create default Salt directory for SLS and copy our files there:
```bash
sudo mkdir -p /srv/salt/
sudo cp -v srv/salt/* /srv/salt
```

Now you are ready to proceed to next section:


## Running our SLS

To run `pil-vim` state on all Minions:

```bash
# dry-run
sudo salt '*' state.apply pil-vim test=True
# real run!
sudo salt '*' state.apply pil-vim
```

To run `pil-vim` SLS over SSH (without need for Minion agent) use this:
```bash
# copy Master SSH key to your USER@TARGET_IP via SSH
sudo ssh-copy-id -i /etc/salt/pki/master/ssh/salt-ssh.rsa.pub USER@TARGET_IP
# now you can run "pil-vim" sls on SSH target using
sudo salt-ssh -i --user=USER TARGET_IP state.apply pil-vim
```

To run our `pil-vim` SLS locally (no running Master and/or Minion needed) use this command:

```bash
sudo salt-call --local state.apply pil-vim
```

Similarly you can apply `pil-docker` state - just replace `pil-vim` with
`pil-docker`. But be warned that `pil-docker` was tested only using regular
Minions (using `sudo salt '*' state.apply pil-docker` command).


