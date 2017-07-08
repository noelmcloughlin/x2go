=====
x2gobroker
=====

Install x2gobroker either by source or by package.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents::
    :local:

``x2g.x2gobroker``
------------

Meta-state for inclusion of all states.

**Note:** x2g.x2gobroker requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2g.x2gobroker.pkg``
--------------------

Installs the x2gobroker software from package.

``x2g.x2gobroker.src``
-------------------

Installs the x2gobroker software from source code.

``x2g.x2gobroker.service``
--------------------

Manages the startup and running state of the x2gobroker service.

