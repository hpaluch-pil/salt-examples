pil-vim:
  pkg.installed:
  {% if grains['os_family']|lower == 'debian' %}
  - name: vim-nox
  {% elif grains['os_family']|lower == 'redhat' %}
  - name: vim-enhanced
  {% else %}
  {# last resort, for example SUSE #}
  - name: vim
  {% endif %}

