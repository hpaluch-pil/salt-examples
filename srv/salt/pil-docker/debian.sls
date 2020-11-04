# Pickering Docker installer SLS for Debian/Ubuntu
# see setup on:
# - https://docs.docker.com/engine/install/debian/
# - https://docs.docker.com/engine/install/ubuntu/
pil-docker-pre-pkgs:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg-agent
      - software-properties-common

pil-docker-org-repo:
  # use this to get help on 'pkgrepo.managed':
  # sudo salt '*' --subset=1 sys.state_doc pkgrepo.managed
  pkgrepo.managed:
    - name: "deb https://download.docker.com/linux/{{ grains['os']|lower }} {{ grains['oscodename'] }} stable"
    - file: /etc/apt/sources.list.d/docker-org.list
    - keyid: 0EBFCD88
    - keyserver: hkp://keyserver.ubuntu.com:80
    - refresh: true
    # pkg require does not work. This is _reverse_ dependency...
    - require_in: pil-docker-pkgs
    - require:
      - pkg: pil-docker-pre-pkgs

pil-docker-pkgs:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io 

