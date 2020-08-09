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
 echo -e "Usage: \t\t $0 component"
 echo -e "Components: \t FRONTEND MYSQL RABBITMQ REDIS CART CATALOGUE USER SHIPPING PAYMENT"
 echo -e "For ALL \tcomponents : ALL"
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
esac

  