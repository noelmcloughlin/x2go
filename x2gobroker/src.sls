# x2gobroker.src
#
# Manages installation of x2gobroker.from source.

{% from 'x2go/x2gobroker/map.jinja' import x2gobroker, sls_block with context %}

x2gobroker_deps:
  {% if salt['grains.get']('os_family') == 'Debian'%}
  cmd.run:
    - name: apt-get -y install {{ x2gobroker.lookup.build_deps }} {{ x2gobroker.lookup.runtime_deps }} git
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum install -y  {{ x2gobroker.lookup.build_deps }} {{ x2gobroker.lookup.runtime_deps }} git
  {% else %}
  {% endif %}

x2gobroker_group:
  group.present:
    - name: {{ x2gobroker.service.user }}

x2gobroker_user:
  file.directory:
    - name: {{ x2gobroker.service.home }}
    - user: {{ x2gobroker.service.user }}
    - group: {{ x2gobroker.service.user }}
    - mode: 0755
    - require:
      - user: x2gobroker_user
      - group: x2gobroker_group
  user.present:
    - name: {{ x2gobroker.service.user }}
    - home: {{ x2gobroker.service.home }}
    - createhome: False
    - system: True
    - shell: /bin/false 
    - groups:
      - {{ x2gobroker.service.user }}
    - require:
      - group: x2gobroker_group

x2gobroker_printgroup:
  group.present:
    - name: {{ x2gobroker.service.printuser }}

x2gobroker_printuser:
  file.directory:
    - name: {{ x2gobroker.service.home }}
    - user: {{ x2gobroker.service.printuser }}
    - group: {{ x2gobroker.service.printuser }}
    - mode: 0755
    - require:
      - user: x2gobroker_printuser
      - group: x2gobroker_printgroup
  user.present:
    - name: {{ x2gobroker.service.printuser }}
    - home: {{ x2gobroker.service.home }}
    - createhome: False
    - system: True
    - shell: /bin/false 
    - groups:
      - {{ x2gobroker.service.printuser }}
    - require:
      - group: x2gobroker_printgroup

x2gobroker_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ x2gobroker.source.source_url }}
    - source_hash: {{ x2gobroker.source.source_urlhash }}
    - if_missing: {{ x2gobroker.source.sbin_dir }}/{{ x2gobroker.service.binary }}
    - require:
      - cmd: x2gobroker_deps
    - onchanges:
      - cmd: x2gobroker_deps

x2gobroker_make:
  cmd.run:
    - name: {{ x2gobroker.source.configure_make or 'make' }}
    - cwd: /tmp/{{ x2gobroker.package.packagename }}-{{ x2gobroker.source.version }}
    - require:
      - archive: x2gobroker_download
    - onchanges:
      - archive: x2gobroker_download

x2gobroker_install:
  cmd.run:
    - name: {{ x2gobroker.source.make_install or 'make install' }}
    - cwd: /tmp/{{ x2gobroker.package.packagename }}-{{ x2gobroker.source.version }}
    - require:
      - cmd: x2gobroker_make
    - onchanges:
      - cmd: x2gobroker_make

x2gobroker_download_cleanup:
  file.absent:
    - names:
      - /tmp/{{ x2gobroker.package.packagename }}-{{ x2gobroker.source.version }}
      - /tmp/{{ x2gobroker.source.source_urlhash }}
    - require:
      - cmd: x2gobroker_install
    - onchanges:
      - cmd: x2gobroker_install

