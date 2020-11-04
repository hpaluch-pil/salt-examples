# Docker installation on target OS
# Tested on Debian10 and CentOS 7

{% if grains['os_family']|lower in ['debian','redhat','suse'] %}
include:
  - pil-docker.{{ grains['os_family']|lower }}

# parts common to all distributions
# add selected users from Pillar 'pil-docker-users' to group 'docker'
{% if pillar.get('pil-docker-users',[]) %}
pil-add-docker-users:
  group.present:
    - addusers: {{ pillar['pil-docker-users'] }}
    - require:
      - pkg: pil-docker-pkgs
{% endif %}

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

