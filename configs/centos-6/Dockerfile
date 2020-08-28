FROM centos:6
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Add official nginx repo
COPY nginx.repo /etc/yum.repos.d/

# Add JCU eResearch repo
ADD https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-6/eresearch.repo /etc/yum.repos.d/eresearch.repo

# Install SNI-supporting Mercurial
RUN yum install -y https://www.mercurial-scm.org/release/centos6/mercurial-5.5-1+2.7.16.x86_64.rpm

# Install required packages for building with nginx pkg-oss
# patch is needed to make pkg-oss use HTTPS
# git is needed to clone our nginx modules
# openldap-devel is for the nginx LDAP module
# sregex-devel is needed for replace-filter-nginx-module
RUN yum install -y \
  sudo \
  wget \
  patch \
  git \
  openldap-devel \
  sregex-devel

# Make the build area available
RUN mkdir -p /app/build

# Expose web ports for nginx
EXPOSE 80 443

# 1. Build
# 2. Test
# 3. Copy the RPMs back to the host volume
CMD /app/build.sh && \
  yum install -y ~/nginx-packages/RPMS/x86_64/nginx-module-*.rpm && \
  nginx -t -c /app/configs/nginx-test.conf && \
  rsync --no-relative -vahu ~/nginx-packages/RPMS ~/nginx-packages/SRPMS /app/build/centos-6
