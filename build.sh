#!/bin/bash
set -e

# pkg-oss defaults to using Nginx mainline if no version is specified, so
# this version is manually kept in lock-step with stable
if [ -z "$_NGINX_VERSION" ]; then
  _NGINX_VERSION='1.18.0'
fi

# Set up directories
OUTPUT_DIR=~/nginx-packages
mkdir -p "$OUTPUT_DIR"
temp_dir=$(mktemp -d)

# Get build tools
build_scripts_dir="$temp_dir/pkg-oss"
hg clone https://hg.nginx.org/pkg-oss "$build_scripts_dir"

_build_dynamic_module_git() {
    nickname="$1"
    module_url="$2"
    module_version="$3"
    module_src="$temp_dir/$nickname"

    # Ensure we always start in a valid cwd
    cd "$temp_dir"

    # Checkout specific version
    #   git clone -b [tag] isn't supported on git 1.7 (RHEL 6)
    git clone "$module_url" "$module_src"
    pushd "$module_src" && git checkout "$module_version" && popd

    # Build dynamic module
    "$build_scripts_dir/build_module.sh" --non-interactive -o "$OUTPUT_DIR" -v "$_NGINX_VERSION" --nickname "$nickname" "$module_src"

    # Cleanup
    rm -rf "$module_src"
}

# Build various add-on modules for nginx
_build_dynamic_module_git "headersmore" "https://github.com/openresty/headers-more-nginx-module" "v0.33"
_build_dynamic_module_git "fancyindex" "https://github.com/aperezdc/ngx-fancyindex.git" "v0.4.4"
_build_dynamic_module_git "ajp" "https://github.com/yaoweibin/nginx_ajp_module.git" "a964a0bcc6a9f2bfb82a13752d7794a36319ffac"
_build_dynamic_module_git "shibboleth" "https://github.com/nginx-shib/nginx-http-shibboleth.git" "v2.0.1"
_build_dynamic_module_git "authldap" "https://github.com/jcu-eresearch/nginx-auth-ldap.git"
_build_dynamic_module_git "replacefilter" "https://github.com/openresty/replace-filter-nginx-module.git" "e0257b2d2a0b380f8645a6e68655dd77c19a3f69"

echo "Done! Module packages saved to $OUTPUT_DIR."
rm -rf "$temp_dir"
