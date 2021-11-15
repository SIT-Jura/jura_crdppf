[![CI](https://github.com/camptocamp/jura_crdppf/workflows/CI/badge.svg?branch=main)](https://github.com/camptocamp/jura_crdppf/actions)

Welcome to the jura_crdppf project.

jura_crdppf is a container web application for
`pyramid_oereb <https://github.com/camptocamp/pyramid_oereb>`__,
configured and customized to be run in Janton Jura's environment.
See the project `Wiki <https://github.com/camptocamp/jura_crdppf/wiki>`__ for more information.

Checkout
--------

.. code::

   git clone git@github.com:camptocamp/jura_crdppf.git

   cd jura_crdppf

Build and serve
---------------

.. code::

  cp sample.env .env

Then edit the ``.env`` file. It will be automatically used by docker-compose.

**This file is not commited**. Be sure you have one well configured.

Then run:

.. code::

  make serve

Make it accessible
------------------

Set a proxy in ``/var/www/vhosts/sitj/conf/proxies.conf`` using a
ProxyPass like that: ``ProxyPass "ProxyPass <route_prefix>" "http://localhost:<external_port>/<route_prefix>"``.

Where ``route_prefix`` and the ``external_port`` are the ones defined in
your ``.env`` file.

Then run:

.. code::

  sudo apachectl graceful

You can test your installation at ``https://geo-test.jura.ch/<route_prefix>/versions/json`.
