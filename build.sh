#!/bin/bash

if [ -z "$_NGINX_VERSION" ]; then
  _NGINX_VERSION='1.12.2'
fi

OUTPUT_DIR=~/nginx-packages
temp_dir=$(mktemp -d)

# Obtain a location for the pkg config, either from /app (Docker)
# or cloned from GitHub (if run stand-alone).
if [ -d '/app' ]; then
    build_scripts_dir='/app/nginx-pkg-oss'
else
    build_scripts_dir="$temp_dir/nginx-pkg-oss"
    git clone https://github.com/jcu-eresearch/nginx-pkg-oss.git "$build_scripts_dir"
fi

_build_dynamic_module_git() {
    nickname="$1"
    module_url="$2"
    module_version="$3"
    module_src="$temp_dir/$nickname"

    # Preempt deletion of build directory
    rm -rf ~/rpmbuild

    # Checkout specific version
    #   git clone -b [tag] isn't supported on git 1.7 (RHEL 6)
    git clone "$module_url" "$module_src"
    pushd "$module_src" && git checkout "$module_version" && popd

    # Build dynamic module
    "$build_scripts_dir/build_module.sh" --non-interactive -v "$_NGINX_VERSION" --nickname "$nickname" "$module_src"

    # Copy built packages
    mkdir -p "$OUTPUT_DIR"
    cp -R ~/rpmbuild/{RPMS,SRPMS} "$OUTPUT_DIR"

    # Cleanup
    rm -rf "$module_src"
}

# Build various add-on modules for nginx
_build_dynamic_module_git "headersmore" "https://github.com/openresty/headers-more-nginx-module" "v0.32"
_build_dynamic_module_git "fancyindex" "https://github.com/aperezdc/ngx-fancyindex.git" "v0.4.2"
_build_dynamic_module_git "ajp" "https://github.com/jcu-eresearch/nginx_ajp_module.git"
_build_dynamic_module_git "shibboleth" "https://github.com/nginx-shib/nginx-http-shibboleth.git" "v2.0.1"
_build_dynamic_module_git "authldap" "https://github.com/jcu-eresearch/nginx-auth-ldap.git"
_build_dynamic_module_git "replacefilter" "https://github.com/openresty/replace-filter-nginx-module.git" "8f9d119"

echo "Done! Module packages saved to $OUTPUT_DIR."
rm -rf "$temp_dir"
