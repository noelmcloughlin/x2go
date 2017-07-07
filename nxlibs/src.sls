# nxlibs.src
#
# Manages installation of nxlibs.from source.

{% from 'x2go/nxlibs/map.jinja' import nxlibs, sls_block with context %}

nxlibs_deps:
  {% if salt['grains.get']('os_family') == 'Debian'%}
  cmd.run:
    - name: apt-get -y install {{ nxlibs.lookup.build_deps }} {{ nxlibs.lookup.runtime_deps }} git
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum install -y  {{ nxlibs.lookup.build_deps }} {{ nxlibs.lookup.runtime_deps }} git
  {% else %}
  {% endif %}

nxlibs_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ nxlibs.source.source_url }}
    - source_hash: {{ nxlibs.source.source_urlhash }}
    - if_missing: {{ nxlibs.source.bin_dir }}/{{ nxlibs.client.binary }}
    - require:
      - cmd: nxlibs_deps
    - onchanges:
      - cmd: nxlibs_deps

nxlibs_make:
  cmd.run:
    - name: {{ nxlibs.source.configure_make or 'make' }}
    - cwd: /tmp/{{ nxlibs.package.packagename }}-{{ nxlibs.source.version }}
    - require:
      - archive: nxlibs_download
    - onchanges:
      - archive: nxlibs_download

nxlibs_install:
  cmd.run:
    - name: {{ nxlibs.source.make_install or 'make install' }}
    - cwd: /tmp/{{ nxlibs.package.packagename }}-{{ nxlibs.source.version }}
    - require:
      - cmd: nxlibs_make
    - onchanges:
      - cmd: nxlibs_make

nxlibs_download_cleanup:
  file.absent:
    - names:
      - /tmp/{{ nxlibs.package.packagename }}-{{ nxlibs.source.version }}
      - /tmp/{{ nxlibs.source.source_urlhash }}
    - require:
      - cmd: nxlibs_install
    - onchanges:
      - cmd: nxlibs_install

