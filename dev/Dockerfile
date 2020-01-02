FROM fontanalib_staging
ARG ARG_APP_USER=www-data
ARG ARG_APP_GROUP=www-data

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chown -R nginx:nginx /usr/local/bin/composer

RUN mkdir -p /project/drupal && mkdir -p /project/production && chown -R ${ARG_APP_USER}:${ARG_APP_GROUP} /project && chmod g+s /project

USER nginx
COPY ./composer.json /project/drupal
# COPY ./dev/copy.sh /copy.sh
# COPY ./dev/drupal_settings.txt /tmp/drupal_settings.txt

WORKDIR /project/drupal

RUN composer install

# RUN chown -R ${ARG_APP_USER}:${ARG_APP_GROUP} /project/drupal/web/sites/default && chmod -R 777 /project/drupal/web/sites/default

EXPOSE 9000
CMD ["php-fpm"]