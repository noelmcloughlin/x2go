# x2goserver.src
#
# Manages installation of x2goserver.from source.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}

x2goserver_deps:
  {% if salt['grains.get']('os_family') == 'Debian'%}
  cmd.run:
    - name: apt-get -y install {{ x2goserver.lookup.build_deps }} {{ x2goserver.lookup.runtime_deps }} autoconf
  {% elif salt['grains.get']('os_family') == 'RedHat' %}
  cmd.run:
    - name: yum install -y  {{ x2goserver.lookup.build_deps }} {{ x2goserver.lookup.runtime_deps }} autoconf
  {% else %}
  {% endif %}

x2goserver_group:
  group.present:
    - name: {{ x2goserver.service.user }}

x2goserver_user:
  file.directory:
    - name: {{ x2goserver.service.home }}
    - user: {{ x2goserver.service.user }}
    - group: {{ x2goserver.service.user }}
    - mode: 0755
    - require:
      - user: x2goserver_user
      - group: x2goserver_group
  user.present:
    - name: {{ x2goserver.service.user }}
    - home: {{ x2goserver.service.home }}
    - createhome: False
    - system: True
    - shell: /bin/false 
    - groups:
      - {{ x2goserver.service.user }}
    - require:
      - group: x2goserver_group

x2goserver_printgroup:
  group.present:
    - name: {{ x2goserver.service.printuser }}

x2goserver_printuser:
  file.directory:
    - name: {{ x2goserver.service.home }}
    - user: {{ x2goserver.service.printuser }}
    - group: {{ x2goserver.service.printuser }}
    - mode: 0755
    - require:
      - user: x2goserver_printuser
      - group: x2goserver_printgroup
  user.present:
    - name: {{ x2goserver.service.printuser }}
    - home: {{ x2goserver.service.home }}
    - createhome: False
    - system: True
    - shell: /bin/false 
    - groups:
      - {{ x2goserver.service.printuser }}
    - require:
      - group: x2goserver_printgroup

x2goserver_download:
  archive.extracted:
    - name: /tmp/
    - source: {{ x2goserver.source.source_url }}
    - source_hash: {{ x2goserver.source.source_urlhash }}
    - if_missing: {{ x2goserver.source.sbin_dir }}/{{ x2goserver.service.binary }}
    - require:
      - cmd: x2goserver_deps
    - onchanges:
      - cmd: x2goserver_deps

x2goserver_make:
  cmd.run:
    - name: {{ x2goserver.source.configure_make or 'make' }}
    - cwd: /tmp/{{ x2goserver.package.packagename }}-{{ x2goserver.source.version }}
    - require:
      - archive: x2goserver_download
    - onchanges:
      - archive: x2goserver_download

x2goserver_install:
  cmd.run:
    - name: {{ x2goserver.source.make_install or 'make install' }}
    - cwd: /tmp/{{ x2goserver.package.packagename }}-{{ x2goserver.source.version }}
    - require:
      - cmd: x2goserver_make
    - onchanges:
      - cmd: x2goserver_make

x2goserver_download_cleanup:
  file.absent:
    - names:
      - /tmp/{{ x2goserver.package.packagename }}-{{ x2goserver.source.version }}
      - /tmp/{{ x2goserver.source.source_urlhash }}
    - require:
      - cmd: x2goserver_install
    - onchanges:
      - cmd: x2goserver_install

