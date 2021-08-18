#!/bin/sh

if [ "$_NGINX_RELEASE" = "mainline" ]; then
  sed -i 's/stable/mainline/g;s/\/packages/\/packages\/mainline/g' /etc/yum.repos.d/nginx.repo
  yum clean metadata
fi
