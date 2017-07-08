=====
x2go.x2goclient
=====

Install x2goclient either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``x2go.x2goclient``
------------

Meta-state for inclusion of all states.

**Note:** x2goclient requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2go.x2goclient.client``
--------------------

Installs the x2goclient software via package or source.

``x2go.x2goclient.src``
--------------------

Installs the x2goclient software from source.

``x2go.x2goclient.pkg``
--------------------

Installs the x2goclient software from package managers.

