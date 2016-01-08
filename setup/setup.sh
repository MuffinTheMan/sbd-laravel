#!/bin/bash

sudo apt-get update
sudo apt-get install -y apache2
DEBIAN_FRONTEND=noninteractive sudo -E apt-get -q -y install mysql-server
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo apt-get install -y php5 php-pear
sudo cp laravel-project.conf /etc/apache2/sites-available/
sudo a2dissite 000-default.conf
sudo a2ensite laravel-project
sudo /etc/init.d/apache2 reload