=====
x2goserver
=====

Install x2goserver either by source or by package.

.. note::


    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``x2goserver``
---------

Runs the states to install x2goserver, configure the common files, and the users.

``x2goserver.common``
----------------

Ensures standard x2goserver files are in place, and configures enabled sites.

``x2goserver.package``
-----------------

Installs the x2goserver package via package manager.

``x2goserver.source``
----------------

Installs x2goserver via the source files.

``x2goserver.users``
---------------

Installs and configures x2goserver users specified in the pillar. 
This requires `basicauth <https://github.com/saltstack/salt-contrib/blob/master/modules/basicauth.py>`_ 
from `salt-contrib <https://github.com/saltstack/salt-contrib/>`_ (either add it to your salt or ship 
this single file in your `_modules` directory see `Dynamic Module Distribution 
<https://docs.saltstack.com/en/latest/ref/file_server/dynamic-modules.html>`_

Next-generation, alternate approach
===================================

The following states provide an alternate approach to managing X2goserver and X2goserver
servers, as well as code organization. Please provide feedback by filing issues,
discussing in ``#salt`` in Freenode and the mailing list as normal.

.. contents::
    :local:

``x2goserver.ng``
------------

Meta-state for inclusion of all ng states.

**Note:** x2goserver.ng requires the merge parameter of salt.modules.pillar.get(),
first available in the Helium release.

``x2goserver.ng.install``
--------------------

Installs the x2goserver package.

``x2goserver.ng.config``
-------------------

Manages the x2goserver main server configuration file.

``x2goserver.ng.service``
--------------------

Manages the startup and running state of the x2goserver service.

``x2goserver.ng.servers_config``
--------------------------

Manages virtual host files. This state only manages the content of the files
and does not bind them to service calls.

``x2goserver.ng.servers``
-------------------

Manages x2goserver virtual hosts files and binds them to service calls.
