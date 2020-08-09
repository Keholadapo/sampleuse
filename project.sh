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

FRONTEND() {
  echo "Installing Frontend Service"
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
 echo -e "Usage: \t\t\t\t \e[36m$0 component\e[0m"
 echo -e "Components: \t\t\t \e[36mFRONTEND MYSQL RABBITMQ REDIS CART CATALOGUE USER SHIPPING PAYMENTe[0m"
 echo -e "For ALL components : \t \e[36mALLe[0m"
 exit 1
}

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

  