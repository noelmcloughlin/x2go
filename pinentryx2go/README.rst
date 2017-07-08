=====
x2go.pinentry-x2go
=====

Install pinentry-x2go either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``x2go.pinentry-x2go``
------------

Meta-state for inclusion of all states.

**Note:** pinentry-x2go requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2go.pinentry-x2go.client``
--------------------

Installs the pinentry-x2go software via package or source.

``x2go.pinentry-x2go.src``
--------------------

Installs the pinentry-x2go software from source.

``x2go.pinentry-x2go.pkg``
--------------------

Installs the pinentry-x2go software from package managers.

