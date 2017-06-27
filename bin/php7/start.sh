#!/bin/bash

mkdir -p /var/log/supervisor
touch /var/log/php-www-error.log
mkdir -p /var/run/php/
mkdir -p /run/php/
chmod -R 777 /run/php/

mkdir -p /var/run/sshd
chmod 0755 /var/run/sshd

chmod -R 777 /var/log
chmod -R 777 /tmp

# start all the services
/usr/local/bin/supervisord -c /image/supervisord.conf -n
