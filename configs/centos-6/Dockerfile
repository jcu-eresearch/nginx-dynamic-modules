FROM centos:6
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Add official nginx repo
COPY nginx.repo /etc/yum.repos.d/

# Add JCU eResearch repo
ADD https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-6/eresearch.repo /etc/yum.repos.d/eresearch.repo

# Install SNI-supporting Mercurial from source
RUN yum install -y epel-release && \
  rpm -ivh https://centos6.iuscommunity.org/ius-release.rpm && \
  yum install -y gcc python27 python27-devel && \
  curl -O https://www.mercurial-scm.org/release/mercurial-4.6.2.tar.gz && \
  tar xf mercurial-4.6.2.tar.gz && \
  cd mercurial-4.6.2 && \
  PYTHONPATH=/usr/lib64/python2.7 make install-bin PYTHON=python2.7 PREFIX=/usr

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
