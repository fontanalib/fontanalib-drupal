ARG TARGET_PHP_VERSION=7.3-fpm
FROM php:${TARGET_PHP_VERSION}-alpine
# USER root
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
RUN printf "\nopcache.enable = 0" >> /usr/local/etc/php/conf.d/zz-drupal.ini
ARG DRUPAL_USER=drupal
ARG DRUPAL_USER_ID=828

RUN useradd -m -g users -G ${ARG_APP_GROUP} ${DRUPAL_USER}

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chown -R drupal:users /usr/local/bin/composer

# workdir
ARG APP_CODE_PATH="/var/www/html"
COPY ./composer.json $APP_CODE_PATH
WORKDIR "$APP_CODE_PATH"


#mkdir -p /project/drupal && mkdir -p /project/production && 


RUN chown drupal:${ARG_APP_GROUP} composer.json

USER drupal
RUN composer install

RUN mkdir -p $APP_CODE_PATH/web/sites/default/files
# RUN chown -R drupal:nginx web
RUN mkdir -p $APP_CODE_PATH/web/modules/custom && mkdir -p $APP_CODE_PATH/web/themes/custom
RUN chown -R drupal:${ARG_APP_GROUP} ${APP_CODE_PATH}/web && chmod g+s ${APP_CODE_PATH}/web
RUN chmod 775 $APP_CODE_PATH/web/sites/default/files
USER root
RUN rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /var/log/lastlog \
       /var/log/faillog
USER drupal
EXPOSE 9000
CMD ["php-fpm"]