# pinentryx2go.config
#
# Manages the main pinentryx2go client configuration file.

{% from 'x2go/pinentryx2go/map.jinja' import pinentryx2go, sls_block with context %}

pinentryx2go_config:
  file.managed:
    {{ sls_block(pinentryx2go.client.opts) }}
    - name: {{ pinentryx2go.client.conf_dir }}/{{ pinentryx2go.client.conf_file }}.salt-formula-todo
    - source: salt://x2go/pinentryx2go/files/pinentryx2go.conf
    - template: jinja
    - context:
        config: {{ pinentryx2go.client.config|json() }}
