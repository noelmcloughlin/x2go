# x2goclient.pkg
#
# Manages installation of x2goclient from pkg.

{% from 'x2go/x2goclient/map.jinja' import x2goclient, sls_block with context %}

x2goclient_install:
  pkg.installed:
    {{ sls_block(x2goclient.package.opts) }}
    - names:
      - {{ x2goclient.package.packagename }}

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if x2goclient.install_from_repo %}
x2goclient-official-repo:
  pkgrepo:
    - managed
    - humanname: {{ x2goclient.projectname }}-{{ grains['oscodename'] }}
    - name: deb {{ x2goclient.package.ppa_stable }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ x2goclient.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ x2goclient.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    - require_in:
      - pkg: x2goclient_install
    - watch_in:
      - pkg: x2goclient_install
  {%- else %}
x2goclient_ppa_repo:
  pkgrepo:
    {%- if x2goclient.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ x2goclient.package.ppa_version }}
    {% else %}
    - name: deb {{ x2goclient.package.ppa_unstable }} {{ grains['oscodename'] }} main
    - keyid: {{ x2goclient.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: x2goclient_install
    - watch_in:
      - pkg: x2goclient_install
  {%- endif %}
{% endif %}

