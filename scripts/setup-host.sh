#!/bin/bash

DB_PROD_PASSWORD="7f74srZ21"
DB_BETA_PASSWORD="7f74srZ21"

sudo apt-get update -y
sudo apt-get upgrade -y

# Install my apps
sudo apt-get install -y build-essential cmake systemd-coredump gdb vim locate git curl wget zip tree jq iftop

# Install support for 32 bit apps
sudo apt-get install -y lib32stdc++6

# Install MariaDB
sudo apt install mariadb-server mariadb-client -y
sudo systemctl status mysql

# Create database and sql users
prodQueries="CREATE DATABASE prod_arp_next;
             CREATE USER prod@localhost IDENTIFIED BY '"$DB_BETA_PASSWORD"';
             GRANT ALL PRIVILEGES ON prod_arp_next.* TO prod@localhost;"
betaQueries="CREATE DATABASE beta_arp_next;
             CREATE USER beta@localhost IDENTIFIED BY '"$DB_BETA_PASSWORD"';
             GRANT ALL PRIVILEGES ON beta_arp_next.* TO beta@localhost;"
echo "Enter mysql password for 'root'@'localhost':"
sudo mysql -u root -p -e "$prodQueries $betaQueries"

# Create users
sudo useradd --create-home prod
sudo useradd --create-home beta
echo
echo
echo * You need set the password for prod and beta users manually *
echo   - 'sudo passwd prod'
echo   - 'sudo passwd beta'
echo
echo

# Restart host
echo Restarting . . .
sudo reboot
