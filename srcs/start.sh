#!/usr/bin/env bash

ROOT_PASSWORD=password
#INSTALL PACKAGE
apt-get update
apt-get upgrade
apt-get install -y nginx
apt-get install -y mariadb-server
apt-get install -y php php-fpm php-mysql php-mbstring php-zip php-gd
apt-get install -y wget
apt-get clean
rm -rf /var/lib/apt/lists/* tmp/* /var/tmp/*

#NGINX CONFIG
mkdir -p /var/www/localhost
mv nginxconf /etc/nginx/sites-available/localhost
mv info.php /var/www/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

#SSL CONFIG
echo "======================================================================="
echo "                       |CONFIGURATION SSL|                             "
echo "======================================================================="
mkdir mkcert
wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64
mv mkcert-v1.1.2-linux-amd64 mkcert
chmod +x mkcert
cp mkcert /usr/local/bin
cd mkcert
mkcert -install
mkcert localhost localhost.com www.localhost
cd ..

#MYSQL CONFIG
service mysql start
echo "======================================================================="
echo "               |SECURE INSTALLATION MYSQL DATABASE|                    "
echo "======================================================================="
echo "root password set as '$ROOT_PASSWORD'"
myql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${ROOT_PASSWORD}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

#PHPMYADMIN CONFIG
echo "======================================================================="
echo "                     |CONFIGURATION PHPMYADMIN|                        "
echo "======================================================================="
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
tar xvf phpMyAdmin-4.9.5-all-languages.tar.gz
mv phpMyAdmin-4.9.5-all-languages /usr/share/phpmyadmin /usr/share/phpmyadmin
chown -R www-data:www-data /var/lib/phpmyadmin
cp config.inc.php /usr/share/phpmyadmin/config.inc.php


#START SERVICES
service nginx start
service php7.3-fpm start