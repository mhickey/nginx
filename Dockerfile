#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM ubuntu:trusty
ENV S3FS_VERSION 1.80

RUN apt-get update && apt-get install -y \
  build-essential \
  software-properties-common \   
  libfuse-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  pkg-config \
  mime-support \
  automake \
  libtool \
  curl \
  tar \
  python-pip \
  python-dev
RUN curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v$S3FS_VERSION.tar.gz | tar zxv -C /usr/src
RUN cd /usr/src/s3fs-fuse-$S3FS_VERSION && ./autogen.sh && ./configure --prefix=/usr/local && make && make install


# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx


# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

#AWSACCESSKEYID
#AWSSECRETACCESSKEY

# Expose ports.
EXPOSE 80
EXPOSE 443
