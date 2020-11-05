# pil-debloat.sls - remove bloat from target Minion
#
# DANGEROUS! EXPERIMENTAL!
#
{% if grains['os_family']|lower in ['debian','suse','redhat'] %}
{#  bloat common to all distribution #}
{%  set drop_pkgs = [ 'irqbalance', 'tuned' ] %}

{%  if grains['os_family']|lower == 'debian' %}
{#   list of packages to be removed on all Debian like distributions #}
{%   set drop_pkgs = drop_pkgs + [ 'unattended-upgrades','multipath-tools',
          'upower','fwupd','fwupd-signed','bcache-tools','usbmuxd',
          'mtr-tiny','open-iscsi' ] %}
{%   if grains['os']|lower == 'ubuntu' %}
{#    add Ubuntu specific packages for removal #}
{%    set drop_pkgs = drop_pkgs + ['snapd','command-not-found','javascript-common',
            'motd-news-config','alsa-topology-conf','alsa-ucm-conf',
            'apport','apport-symptoms' ]  %}
{%   endif %}
{%  elif grains['os_family']|lower == 'suse' %}
{%   set drop_pkgs = drop_pkgs + [ 'yp-tools','parallel-printer-support' ] %}
{%  elif grains['os_family']|lower == 'redhat' %}
{%   set drop_pkgs = drop_pkgs + [ 'teamd' ] %}
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

{# comment out /run/motd.dynamic crap #}
{% if grains['os_family']|lower == 'debian' %}
{%  for pam_file in ['login','sshd'] %}
pil-debloat-disable-{{ pam_file }}-motd:
  file.comment:
    - name: "/etc/pam.d/{{ pam_file }}"
    - regex: "^(session.*motd=/run/motd.dynamic.*)"
{%  endfor %}
{% endif %}

{% else %}
pil-debloat-failure:
  test.fail_without_changes:
  - name: "OS family {{ grains['os_family'] }} is not supported!"
  - failhard: True
{% endif %}
