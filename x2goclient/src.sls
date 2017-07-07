# x2goclient.src
#
# Manages installation of x2goclient.from source.

{% from 'x2go/x2goclient/map.jinja' import x2goclient, sls_block with context %}

x2goclient_deps:
  {% if salt['grains.get']('os_family') == 'Debian'%}
  cmd.run:
    - name: apt-get -y install {{ x2goclient.lookup.build_deps }} {{ x2goclient.lookup.runtime_deps }} git
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum install -y  {{ x2goclient.lookup.build_deps }} {{ x2goclient.lookup.runtime_deps }} git
  {% else %}
  {% endif %}


x2goclient_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ x2goclient.source.source_url }}
    - source_hash: {{ x2goclient.source.source_urlhash }}
    - if_missing: {{ x2goclient.source.bin_dir }}/{{ x2goclient.client.binary }}
    - require:
      - cmd: x2goclient_deps
    - onchanges:
      - cmd: x2goclient_deps

x2goclient_make:
  cmd.run:
    - name: {{ x2goclient.source.configure_make or 'make' }}
    - cwd: /tmp/{{ x2goclient.package.packagename }}-{{ x2goclient.source.version }}
    - require:
      - archive: x2goclient_download
    - onchanges:
      - archive: x2goclient_download

x2goclient_install:
  cmd.run:
    - name: {{ x2goclient.source.make_install or 'make install' }}
    - cwd: /tmp/{{ x2goclient.package.packagename }}-{{ x2goclient.source.version }}
    - require:
      - cmd: x2goclient_make
    - onchanges:
      - cmd: x2goclient_make

x2goclient_download_cleanup:
  file.absent:
    - names:
      - /tmp/{{ x2goclient.package.packagename }}-{{ x2goclient.source.version }}
      - /tmp/{{ x2goclient.source.source_urlhash }}
    - require:
      - cmd: x2goclient_install
    - onchanges:
      - cmd: x2goclient_install

