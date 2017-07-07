# x2goclient
#
# Meta-state to fully install x2goclient.

{% from 'x2go/x2goclient/map.jinja' import x2goclient, sls_block with context %}

include:
  - x2go.x2goclient.config
  - x2go.x2goclient.client

extend:
  x2goclient_config:
    file:
      - require:
        {% if x2goclient.build_from_source %}
        - cmd: x2goclient_install
        {% else %}
        - pkg: x2goclient_install
        {% endif %}
