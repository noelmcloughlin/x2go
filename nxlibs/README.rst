=====
x2go.nxlibs
=====

Install nxlibs either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``x2go.nxlibs``
------------

Meta-state for inclusion of all states.

**Note:** nxlibs requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2go.nxlibs.client``
--------------------

Installs the nxlibs software via package or source.

``x2go.nxlibs.src``
--------------------

Installs the nxlibs software from source.

``x2go.nxlibs.pkg``
--------------------

Installs the nxlibs software from package managers.

