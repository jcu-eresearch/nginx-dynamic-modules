Changes
=======

1.0.0 (unreleased)
------------------

* Use upstream ``pkg-oss`` compared to trying to maintain our own version.  We
  now live-patch the build scripts to use Mercurial HTTPS protocols instead of
  insecure HTTP.
* Update to work with nginx 1.12.2. This version has a specific dist suffix
  for EL 7.4+.
* Initial configuration.
