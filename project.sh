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

case $1 in
 frontend)
  frontend
  ;;
 mongodb)
  mongodb
  ;;
 mysql)
  mysql
  ;;
 rabbitmq)
  rabbitmq
  ;;
 redis)
  redis
  ;;
 cart)
  cart
  ;;
 catalogue)
  catalogue
  ;;
 user)
  user
  ;;
 shipping)
  shipping
  ;;
 payment)
  payment
  ;;
 all)
  frontend
  mongodb
  mysql
  rabbitmq
  redis
  cart
  catalogue
  user
  Shipping
  payment
  ;;
esac

  