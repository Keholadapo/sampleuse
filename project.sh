#!/bin/bash

yum install nginx -y
curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/65042ce1-fdc2-4472-9aa2-3ae9b87c1ee4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv static/* .
rm -rf static README.md
mv localhost.conf /etc/nginx/nginx.conf

systemctl enable nginx
systemctl start nginx