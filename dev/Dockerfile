ARG TARGET_PHP_VERSION=7.3
FROM fontanalib_php

# USER root
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# RUN mkdir project
RUN mkdir /project && mkdir /project/drupal

# RUN composer create-project drupal/recommended-project /project/drupal
COPY ./dev/composer.json /project/drupal
COPY ./dev/drupal_settings.txt /tmp/drupal_settings.txt

WORKDIR /project/drupal

RUN composer install
RUN cat /tmp/drupal_settings.txt >> /project/drupal/web/sites/default/default.settings.php
# RUN composer remove drupal/core-project-message

# RUN composer require drupal/console:~1.0 \
#   --dev \
#   --prefer-dist \
#   --optimize-autoloader

# RUN cp web/sites/default/default.settings.php web/sites/default/settings.php
# RUN mkdir /project/drupal/web/sites/default/files && \
#     mkdir /project/drupal/web/sites/default/files/private && \
#     mkdir /project/drupal/web/sites/default/files/public && \
#     mkdir /project/drupal/web/modules/custom && \
#     mkdir /project/drupal/web/themes/custom

RUN chown -hR nginx:nginx /project/drupal && chmod -R 755 /project/drupal/web/sites/default