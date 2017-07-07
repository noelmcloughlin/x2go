# x2goclient.client
#
# Manages the x2goclient client.

{% from 'x2go/x2goclient/map.jinja' import x2goclient, sls_block with context %}

include:
  {% if x2goclient.build_from_source %}
  - x2go.x2goclient.src
  {% else %}
  - x2go.x2goclient.pkg
  {% endif %}

x2goclient_client:
  client.completed:
    {{ sls_block(x2goclient.client.opts) }}
    - name: {{ x2goclient.client.clientname }}
    - enable: {{ x2goclient.client.enable }}
    - require:
      {% if x2goclient.build_from_source %}
      - sls: x2go.x2goclient.src
      {% else %}
      - sls: x2go.x2goclient.pkg
      {% endif %}
    - listen:
      {% if x2goclient.build_from_source %}
      - cmd: x2goclient_install
      {% else %}
      - pkg: x2goclient_install
      {% endif %}
