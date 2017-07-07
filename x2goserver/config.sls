# x2goserver.config
#
# Manages the main x2goserver server configuration file.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}


{% if x2goserver.build_from_source %}
### Check if this is actually needed - x2go may use syslog ....
x2goserver_log_dir:
  file.directory:
    - name: /var/log/x2goserver
    - user: {{ x2goserver.service.user }}
    - group: {{ x2goserver.service.user }}
{% endif %}

x2goserver_config:
  file.managed:
    {{ sls_block(x2goserver.server.opts) }}
    - name: {{ x2goserver.service.conf_dir }}/{{ x2goserver.service.conf_file }}.salt-formula-todo
    - source: salt://x2go/x2goserver/files/x2goserver.conf
    - template: jinja
    - context:
        config: {{ x2goserver.server.config|json() }}
