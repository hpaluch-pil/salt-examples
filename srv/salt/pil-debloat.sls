# pil-debloat.sls - remove bloat from target Minion
#
# DANGEROUS! EXPERIMENTAL!
#
{% if grains['os_family']|lower == 'debian' %}

{#  list of packages to be removed on all Debian like distributions #}
{%  set drop_pkgs = [ 'unattended-upgrades','irqbalance' ] %}
{%  if grains['os']|lower == 'ubuntu' %}
{#   add Ubuntu specific packages for removal #}
{%   for upkg in ['snapd','command-not-found','javascript-common'] %}
{%    do drop_pkgs.append( upkg ) %}
{%   endfor %}
{%  endif %}

{% for pkg in drop_pkgs %}
pil-debloat-{{ pkg }}-pkg:
  pkg.purged:
    - name: "{{ pkg }}"

# Ooops - this does not work for uninstalled packages
# (unlike apt-mark hold - which does)
#pil-debloat-{{ pkg }}-hold:
#  apt.held:
#    - name: {{ pkg }}
#    - require:
#      - pkg: pil-debloat-{{ pkg }}-pkg

{%  endfor %}
{% else %}
pil-debloat-failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}
