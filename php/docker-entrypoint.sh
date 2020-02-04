#!/bin/sh
set -e
sudo chown -R drupal:nginx /var/www/html/web
sudo chmod 775 /var/www/html/web/sites/default/files
chmod u+w /var/www/html/web/sites/default


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"