# nxlibs.pkg
#
# Manages installation of nxlibs from pkg.

{% from 'x2go/nxlibs/map.jinja' import nxlibs, sls_block with context %}

nxlibs_install:
  pkg.installed:
    {{ sls_block(nxlibs.package.opts) }}
    - names:
      - {{ nxlibs.package.packagename }}

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if nxlibs.install_from_repo %}
nxlibs-official-repo:
  pkgrepo:
    - managed
    - humanname: {{ nxlibs.projectname }}-{{ grains['oscodename'] }}
    - name: deb {{ nxlibs.package.ppa_stable }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ nxlibs.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ nxlibs.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    - require_in:
      - pkg: nxlibs_install
    - watch_in:
      - pkg: nxlibs_install
  {%- else %}
nxlibs_ppa_repo:
  pkgrepo:
    {%- if nxlibs.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ nxlibs.package.ppa_version }}
    {% else %}
    - name: deb {{ nxlibs.package.ppa_unstable }} {{ grains['oscodename'] }} main
    - keyid: {{ nxlibs.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: nxlibs_install
    - watch_in:
      - pkg: nxlibs_install
  {%- endif %}
{% endif %}

