#!/bin/bash
set -e

# pkg-oss defaults to using Nginx mainline if no version is specified, so
# these versions are manually kept in lock-step with stable
if [ -z "$_NGINX_VERSION" ]; then
  _NGINX_VERSION=1.20.0
fi

OUTPUT_DIR=~/nginx-packages
mkdir -p "$OUTPUT_DIR"

temp_dir=$(mktemp -d)

build_scripts_dir="$temp_dir/pkg-oss"
hg clone https://hg.nginx.org/pkg-oss "$build_scripts_dir"

# Patch pkg-oss to use HTTPS during initial build_module.sh run
find "$build_scripts_dir" -type f -not -path "./.hg/*" -exec sed -E -i 's!http://(.*nginx.org)!https://\1!g' {} +

# Patch pkg-oss to use HTTPS after it downloads itself later
patch "$build_scripts_dir/build_module.sh" << EOF
--- build_module.sh
+++ build_module.sh
@@ -321,2 +321,3 @@
 	hg clone \$MERCURIAL_TAG https://hg.nginx.org/pkg-oss
+	find pkg-oss/ -type f -not -path "./.hg/*" -exec sed -E -i 's!http://(.*nginx.org)!https://\1!g' {} +
 	cd pkg-oss/\$PACKAGING_DIR
EOF

_build_dynamic_module_git() {
    nickname="$1"
    module_git_url="$2"
    module_git_rev="$3"
    module_release_version="$4"
    module_src="$temp_dir/$nickname"

    # Ensure we always start in a valid cwd
    cd "$temp_dir"

    # Checkout specific version
    #   git clone -b [tag] isn't supported on git 1.7 (RHEL 6)
    git clone "$module_git_url" "$module_src"
    pushd "$module_src" && git checkout "$module_git_rev" && popd

    # Build dynamic module
    "$build_scripts_dir/build_module.sh" \
        --non-interactive \
        --nickname "$nickname" \
        --module-version "$module_release_version" \
        -v "$_NGINX_VERSION" \
        -o "$OUTPUT_DIR" \
        "$module_src"

    # Cleanup
    rm -rf "$module_src"
}

# Build various add-on modules for nginx
_build_dynamic_module_git "headersmore" "https://github.com/openresty/headers-more-nginx-module" "v0.33" "0.33-1"
_build_dynamic_module_git "fancyindex" "https://github.com/aperezdc/ngx-fancyindex.git" "v0.5.1" "0.5.1-1"
_build_dynamic_module_git "ajp" "https://github.com/yaoweibin/nginx_ajp_module.git" "a964a0bcc6a9f2bfb82a13752d7794a36319ffac" "0.0.1-1"
_build_dynamic_module_git "shibboleth" "https://github.com/nginx-shib/nginx-http-shibboleth.git" "v2.0.1" "2.0.1-1"
_build_dynamic_module_git "authldap" "https://github.com/jcu-eresearch/nginx-auth-ldap.git" "" "0.0.1-1"
_build_dynamic_module_git "replacefilter" "https://github.com/openresty/replace-filter-nginx-module.git" "e0257b2d2a0b380f8645a6e68655dd77c19a3f69" "0.0.1-1"

echo "Done! Module packages saved to $OUTPUT_DIR."
rm -rf "$temp_dir"
