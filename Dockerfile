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
    && apt-get install -y curl wget unzip git software-properties-common

# Dockerize v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz \
    && rm dockerize-linux-amd64-v0.6.1.tar.gz

# PHP 7.2
RUN add-apt-repository -y ppa:ondrej/php && apt-get update \
    && apt-get install -y php7.2-fpm php7.2-cli php7.2-gd php7.2-mysql \
       php7.2-pgsql php7.2-sqlite3 php7.2-imap php7.2-memcached php7.2-mbstring php7.2-xml \       
       php7.2-json php7.2-curl php7.2-gd php7.2-gmp php7.2-mbstring php7.2-zip php-redis \
    && phpenmod mcrypt \
    && mkdir /run/php

# Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Node.js v10
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install nodejs -y

# Cleanup for smaller image size
RUN apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
