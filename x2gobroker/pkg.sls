# x2gobroker.pkg
#
# Manages installation of x2gobroker from pkg.

{% from 'x2go/x2gobroker/map.jinja' import x2gobroker, sls_block with context %}

x2gobroker_install:
  pkg.installed:
    {{ sls_block(x2gobroker.package.opts) }}
    - names:
      - software-properties-common
      - {{ x2gobroker.package.packagename }}
      - x2gobroker-xsession
      - fuse
      - fuse-libs
      - cups
      - cups-x2go
      - x2gobroker-printing
      - x2godesktopsharing

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if x2gobroker.install_from_repo %}
x2gobroker-official-repo:
  pkgrepo:
    - managed
    - humanname: {{ x2gobroker.projectname }}-{{ grains['oscodename'] }}
    - name: deb {{ x2gobroker.package.ppa_stable }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ x2gobroker.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ x2gobroker.package.ppa_keyid }}
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: x2gobroker_install
    - watch_in:
      - pkg: x2gobroker_install
  {%- else %}
x2gobroker_ppa_repo:
  pkgrepo:
    {%- if x2gobroker.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ x2gobroker.package.ppa_version }}
    {% else %}
    - name: deb {{ x2gobroker.package.ppa_unstable }} {{ grains['oscodename'] }} main
    - keyid: {{ x2gobroker.package.ppa_keyid }}
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: x2gobroker_install
    - watch_in:
      - pkg: x2gobroker_install
  {%- endif %}
{% endif %}

