# x2goserver.service
#
# Manages the x2goserver service.

{% from 'x2go/x2goserver/map.jinja' import x2goserver, sls_block with context %}
{% set service_function = {True:'running', False:'dead'}.get(x2goserver.service.enable) %}

include:
  {% if x2goserver.build_from_source %}
  - x2go.x2goserver.src
  {% else %}
  - x2go.x2goserver.pkg
  {% endif %}

{% if x2goserver.build_from_source %}
x2goserver_systemd_service_file:
  file.managed:
    - name: /lib/systemd/system/x2goserver.service
    - source: salt://x2go/x2goserver/files/x2goserver.service
    - template: jinja
{% endif %} 
  
x2goserver_service:
  service.{{ service_function }}:
    {{ sls_block(x2goserver.service.opts) }}
    - name: {{ x2goserver.service.servicename }}
    - enable: {{ x2goserver.service.enable }}
    - require:
      {% if x2goserver.build_from_source %}
      - sls: x2go.x2goserver.src
      {% else %}
      - sls: x2go.x2goserver.pkg
      {% endif %}
    - listen:
      {% if x2goserver.build_from_source %}
      - cmd: x2goserver_install
      {% else %}
      - pkg: x2goserver_install
      {% endif %}
