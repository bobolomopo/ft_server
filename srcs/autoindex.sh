#!bin/bash

if [ -z $1 ]
then
	echo "Veuillez rentrer ON ou OFF en paramètre"
elif [ $1 = "ON" ]
then
	sed -i "s/autoindex off/autoindex on/g" etc/nginx/sites-available/monsite
	service nginx restart
elif [ $1 = "OFF" ]
then
	sed -i "s/autoindex on/autoindex off/g" etc/nginx/sites-available/monsite
	service nginx restart
else
	echo "Veuillez rentrer ON ou OFF en paramètre"
fi