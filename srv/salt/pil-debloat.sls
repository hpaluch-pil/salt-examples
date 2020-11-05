# pil-debloat.sls - remove bloat from target Minion
#
# DANGEROUS! EXPERIMENTAL!
#
{% if grains['os_family']|lower in ['debian','suse','redhat'] %}

{%  if grains['os_family']|lower == 'debian' %}
{#   list of packages to be removed on all Debian like distributions #}
{%   set drop_pkgs = [ 'unattended-upgrades','irqbalance' ] %}
{%   if grains['os']|lower == 'ubuntu' %}
{#    add Ubuntu specific packages for removal #}
{%    for upkg in ['snapd','command-not-found','javascript-common','motd-news-config'] %}
{%     do drop_pkgs.append( upkg ) %}
{%    endfor %}
{%   endif %}
{%  elif grains['os_family']|lower == 'suse' %}
{%   set drop_pkgs = [ 'yp-tools','irqbalance','parallel-printer-support' ] %}
{%  elif grains['os_family']|lower == 'redhat' %}
{%   set drop_pkgs = [ 'tuned','irqbalance' ] %}
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

{# mask listed systemd units #}
{% set masked_units = [] %}
{% if grains['os_family']|lower == 'debian' %}
{%  set masked_units = masked_units + ['apt-daily.timer','apt-daily-upgrade.timer'] %}
{% endif %}
{% if grains['os']|lower == 'ubuntu' %}
{%  set masked_units = masked_units + ['update-notifier-download.timer',
          'fwupd-refresh.timer','motd-news.timer','update-notifier-motd.timer'] %}
{% endif %}

{% for unit in masked_units %}
pil-debloat-{{ unit }}-masked:
  service.masked:
    - name: {{ unit }}
{% endfor %}

{% else %}
pil-debloat-failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}
