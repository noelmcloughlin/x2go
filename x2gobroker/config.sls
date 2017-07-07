# x2gobroker.config
#
# Manages the main x2gobroker server configuration file.

{% from 'x2go/x2gobroker/map.jinja' import x2gobroker, sls_block with context %}


{% if x2gobroker.build_from_source %}
### Check if this is actually needed - x2go may use syslog ....
x2gobroker_log_dir:
  file.directory:
    - name: /var/log/x2gobroker
    - user: {{ x2gobroker.service.user }}
    - group: {{ x2gobroker.service.user }}
{% endif %}

x2gobroker_config:
  file.managed:
    {{ sls_block(x2gobroker.server.opts) }}
    - name: {{ x2gobroker.service.conf_dir }}/{{ x2gobroker.service.conf_file }}.salt-formula-todo
    - source: salt://x2go/x2gobroker/files/x2gobroker.conf
    - template: jinja
    - context:
        config: {{ x2gobroker.server.config|json() }}
