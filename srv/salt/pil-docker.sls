# Docker installation on target OS
# Tested on Debian10 and CentOS 7

{% if grains['os_family']|lower in ['debian','redhat','suse'] %}
include:
  - pil-docker.{{ grains['os_family']|lower }}

# parts common to all distributions
# typically RedHat and Ubuntu have everything disabled by default???
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

{% else %}
failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}

