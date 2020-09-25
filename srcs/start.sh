#!/usr/bin/env bash

#INSTALL PACKAGE
apt-get update
apt-get install -y nginx
apt-get install -y mariadb-server
apt-get install -y php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap
apt-get install -y wget libnss3-tools
apt-get clean
service mysql start

#ACCESS
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

#WEBSITE FOLDER
echo "======================================================================="
echo "                        |CREATING FOLDER|                             "
echo "======================================================================="
mkdir -p /var/www/monsite && touch /var/www/monsite/index.php
mkdir etc/nginx/ssl
echo "<?php phpinfo(); ?>" >> /var/www/monsite/index.php

#SSL CONFIG
echo "======================================================================="
echo "                       |CONFIGURATION SSL|                             "
echo "======================================================================="
wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
mv mkcert-v1.1.2-linux-amd64 mkcert
chmod +x mkcert
mv mkcert /usr/local/bin
./usr/local/bin/mkcert -install
./usr/local/bin/mkcert monsite localhost 127.0.0.1 ::1
mv monsite+3.pem etc/nginx/ssl
mv monsite+3-key.pem etc/nginx/ssl


#NGINX CONFIG
echo "======================================================================="
echo "                      |CONFIGURATION NGINX|                             "
echo "======================================================================="
mv nginxconf /etc/nginx/sites-available/monsite
ln -s /etc/nginx/sites-available/monsite /etc/nginx/sites-enabled/monsite
rm -rf /etc/nginx/sites-enabled/default

#MYSQL CONFIG
echo "======================================================================="
echo "               			|CONFIG MY SQL|                    "
echo "======================================================================="
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password

#PHPMYADMIN CONFIG
echo "======================================================================="
echo "                     |CONFIGURATION PHPMYADMIN|                        "
echo "======================================================================="
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz
mv phpMyAdmin-4.9.5-all-languages /usr/share/phpmyadmin /usr/share/phpmyadmin
mv config.inc.php /usr/share/phpmyadmin/config.inc.php

#WORDPRESS CONFIG
echo "======================================================================="
echo "                     |CONFIGURATION WORDPRESS|                        "
echo "======================================================================="
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cd ..
mv /tmp/wordpress/ /var/www/monsite/
mv wp-config.php /var/www/monsite/wordpress

#START SERVICES
rm -rf /var/lib/apt/lists/* tmp/* /var/tmp/*
service mysql restart
service php7.3-fpm start
service nginx restart