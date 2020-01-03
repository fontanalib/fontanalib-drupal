FROM fontanalib_php
# ARG ARG_APP_USER=www-data
ARG ARG_APP_GROUP=www-data

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
#&& chown -R drupal:users /usr/local/bin/composer


RUN mkdir -p /project/drupal && mkdir -p /project/production && chown -R drupal:${ARG_APP_GROUP} /project && chmod g+s /project
COPY ./composer.json /project/drupal

# COPY ./dev/copy.sh /copy.sh
# COPY ./dev/drupal_settings.txt /tmp/drupal_settings.txt

WORKDIR /project/drupal
RUN chown drupal:users composer.json

USER drupal
RUN composer install
RUN mkdir -p web/sites/default/files

USER root
RUN chmod 775 /project/drupal/web/sites/default/files
USER drupal
RUN mkdir -p /project/drupal/web/sites/modules/custom && mkdir -p /project/drupal/web/sites/themes/custom
EXPOSE 9000
CMD ["php-fpm"]