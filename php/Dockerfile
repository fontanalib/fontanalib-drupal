ARG TARGET_PHP_VERSION=7.3-fpm
FROM php:${TARGET_PHP_VERSION}-alpine

RUN set -ex; \
	\
  apk update; \
  apk add --no-cache openssl wget; \
  \
# # download helper script
# @see https://github.com/mlocati/docker-php-extension-installer/
wget -q -O /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
    || (echo "Failed while downloading php extension installer!"; exit 1); \
  \
chmod uga+x /usr/local/bin/install-php-extensions && sync && install-php-extensions \
    gd \
    imagick \
    opcache \
    pdo_mysql \
		pdo_pgsql \
    zip \
    xdebug \
    yaml \
;

RUN apk update && apk add --no-cache \
    sudo \
    tzdata \
    bind-tools \
    curl \
    gdb \
    git \
    grep \
    htop \
    ltrace \
    procps \
    shadow \
    strace \
    sysstat \
    unzip \
;
# set timezone
ARG TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
ARG ARG_APP_USER=www-data
ARG ARG_APP_GROUP=www-data
ARG ARG_APP_USER_ID=82
ARG ARG_APP_GROUP_ID=82

COPY ./php/scripts/  /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

RUN /tmp/scripts/create_user.sh ${ARG_APP_USER} ${ARG_APP_GROUP} ${ARG_APP_USER_ID} ${ARG_APP_GROUP_ID}

# php config
COPY ./config/php/conf.d/*  /usr/local/etc/php/conf.d/

# php-fpm pool config
COPY ./config/php/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_USER" \
    "${ARG_APP_USER}" \
 && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_GROUP" \
    "${ARG_APP_GROUP}" \
;
ARG DRUPAL_USER=drupal
ARG DRUPAL_USER_ID=828

RUN useradd -m -g users -G ${ARG_APP_GROUP} ${DRUPAL_USER}


# workdir
ARG APP_CODE_PATH="/var/www/html"

WORKDIR "$APP_CODE_PATH"

RUN rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /var/log/lastlog \
       /var/log/faillog

EXPOSE 9000
CMD ["php-fpm"]