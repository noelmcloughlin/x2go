# x2gobroker
#
# Meta-state to fully install x2gobroker.

{% from 'x2go/x2gobroker/map.jinja' import x2gobroker, sls_block with context %}

include:
  - x2go.x2gobroker.config
  - x2go.x2gobroker.service

extend:
  x2gobroker_service:
    service:
      - listen:
        - file: x2gobroker_config
      - require:
        - file: x2gobroker_config
  x2gobroker_config:
    file:
      - require:
        {% if x2gobroker.build_from_source %}
        - cmd: x2gobroker_install
        {% else %}
        - pkg: x2gobroker_install
        {% endif %}
