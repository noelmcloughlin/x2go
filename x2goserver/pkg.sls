# x2goserver.pkg
#
# Manages installation of x2goserver from pkg.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}

x2goserver_install:
  pkg.installed:
    {{ sls_block(x2goserver.package.opts) }}
    - names:
      - software-properties-common
      - {{ x2goserver.package.packagename }}
      - x2goserver-xsession
      - fuse
      - fuse-libs
      - cups
      - cups-x2go
      - x2goserver-printing
      - x2godesktopsharing

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if x2goserver.install_from_repo %}
x2goserver-official-repo:
  pkgrepo:
    - managed
    - humanname: {{ x2goserver.projectname }}-{{ grains['oscodename'] }}
    - name: deb {{ x2goserver.package.ppa_stable }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ x2goserver.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ x2goserver.package.ppa_keyid }}
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: x2goserver_install
    - watch_in:
      - pkg: x2goserver_install
  {%- else %}
x2goserver_ppa_repo:
  pkgrepo:
    {%- if x2goserver.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ x2goserver.package.ppa_version }}
    {% else %}
    - name: deb {{ x2goserver.package.ppa_unstable }} {{ grains['oscodename'] }} main
    - keyid: {{ x2goserver.package.ppa_keyid }}
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: x2goserver_install
    - watch_in:
      - pkg: x2goserver_install
  {%- endif %}
{% endif %}

