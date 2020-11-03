# Docker installation on target OS
# FIXME: Currently only Debian10 tested/supported

{% if grains['os_family']|lower == 'debian' %}
include:
  - pil-docker.debian
{% else %}
failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}

