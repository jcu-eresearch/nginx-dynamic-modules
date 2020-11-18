FROM centos:8
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Add official nginx repo
COPY nginx.repo /etc/yum.repos.d/

# Add JCU eResearch repo
ADD https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-8/eresearch.repo /etc/yum.repos.d/eresearch.repo

# Install required packages for building with nginx pkg-oss
# git            - to clone our nginx modules
# rsync          - to copy packages out
# mercurial      - required to run pkg-oss (SNI support required)
# wget           - required to run pkg-oss
# openldap-devel - for building nginx LDAP module
# sregex-devel   - for building replace-filter-nginx-module
RUN yum install -y \
  git \
  rsync \
  mercurial \
  wget \
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
  yum install -y ~/nginx-packages/nginx-module-*.rpm && \
  nginx -t -c /app/configs/nginx-test.conf && \
  mkdir -p /app/build/centos-8/ && \
  rsync --no-relative -vahu ~/nginx-packages/ /app/build/centos-8
