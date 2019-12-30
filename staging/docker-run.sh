#!/bin/bash
/usr/local/bin/docker-entrypoint.sh

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

# echo "will start mysql";
# service mysql start
# echo "mysql status below";
# service mysql status

echo "will start nginx";
service nginx start
echo "nginx status below";
service nginx status