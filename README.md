ft_server
projet ft_server école 19
Projet de découverte à l'administration système et introduction à Docker.

Comment faire ft_server

Le but est de créer une image docker tournant sous debian-buster. J'ai utilisé debian-buster:slim car il est plus léger, mais ne change en rien les fonctionnalités.

Il faudra installer NGINX et modifier le fichier de configuration pour faire fonctionner php, mysql, wordpress et sécuriser le serveur.

- Toute la documentation NGINX est disponible sur le site officiel : https://nginx.org/en/
- Toute la documentation Docker est disponible sur : https://docs.docker.com/
- Petite introduction sur Docker très rapide en quelques vidéos : https://www.youtube.com/watch?v=SXB6KJ4u5vg la série de vidéo est simple et claire et permet d'un peu comprendre ce qu'on peut faire avec cet outil.
- Une fois l'image lancée il faut installer une pile logiciel LEMP : https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04
- Automatisation de my_sql_secure_installation (je ne l'ai pas fait): https://opensharing.fr/mysql-secure-installation-automatisation-fr
- Sécuriser le serveur avec mkcert : https://computingforgeeks.com/how-to-create-locally-trusted-ssl-certificates-on-linux-and-macos-with-mkcert/
- Sécuriser le serveur avec openssl : https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-18-04
- Installer Wordpress : https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-nginx-on-ubuntu-14-04

Commandes pour créer l'image : "Docker build -t NOMDELIMAGEVOULU ."

Commandes pour lancer l'image :
De manière interactive : docker run -it -p 80:80 -p 443:443 NOMDELIMAGEALANCER
Sans image pour run un container pas encore créé : docker run --name NOMVOULU -it -p 80:80 -p 443:443 debian-buster:slim
en fond : docker run -d -p 80:80 -p 443:443 NOMDELIMAGEALANCER

Commande pour lancer les différents modules :
service nginx start
service mysql start
service php7.3-fpm start

remplacer start par reload ou restart selon le cas.