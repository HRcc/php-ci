FROM phusion/baseimage:latest
LABEL maintainer="https://github.com/hrcc"

ENV DEBIAN_FRONTEND noninteractive

CMD ["/sbin/my_init"]

# Update & locale setup
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# INSTALL
RUN apt-get update \
    && apt-get install -y curl unzip git software-properties-common

# PHP 7.1
RUN add-apt-repository -y ppa:ondrej/php && apt-get update \
    && apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql \
       php7.1-pgsql php7.1-sqlite3 php7.1-imap php7.1-memcached php7.1-mbstring php7.1-xml \       
       php7.1-json php7.1-curl php7.1-gd php7.1-gmp php7.1-mbstring php7.1-zip php-redis \
    && phpenmod mcrypt \
    && mkdir /run/php

# Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Node.js v8
RUN curl --silent --location https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install nodejs -y

# Cleanup for smaller image size
RUN apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*