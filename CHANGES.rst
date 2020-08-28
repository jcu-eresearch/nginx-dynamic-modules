Changes
=======

1.0.0 (unreleased)
------------------

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
