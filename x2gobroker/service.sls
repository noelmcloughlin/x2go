# x2gobroker.service
#
# Manages the x2gobroker service.

{% from 'x2go/x2gobroker/map.jinja' import x2gobroker, sls_block with context %}
{% set service_function = {True:'running', False:'dead'}.get(x2gobroker.service.enable) %}

include:
  {% if x2gobroker.build_from_source %}
  - x2go.x2gobroker.src
  {% else %}
  - x2go.x2gobroker.pkg
  {% endif %}

{% if x2gobroker.build_from_source %}
x2gobroker_systemd_service_file:
  file.managed:
    - name: /lib/systemd/system/x2gobroker.service
    - source: salt://x2go/x2gobroker/files/x2gobroker.service
    - template: jinja
{% endif %} 
  
x2gobroker_service:
  service.{{ service_function }}:
    {{ sls_block(x2gobroker.service.opts) }}
    - name: {{ x2gobroker.service.servicename }}
    - enable: {{ x2gobroker.service.enable }}
    - require:
      {% if x2gobroker.build_from_source %}
      - sls: x2go.x2gobroker.src
      {% else %}
      - sls: x2go.x2gobroker.pkg
      {% endif %}
    - listen:
      {% if x2gobroker.build_from_source %}
      - cmd: x2gobroker_install
      {% else %}
      - pkg: x2gobroker_install
      {% endif %}
