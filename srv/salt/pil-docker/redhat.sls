# Pickering Docker installer SLS for RedHat and flavours
# see setup on:
# - https://docs.docker.com/engine/install/centos/

#pil-docker-pre-pkgs:
#  pkg.installed:
#    - pkgs:
#      - yum-utils

pil-docker-org-repo:
  # use this to get help on 'pkgrepo.managed':
  # sudo salt '*' --subset=1 sys.state_doc pkgrepo.managed
  pkgrepo.managed:
    - name: docker-ce-stable
    - humanname: Docker CE Stable - $basearch 
    - baseurl: https://download.docker.com/linux/centos/$releasever/$basearch/stable
    - comments:
      - 'see: https://docs.docker.com/engine/install/centos/ '
    - gpgcheck: 1
    - gpgkey: https://download.docker.com/linux/centos/gpg
    - refresh: true
    # pkg require does not work. This is _reverse_ dependency...
    - require_in: pil-docker-pkgs
    #- require:
    #  - pkg: pil-docker-pre-pkgs

pil-docker-pkgs:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io 

