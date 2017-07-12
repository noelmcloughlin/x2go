# x2goserver.pkg
#
# Manages installation of x2goserver from pkg.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}
{%- if nginx.install_from_repo %}
  {% set from_official = true %}
  {% set from_ppa = false %}
{% elif nginx.install_from_ppa %}
  {% set from_official = false %}
  {% set from_ppa = true %}
{% else %}
  {% set from_official = false %}
  {% set from_ppa = false %}
{%- endif %}

x2goserver_install:
  pkg.installed:
    {{ sls_block(x2goserver.package.opts) }}
    - names:
      - software-properties-common
      - x2goserver
      - x2goserver-xsession
      - fuse
      - fuse-libs
      - cups
      - cups-x2go
      - x2goserver-printing
      - x2godesktopsharing
      - fuse-sshfs

{% if salt['grains.get']('os_family') == 'Debian' %}
x2goserver-official-repo:
  pkgrepo:
    {%- if from_official %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Debian' %}
    - humanname: {{ x2goserver.projectname }} apt repo
    - name: deb {{ x2goserver.deb }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ x2goserver.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ x2goserver.deb_keyid }}
    - keyserver: {{ x2goserver.deb_keyserver }}
  {%- endif %}
    - require_in:
      - pkg: x2goserver_install
    - watch_in:
      - pkg: x2goserver_install

x2goserver_ppa_repo:
  pkgrepo:
    {%- if x2goserver.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ x2goserver.ppa_version }}
    {% else %}
    - ppa: {{ x2goserver.ppa }} 
    - keyid: {{ x2goserver.ppa_keyid }}
    - keyserver: {{ x2goserver.ppa_keyserver }}
    {% endif %}
    - require_in:
      - pkg: x2goserver_install
    - watch_in:
      - pkg: x2goserver_install
{% endif %}
{% if salt['grains.get']('os_family') == 'xxxx' %}
