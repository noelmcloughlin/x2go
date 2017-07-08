=====
x2goserver
=====

Install x2goserver either by source or by package.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents::
    :local:

``x2g.x2goserver``
------------

Meta-state for inclusion of all states.

**Note:** x2g.x2goserver requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2g.x2goserver.install``
--------------------

Installs the x2goserver package.

``x2g.x2goserver.config``
-------------------

Manages the x2goserver main server configuration file.

``x2g.x2goserver.service``
--------------------

Manages the startup and running state of the x2goserver service.

