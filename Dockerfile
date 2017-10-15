FROM ubuntu:16.04
LABEL maintainer="https://github.com/hrcc"

ENV DEBIAN_FRONTEND noninteractive

# Update & locale setup
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# INSTALL general packages, PHP 7.1, Composer
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y curl unzip git software-properties-common \ 
    && add-apt-repository -y ppa:ondrej/php && apt-get update \
    && apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql \
       php7.1-pgsql php7.1-imap php7.1-memcached php7.1-mbstring php7.1-xml \
    && mkdir /run/php \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*