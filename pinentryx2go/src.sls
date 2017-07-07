# pinentryx2go.src
#
# Manages installation of pinentryx2go.from source.

{% from 'x2go/pinentryx2go/map.jinja' import pinentryx2go, sls_block with context %}

pinentryx2go_deps:
  {% if salt['grains.get']('os_family') == 'Debian'%}
  cmd.run:
    - name: apt-get -y install {{ pinentryx2go.lookup.build_deps }} {{ pinentryx2go.lookup.runtime_deps }} git
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum install -y  {{ pinentryx2go.lookup.build_deps }} {{ pinentryx2go.lookup.runtime_deps }} git
  {% else %}
  {% endif %}

pinentryx2go_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ pinentryx2go.source.source_url }}
    - source_hash: {{ pinentryx2go.source.source_urlhash }}
    - if_missing: {{ pinentryx2go.source.bin_dir }}/{{ pinentryx2go.client.binary }}
    - require:
      - cmd: pinentryx2go_deps
    - onchanges:
      - cmd: pinentryx2go_deps

pinentryx2go_make:
  cmd.run:
    - name: {{ pinentryx2go.source.configure_make or 'make' }}
    - cwd: /tmp/{{ pinentryx2go.package.packagename }}-{{ pinentryx2go.source.version }}
    - require:
      - archive: pinentryx2go_download
    - onchanges:
      - archive: pinentryx2go_download

pinentryx2go_install:
  cmd.run:
    - name: {{ pinentryx2go.source.make_install or 'make install' }}
    - cwd: /tmp/{{ pinentryx2go.package.packagename }}-{{ pinentryx2go.source.version }}
    - require:
      - cmd: pinentryx2go_make
    - onchanges:
      - cmd: pinentryx2go_make

pinentryx2go_download_cleanup:
  file.absent:
    - names:
      - /tmp/{{ pinentryx2go.package.packagename }}-{{ pinentryx2go.source.version }}
      - /tmp/{{ pinentryx2go.source.source_urlhash }}
    - require:
      - cmd: pinentryx2go_install
    - onchanges:
      - cmd: pinentryx2go_install

