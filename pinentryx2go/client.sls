# pinentryx2go.client
#
# Manages the pinentryx2go client.

{% from 'x2go/pinentryx2go/map.jinja' import pinentryx2go, sls_block with context %}

include:
  {% if pinentryx2go.build_from_source %}
  - x2go.pinentryx2go.src
  {% else %}
  - x2go.pinentryx2go.pkg
  {% endif %}

pinentryx2go_client:
  client.completed:
    {{ sls_block(pinentryx2go.client.opts) }}
    - name: {{ pinentryx2go.client.clientname }}
    - enable: {{ pinentryx2go.client.enable }}
    - require:
      {% if pinentryx2go.build_from_source %}
      - sls: x2go.pinentryx2go.src
      {% else %}
      - sls: x2go.pinentryx2go.pkg
      {% endif %}
    - listen:
      {% if pinentryx2go.build_from_source %}
      - cmd: pinentryx2go_install
      {% else %}
      - pkg: pinentryx2go_install
      {% endif %}
