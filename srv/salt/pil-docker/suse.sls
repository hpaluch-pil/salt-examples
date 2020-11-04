# Pickering Docker installer SLS for SUSE and flavours
# NOTE: We use stock Docker from SUSE - there is no official setup/repo
#       on docker site: https://docs.docker.com/engine/install/

pil-docker-pkgs:
  pkg.installed:
    - pkgs:
      - docker

