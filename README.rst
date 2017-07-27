nginx Dynamic Module Packaging
==============================

.. image:: https://travis-ci.org/jcu-eresearch/nginx-dynamic-modules.svg?branch=master
   :target: https://travis-ci.org/jcu-eresearch/nginx-dynamic-modules

This creates packages for a variety of dynamic modules for nginx using the
`nginx-pkg-oss <https://github.com/jcu-eresearch/nginx-pkg-oss>`_ tooling, which
itself is a lightly modified fork of the original tooling of ``pkg-oss`` from
nginx's core team.

We currently support the following OSes:

* CentOS/RHEL 6 (x86_64)
* CentOS/RHEL 7 (x86_64)

This set of modules was originally based on the customised nginx build from
https://github.com/jcu-eresearch/nginx-custom-build.

Modules
-------

headers-more-nginx-module
    Ability to manipulate request and response headers, including at low
    levels.

ngx-fancyindex
    Directory listings that are more visually appealing and customisable.

nginx-http-shibbolth
    Shibboleth authentication support for applications; effectively `mod_shib`
    for nginx.

nginx-auth-ldap
    LDAP authentication with support for multiple servers.

nginx_ajp_module
    Updated for dynamic module compatibility.


Building packages
-----------------

#. Ensure `Docker <https://docs.docker.com/>`_ and `Docker Compose
   <https://docs.docker.com/compose>`_ are installed.

#. Run the following::

       git clone https://github.com/jcu-eresearch/nginx-dynamic-modules.git
       cd nginx-dynamic-modules
       docker-compose up

#. Enjoy your new RPMs, available in the `build/` directory.

If you're not into Docker, then you can manually run
https://github.com/jcu-eresearch/nginx-dynamic-modules/blob/master/build.sh
on your own EL machine, ensuring that you set up your build environment
first. You can follow the respective ``Dockerfile`` in the ``configs/`` area
and its ``RUN`` commands. Beyond that, the build script is self-contained and
will automatically clone the latest patches from this GitHub repository if you
just run the script itself.

The configuration in ``master`` builds packages for the latest **stable**
and **mainline** versions of nginx and will build for all OSes by default.
Note that versions may be slightly out-of-date as we update the code base.

It is also possible to select a specific version of nginx to build against by
setting the environment variable `_NGINX_VERSION` (such as
``export _NGINX_VERSION=1.13.3``), which is used within the build script.
From Docker Compose, you can use the following::

    docker-compose run -e _NGINX_VERSION=1.13.3 nginx-dynamic-modules-centos-7
