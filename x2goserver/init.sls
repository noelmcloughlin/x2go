# x2goserver
#
# Meta-state to fully install x2goserver.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}

include:
  - x2go.x2goserver.config
  - x2go.x2goserver.service

extend:
  x2goserver_service:
    service:
      - listen:
        - file: x2goserver_config
      - require:
        - file: x2goserver_config
  x2goserver_config:
    file:
      - require:
        {% if x2goserver.build_from_source %}
        - cmd: x2goserver_install
        {% else %}
        - pkg: x2goserver_install
        {% endif %}
