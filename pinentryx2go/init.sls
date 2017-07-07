# pinentryx2go
#
# Meta-state to fully install pinentryx2go.

{% from 'x2go/pinentryx2go/map.jinja' import pinentryx2go, sls_block with context %}

include:
  - x2go.pinentryx2go.config
  - x2go.pinentryx2go.client

extend:
  pinentryx2go_config:
    file:
      - require:
        {% if pinentryx2go.build_from_source %}
        - cmd: pinentryx2go_install
        {% else %}
        - pkg: pinentryx2go_install
        {% endif %}
