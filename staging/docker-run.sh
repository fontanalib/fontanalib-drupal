#!/bin/bash
# /usr/local/bin/docker-entrypoint.sh
# composer install --no-dev

# chown -hR nginx:nginx /var/www/html && chmod -R 755 /var/www/html/web/sites/default
echo "Starting application and webserver...";

echo "php -v";
php -v
echo "nginx -v";
nginx -v
echo "mariadb -V";
mariadb -V

# echo "preparing nginx default_site.conf file"
# sed -i "s/DOMAIN/$DOMAIN/" /etc/nginx/default_site.conf

echo "will start php";
service php7.3-fpm start
echo "php status below";
service php7.3-fpm status

echo "will start nginx";
service nginx start
echo "nginx status below";
service nginx status 

echo "mariadb status below";
service mysql status