FROM centos:6
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Add official nginx repo
COPY nginx.repo /etc/yum.repos.d/

# Install required packages for building with nginx pkg-oss
# git is needed to clone our tools, and sudo/wget are undefined dependencies
# openldap-devel is for the nginx LDAP module
RUN yum install -y \
  openldap-devel \
  git \
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
  rsync --no-relative -vahu ~/nginx-packages/RPMS ~/nginx-packages/SRPMS /app/build/centos-6
