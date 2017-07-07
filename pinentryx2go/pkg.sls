# pinentryx2go.pkg
#
# Manages installation of pinentryx2go from pkg.

{% from 'x2go/pinentryx2go/map.jinja' import pinentryx2go, sls_block with context %}

pinentryx2go_install:
  pkg.installed:
    {{ sls_block(pinentryx2go.package.opts) }}
    - names:
      - {{ pinentryx2go.package.packagename }}

{% if salt['grains.get']('os_family') == 'Debian' %}
  {%- if pinentryx2go.install_from_repo %}
pinentryx2go-official-repo:
  pkgrepo:
    - managed
    - humanname: {{ pinentryx2go.projectname }}-{{ grains['oscodename'] }}
    - name: deb {{ pinentryx2go.package.ppa_stable }} {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/{{ pinentryx2go.projectname }}-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: {{ pinentryx2go.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    - require_in:
      - pkg: pinentryx2go_install
    - watch_in:
      - pkg: pinentryx2go_install
  {%- else %}
pinentryx2go_ppa_repo:
  pkgrepo:
    {%- if pinentryx2go.install_from_ppa %}
    - managed
    {%- else %}
    - absent
    {%- endif %}
    {% if salt['grains.get']('os') == 'Ubuntu' %}
    - ppa: x2go/{{ pinentryx2go.package.ppa_version }}
    {% else %}
    - name: deb {{ pinentryx2go.package.ppa_unstable }} {{ grains['oscodename'] }} main
    - keyid: {{ pinentryx2go.package.ppa_keyid }}
    - keyclient: keyclient.ubuntu.com
    {% endif %}
    - require_in:
      - pkg: pinentryx2go_install
    - watch_in:
      - pkg: pinentryx2go_install
  {%- endif %}
{% endif %}

