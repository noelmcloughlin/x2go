# nxlibs.config
#
# Manages the main nxlibs client configuration file.

{% from 'x2go/nxlibs/map.jinja' import nxlibs, sls_block with context %}

nxlibs_config:
  file.managed:
    {{ sls_block(nxlibs.client.opts) }}
    - name: {{ nxlibs.client.conf_dir }}/{{ nxlibs.client.conf_file }}.salt-formula-todo
    - source: salt://x2go/nxlibs/files/nxlibs.conf
    - template: jinja
    - context:
        config: {{ nxlibs.client.config|json() }}
