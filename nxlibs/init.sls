# nxlibs
#
# Meta-state to fully install nxlibs.

{% from 'x2go/nxlibs/map.jinja' import nxlibs, sls_block with context %}

include:
  - x2go.nxlibs.config
  - x2go.nxlibs.client

extend:
  nxlibs_config:
    file:
      - require:
        {% if nxlibs.build_from_source %}
        - cmd: nxlibs_install
        {% else %}
        - pkg: nxlibs_install
        {% endif %}
