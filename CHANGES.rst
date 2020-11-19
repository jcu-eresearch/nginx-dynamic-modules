Changes
=======

1.0.0 (unreleased)
------------------

* Add module release versioning support; the ``pkg-oss`` tool only supports
  version 1 irrespective of the ``BASE_RELEASE`` version is.  So, this means
  if you had created a module package for ``1.18.0-1``, your modules would receive
  this version.  However, if ``1.18.0-2`` has been released (or you wanted to
  rebuild a module), your modules would still have the version ``1.18.0-1``,
  presenting problems when uploading them into an RPM repository where the
  first version existed.
* Add support for EL 8
* Update CentOS 6 build with new IUS URL
* Reorder patching of build commands to ensure HTTPS gets used on Nginx
  downloads and so on
* Error out of ``build.sh`` immediately if any command fails
* Bump versions of nginx and modules
* Use upstream ``pkg-oss`` compared to trying to maintain our own version.  We
  now live-patch the build scripts to use Mercurial HTTPS protocols instead of
  insecure HTTP.
* Update to work with nginx 1.12.2. This version has a specific dist suffix
  for EL 7.4+
* Initial configuration
