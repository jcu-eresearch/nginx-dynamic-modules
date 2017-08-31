FROM centos:7
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Add official nginx repo
COPY nginx.repo /etc/yum.repos.d/

# Add JCU eResearch repo
ADD https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-7/eresearch.repo /etc/yum.repos.d/eresearch.repo

# Install required packages for building with nginx pkg-oss
# git is needed to clone our tools, and sudo/wget are undefined dependencies
# sregex-devel is needed for replace-filter-nginx-module
# openldap-devel is for the nginx LDAP module
RUN yum install -y \
  git \
  openldap-devel \
  sregex-devel \
  sudo \
  wget

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
  rsync --no-relative -vahu ~/nginx-packages/RPMS ~/nginx-packages/SRPMS /app/build/centos-7
