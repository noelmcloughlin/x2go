# x2goclient.config
#
# Manages the main x2goclient client configuration file.

{% from 'x2go/x2goclient/map.jinja' import x2goclient, sls_block with context %}

x2goclient_config:
  file.managed:
    {{ sls_block(x2goclient.client.opts) }}
    - name: {{ x2goclient.client.conf_dir }}/{{ x2goclient.client.conf_file }}.salt-formula-todo
    - source: salt://x2go/x2goclient/files/x2goclient.conf
    - template: jinja
    - context:
        config: {{ x2goclient.client.config|json() }}
