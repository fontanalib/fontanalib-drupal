#!/bin/sh
apt-get update -yqq && add-apt-repository universe

apt-get install -yqq \
    bind-tools \
    curl \
    gdb \
    git \
    grep \
    htop \
    ltrace \
    mysql-server \
    nginx \
    php7.2-fpm \
    php-mysql \
    procps \
    strace \
    sysstat \
    unzip \
    wget \
;