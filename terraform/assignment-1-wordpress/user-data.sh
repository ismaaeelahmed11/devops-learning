#!/bin/bash
yum update -y
amazon-linux-extras install php8.2 -y
yum install -y httpd mariadb-server php php-mysqlnd
systemctl start httpd
systemctl enable httpd
cd /var/www/html
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz
chown -R apache:apache /var/www/html