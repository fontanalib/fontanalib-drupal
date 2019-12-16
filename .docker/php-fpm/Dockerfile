ARG TARGET_PHP_VERSION=7.3
FROM php:${TARGET_PHP_VERSION}-fpm

ARG SERVICE_DIR="./php-fpm"
COPY ./.shared/scripts/ /tmp/scripts/
RUN chmod +x -R /tmp/scripts/

# set timezone
ARG TZ=America/New_York
RUN /tmp/scripts/set_timezone.sh ${TZ}

# add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

RUN /tmp/scripts/install_php_extensions.sh

RUN /tmp/scripts/install_software.sh

# php config
COPY ./.shared/config/php/conf.d/*  /usr/local/etc/php/conf.d/

# php-fpm pool config
COPY ${SERVICE_DIR}/php-fpm.d/* /usr/local/etc/php-fpm.d
RUN /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_USER" \
    "${APP_USER}" \
 && /tmp/scripts/modify_config.sh /usr/local/etc/php-fpm.d/pool.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
;

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
# USER www-data
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# workdir
ARG APP_CODE_PATH="/var/www/html"

RUN composer create-project drupal/recommended-project /tmp/project --no-interaction
#RUN composer create-project drupal-composer/drupal-project:8.x-dev /tmp/project --no-interaction

WORKDIR "$APP_CODE_PATH"
# entrypoint
RUN mkdir -p /bin/docker-entrypoint/ \
 && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
 && chmod +x -R /bin/docker-entrypoint/ \
;
# RUN mkdir -p /bin/docker-entrypoint/
# # COPY ${SERVICE_DIR}/docker-entrypoint.sh /bin/docker-entrypoint/
# RUN cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
#  && chmod +x -R /bin/docker-entrypoint/
# RUN chown -R www-data:www-data /tmp/project
# RUN chown -R www-data:www-data /var/www
RUN /tmp/scripts/cleanup.sh

# USER www-data

# ENTRYPOINT ["/bin/docker-entrypoint/drupal.sh"]
# CMD ["/bin/sh", "-c", "cp -rf /tmp/project/* $APP_CODE_PATH"]
# CMD ["/tmp/scripts/cleanup.sh"]
# CMD ["/bin/sh", "-c", "cp -Ru /tmp/project/. /var/www/html"]
ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh","php-fpm"]
EXPOSE 9000
