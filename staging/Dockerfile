ARG TARGET_UBUNTU_VERSION=18.04
FROM ubuntu:${TARGET_UBUNTU_VERSION}

ENV DOMAIN=staging.fontanalib.localhost
ARG SERVICE_DIR="./staging"

COPY ${SERVICE_DIR}/scripts/ /scripts/

ARG MYSQL_ROOT_PASSWORD=root
ARG MYSQL_DATABASE=fontanalib_d8
ARG MYSQL_USER=drupal
ARG MYSQL_PASSWORD=drupal

RUN /scripts/install-mariadb.sh ${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} ${MYSQL_USER} ${MYSQL_PASSWORD}

# set timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
		tzdata \
	; \
	rm -rf /var/lib/apt/lists/*
ARG TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime 
RUN dpkg-reconfigure -f noninteractive tzdata

RUN set -ex; \
	apt-get update; \
	if ! which gpg; then \
		apt-get install -y --no-install-recommends gnupg; \
	fi; \
	if ! gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
# Ubuntu includes "gnupg" (not "gnupg2", but still 2.x), but not dirmngr, and gnupg 2.x requires dirmngr
# so, if we're not running gnupg 1.x, explicitly install dirmngr too
		apt-get install -y --no-install-recommends dirmngr; \
	fi; \
	rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 \
    && echo 'deb http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list \
    && apt-get update \
    && apt-get install locales \
    && locale-gen en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

RUN apt-get install -y \
    curl \
    git \
    unzip \
    nginx \
    php7.3 \
    php7.3-cli \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-xml \
    php7.3-zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN apt --no-install-recommends install phpmyadmin
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

ARG DRUPAL_USER=drupal
ARG DRUPAL_USER_ID=828

RUN useradd -m -G users,nginx ${DRUPAL_USER}
RUN chown -R drupal:users /usr/local/bin/composer

RUN mkdir -p /var/www/adminer && \
  curl -s -o /var/www/adminer/index.php -L "http://www.adminer.org/latest.php" && \
  chown -R drupal:nginx /var/www/adminer


COPY ${SERVICE_DIR}/docker-run.sh /docker-run.sh
COPY ${SERVICE_DIR}/config/nginx /etc/nginx

EXPOSE 80 443
WORKDIR /var/www/html
USER root
CMD ["/bin/bash", "/docker-run.sh"] 