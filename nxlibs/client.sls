# nxlibs.client
#
# Manages the nxlibs

{% from 'x2go/nxlibs/map.jinja' import nxlibs, sls_block with context %}

include:
  {% if nxlibs.build_from_source %}
  - x2go.nxlibs.src
  {% else %}
  - x2go.nxlibs.pkg
  {% endif %}

nxlibs_client:
  client.completed:
    {{ sls_block(nxlibs.client.opts) }}
    - name: {{ nxlibs.client.clientname }}
    - enable: {{ nxlibs.client.enable }}
    - require:
      {% if nxlibs.build_from_source %}
      - sls: x2go.nxlibs.src
      {% else %}
      - sls: x2go.nxlibs.pkg
      {% endif %}
    - listen:
      {% if nxlibs.build_from_source %}
      - cmd: nxlibs_install
      {% else %}
      - pkg: nxlibs_install
      {% endif %}
