#!/bin/bash
sudo -i
sudo apt-get update 
sudo apt-get install nginx -y
sudo chown -R $USER:$USER /var/www
sudo echo "Hi vivek" > /var/www/html/index.nginx-debian.html