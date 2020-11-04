# Docker installation on target OS
# Tested on Debian10 and CentOS 7

{% if grains['os_family']|lower == 'debian' %}
include:
  - pil-docker.debian
{% elif grains['os_family']|lower == 'redhat' %}
include:
  - pil-docker.redhat
{% else %}
failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}

# parts common to all distributions
# typically RedHat and Ubuntu has everything disabled by default???
{% if grains['os_family']|lower in ['debian','redhat'] %}
pil-docker-enabled:
  service.enabled:
    - name: docker
    - require:
      - pkg: pil-docker-pkgs

pil-docker-running:
  service.running:
    - name: docker
    - require:
      - service: pil-docker-enabled
{% endif %}

