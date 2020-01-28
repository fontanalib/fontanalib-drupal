#!/bin/sh
set -e
chown -R drupal:nginx /var/www/html/web


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"