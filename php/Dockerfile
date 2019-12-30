ARG TARGET_PHP_VERSION=7.3-fpm
FROM php:${TARGET_PHP_VERSION}-alpine

ARG SERVICE_DIR="./php"
COPY ./.dev/.config/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
ARG TZ=America/New_York
RUN /tmp/scripts/set_timezone.sh ${TZ}

RUN /tmp/scripts/install_php_extensions.sh

RUN /tmp/scripts/install_software.sh

ARG APP_USER=nginx
ARG APP_GROUP=nginx
ARG APP_USER_ID=101
ARG APP_GROUP_ID=101
RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

# php config
COPY ./.dev/.config/php/conf.d/*  /usr/local/etc/php/conf.d/

# php-fpm pool config
COPY ./.dev/.config/php/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_USER" \
    "${APP_USER}" \
 && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
;
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

COPY ./.dev/composer.json /var/www/html/
# workdir
ARG APP_CODE_PATH="/var/www/html"

WORKDIR "$APP_CODE_PATH"
RUN composer install
RUN /tmp/scripts/cleanup.sh
# USER nginx:nginx
# RUN chown -hR nginx:nginx /var/www/html && chmod -R 755 /var/html/web/sites/default
EXPOSE 9000
CMD ["php-fpm"]