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
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get install -y php-fpm php-cli php-mcrypt php-gd php-mysql \
       php-pgsql php-imap php-memcached php-mbstring php-xml \
    && mkdir /run/php \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get remove -y --purge software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*