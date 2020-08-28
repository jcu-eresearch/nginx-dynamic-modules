nginx Dynamic Module Packaging
==============================

.. image:: https://travis-ci.org/jcu-eresearch/nginx-dynamic-modules.svg?branch=master
   :target: https://travis-ci.org/jcu-eresearch/nginx-dynamic-modules

This creates packages for a variety of dynamic modules for nginx using the
official nginx `pkg-oss <https://hg.nginx.org/pkg-oss>`_ tooling for building
modules.

We currently support the following OSes:

* CentOS/RHEL 8 (x86_64)
* CentOS/RHEL 7 (x86_64)
* CentOS/RHEL 6 (x86_64)

This set of modules was originally based on the customised nginx build from
https://github.com/jcu-eresearch/nginx-custom-build.

Todo
----

* Switch nginx_ajp_module to mainline now that
  https://github.com/yaoweibin/nginx_ajp_module/pull/45 was merged
* Switch nginx_auth_ldap to mainline when/if
  https://github.com/kvspb/nginx-auth-ldap/pull/234 is merged

Modules
-------

headers-more-nginx-module
    Ability to manipulate request and response headers, including at low
    levels.

ngx-fancyindex
    Directory listings that are more visually appealing and customisable.

nginx-http-shibbolth
    Shibboleth authentication support for applications; effectively ``mod_shib``
    for nginx.

nginx-auth-ldap
    LDAP authentication with support for multiple servers.

nginx_ajp_module
    Updated for dynamic module compatibility.

replace-filter-nginx-module
    ngx_replace_filter - Streaming regular expression replacement in response
    bodies.

Building packages
-----------------

#. Ensure `Docker <https://docs.docker.com/>`_ and `Docker Compose
   <https://docs.docker.com/compose>`_ are installed.

#. Run the following::

       git clone https://github.com/jcu-eresearch/nginx-dynamic-modules.git
       cd nginx-dynamic-modules
       make

#. Enjoy your new RPMs, available in the ``build/`` directory.

#. Push to repository hosting and update the
   `shared-salt-states <https://github.com/jcu-eresearch/shared-salt-states/edit/master/nginx/init.sls>`_ version details.

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
setting the environment variable ``_NGINX_VERSION`` (such as
``export _NGINX_VERSION=1.99.9``), which is used within the build script.
From Docker Compose, you can use the following::

    docker-compose run -e _NGINX_VERSION=1.99.9 nginx-dynamic-modules-centos-7

Testing locally
---------------

If you want to test the modules, you can do so by launching a Docker container
with the appropriate OS, installing the built packages and testing. To do so::

    make
    make test

The latter command will launch you into the Docker container. Now, inside this
running container, call::

    dnf install /app/build/centos-8/RPMS/x86_64/*.rpm

To run a basic smoke test with all current modules, call nginx like so::

    nginx -t -c /app/configs/nginx-test.conf

Unless you're just performing basic tests without hitting nginx, you'll need
to map ports. The ``Makefile`` is providing the ``-p`` flag to
``docker-compose`` which maps your host port ``8080`` to ``80`` inside the
container. This menas you can launch nginx with the following command and
access it from your host on ``localhost:8080`` to perform further tests::

    nginx -c /app/configs/nginx-test.conf

Note that nginx will daemonise by default.


Updating Docker images
----------------------

To update the Docker images themselves to their latest versions, do the following::

    make build

Updating for future Nginx versions
----------------------------------

#. Edit Nginx versions within ``build.sh`` and ``.travis.yml`` to match the latest
   versions.  In the build script, we use Nginx stable by default and for
   Travis, we test on CI for both stable and mainline.

#. Rebuild and test the results::

       make rebuild

#. Many types of failures can occur at this point.  Some of the most common
   are:

   * ``pkg-oss`` not updated (yet) with files for this Nginx version: be
     patient and check back later.
   * Specific module fails to build and/or is no longer compatible with this
     Nginx version: look for module updates or report issues to the respective
     maintainers.
   * ``pkg-oss`` build process has changed: review changes in ``pkg-oss`` and
     update ``build.sh`` to match.
   * ``build_module.sh`` patch for ``pkg-oss`` is no longer applying: create a
     new patch for forcing ``pkg-oss`` to use HTTPS to download and build.
