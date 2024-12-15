#!/bin/bash
echo "${server_text}" > /var/www/html/index.html
yum install -y httpd
service httpd start
chkconfig httpd on
