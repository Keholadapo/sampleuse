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

FRONTEND() {
  Head "Installing Frontend Service"
  yum install nginx -y &>LOG_FILE
  case $? in
   0) 
     echo "Nginx Install - SUCCESS"
     ;;
   *)
    echo "Nginx Install - FAILED"
    exit 1
    ;;
 esac
}

MONGODB() {
  echo "Installing MongoDD Service"
}

MYSQL() {
  echo "Installing MySQL Service"
}

RABBITMQ() {
  echo "Installing RabbitMQ Service"
}

REDIS() {
  echo "Installing REDIS Service"
}

CART() {
  echo "Installing Cart Service"
}

CATALOGUE() {
  echo "Installing Catalogue Service"
}

USER() {
  echo "Installing User Service"
}

SHIPPING() {
  echo "Installing Shipping Service"
}

PAYMENT() {
  echo "Installing Payment Service"
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

  