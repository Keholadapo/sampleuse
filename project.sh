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
     echo -e "\t\t$2 - \e[1;33mSUCCESS\e[0m"
     ;;
   *)
    echo -e "\t\t$2 - \e[1;31mFAILED\e[0m"
    exit 1
    ;;
 esac
}

FRONTEND() {
  Head "Installing Frontend Service"
  yum install nginx -y &>LOG_FILE
  Stat $? "Nginx Install\t\t"
  curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/65042ce1-fdc2-4472-9aa2-3ae9b87c1ee4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
  Stat $? "Download FRONTEND Files" &>>LOG_FILE
  cd /usr/share/nginx/html
  rm -rf * 

  unzip -o /tmp/frontend.zip &>>LOG_FILE
  Stat $? "Extract FRONTEND Files\t"

  mv static/* .
  rm -rf static README.md
  mv localhost.conf /etc/nginx/nginx.conf

  systemctl enable nginx &>>$LOG_FILE
  systemctl start nginx &>>$LOG_FILE
  Stat $? "Start Nginx\t\t"

}

MONGODB() {
  Head "Installing MongoDD Service"
  echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
 yum install -y mongodb-org &>>$LOG_FILE
 Stat $? "Install MONGODB Server\t\t"
 systemctl enable mongod &>>$LOG_FILE
 systemctl start mongod &>>$LOG_FILE
 Stat $? "Start MONGODB Service\t\t"

 cd /tmp
 curl -s -L -o /tmp/mongodb.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/52feee4a-7c54-4f95-b1f5-2051a56b9d76/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
 Stat $? "Download MONGODB Schema\t\t"
 unzip -o /tmp/mongodb.zip &>>$LOG_FILE
 Stat $? "Extract MONGODB Schema\t\t"
 mongo < catalogue.js &>>$LOG_FILE
 Stat $? "Load Catalogue Schema\t\t"
 mongo < users.js &>>$LOG_FILE
 Stat $? "Load Users Schema\t\t"

}

MYSQL() {
 Head "Installing MySQL Service"
 yum list installed | grep mysql-community-server &>/dev/null
 case $? in
   0)
     true
     ;;
   *)
   curl -L -o /tmp/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar >>$LOG_FILE
 Stat $? "Download MYSQL Bundle\t"
 cd /tmp
 tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
 Stat $? "Extract MYSQL Bundle\t"

 yum remove mariadb-libs -y &>>$LOG_FILE
 yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm mysql-community-common-5.7.28-1.el7.x86_64.rpm mysql-community-libs-5.7.28-1.el7.x86_64.rpm mysql-community-server-5.7.28-1.el7.x86_64.rpm -y &>>$LOG_FILE
 Stat $? "Install MYSQL Database\t"
 ;;
esac

 systemctl enable mysqld &>>$LOG_FILE
 systemctl start mysqld &>>$LOG_FILE
 Stat $? "Start MYSQL Server\t"
 sleep 20
 DEFAULT_PASSWORD=$(cat /var/log/mysqld.log | grep 'A temporary password' | awk '{print $NF}')
 echo -e "[client]\nuser=root\npassword=$DEFAULT_PASSWORD" >/root/.mysql-default 

 echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyRootPass@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/remove-plugin.sql

 mysql --defaults-extra-file=/root/.mysql-default --connect-expired-password </tmp/remove-plugin.sql &>>$LOG_FILE
 Stat $? "Reset MYSQL Password\t"

 curl -s -L -o /tmp/mysql.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/0a5a6ec5-35c7-4939-8ace-7c274f080347/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
 Stat $? "Download MYSQL Schema\t"

 cd /tmp
 unzip -o /tmp/mysql.zip &>>$LOG_FILE
 Stat $? "Extract MYSQL Schema\t"

 mysql -uroot -ppassword <shipping.sql 
 mysql -uroot -ppassword <ratings.sql
 Stat $? "Load MYSQL Schema\t"

}

RABBITMQ() {
 Head "Installing RabbitMQ Service"
 yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y &>>$LOG_FILE
 Stat $? "Install Erlang"
 
 curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
 Stat $? "SetUp RABBITMQ Repository"

 yum install rabbitmq-server -y &>>$LOG_FILE
 Stat $? "Instal RABBITMQ Server"

 systemctl enable rabbitmq-server &>>$LOG_FILE
 systemctl start rabbitmq-server &>>$LOG_FILE
 Stat $? "Start RABBITMQ SERVICE\t"

}

REDIS() {
  Head "Installing REDIS Service"
  yum install epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG_FILE
  Stat $? "Install Yum Utils\t"
  yum-config-manager --enable remi &>>$LOG_FILE
  yum install redis -y &>>$LOG_FILE
  Stat $? "Install REDIS\t"

  systemctl enable redis &>>$LOG_FILE
  systemctl start redis &>>$LOG_FILE
  Stat $? "Start REDIS Service\t"

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

  