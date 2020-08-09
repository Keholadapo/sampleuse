#!/bin/bash

#Frontend
#Mongodb
#Redis
#Mysql
#Rabbitmq
#Cart
#Catalogue
#Shipping
#Payment
#User
#All

Head() {
  echo -e "\t\t\e[1;4;36m$1\e[0m"

}

Stat() {
 case $1 in
   0) 
     echo "$2 - SUCCESS"
     ;;
   *)
    echo "$2 - FAILED"
    exit 1
    ;;
 esac
}

FRONTEND() {
  Head "Installing Frontend Service"
  yum install nginx -y &>LOG_FILE
  Stat $? "Nginx Install"
  curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/65042ce1-fdc2-4472-9aa2-3ae9b87c1ee4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
  Stat $? "Download FRONTEND Files" &>>LOG_FILE
  cd /usr/share/nginx/html
  rm -rf * 

  unzip /tmp/frontend.zip &>>LOG_FILE
  Stat $? "Extract FRONTEND Files"

  mv static/* .
  rm -rf static README.md
  mv localhost.conf /etc/nginx/nginx.conf

  systemctl enable nginx &>>$LOG_FILE
  systemctl start nginx &>>$LOG_FILE
  Stat $? "Start Nginx"

}

MONGODB() {
  Head "Installing MongoDD Service"
}

MYSQL() {
  Head "Installing MySQL Service"
}

RABBITMQ() {
  Head "Installing RabbitMQ Service"
}

REDIS() {
  Head "Installing REDIS Service"
}

CART() {
  Head "Installing Cart Service"
}

CATALOGUE() {
  Head "Installing Catalogue Service"
}

USER() {
  Head "Installing User Service"
}

SHIPPING() {
  Head "Installing Shipping Service"
}

PAYMENT() {
  Head "Installing Payment Service"
}

USAGE() {
 echo -e "Usage: \t\t\t \e[36m$0 component\e[0m"
 echo -e "Components: \t\t \e[36mFRONTEND MYSQL RABBITMQ REDIS CART CATALOGUE USER SHIPPING PAYMENT\e[0m"
 echo -e "For ALL components : \t \e[36mALL\e[0m"
 exit 1
}

## Main Program
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

## Check root user or not
ID_USER=$(id -u)
case $ID_USER in
  0) true ;;
  *)
    echo "Script should be run as script user, or sudo"
    USAGE
    ;;
esac
case $1 in
    FRONTEND)
  FRONTEND
  ;;
 MONGODB)
  MONGODB
  ;;
 MYSQL)
  MYSQL
  ;;
 RABBITMQ)
  RABBITMQ
  ;;
 REDIS)
  REDIS
  ;;
 CART)
  CART
  ;;
 CATALOGUE)
  CATALOGUE
  ;;
 USER)
  USER
  ;;
 SHIPPING)
  SHIPPING
  ;;
 PAYMENT)
  PAYMENT
  ;;
 ALL)
  FRONTEND
  MONGODB
  MYSQL
  RABBITMQ
  REDIS
  CART
  CATALOGUE
  USER
  SHIPPING
  PAYMENT
  ;;
 *)
  USAGE
  ;;
esac

  