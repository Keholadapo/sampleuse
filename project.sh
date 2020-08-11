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
 if [ $? -ne 0 ]; then
 curl -L -o /tmp/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar >>$LOG_FILE
 Stat $? "Download MYSQL Bundle\t"
 cd /tmp
 tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
 Stat $? "Extract MYSQL Bundle\t"

 yum remove mariadb-libs -y &>>$LOG_FILE
 yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm mysql-community-common-5.7.28-1.el7.x86_64.rpm mysql-community-libs-5.7.28-1.el7.x86_64.rpm mysql-community-server-5.7.28-1.el7.x86_64.rpm -y &>>$LOG_FILE
 Stat $? "Install MYSQL Database\t"
 fi

 systemctl enable mysqld &>>$LOG_FILE
 systemctl start mysqld &>>$LOG_FILE
 Stat $? "Start MYSQL Server\t"
 sleep 20
 DEFAULT_PASSWORD=$(cat /var/log/mysqld.log | grep 'A temporary password' | awk '{print $NF}')
 echo -e "[client]\nuser=root\npassword=$DEFAULT_PASSWORD" >/root/.mysql-default 

 echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyRootPass@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/remove-plugin.sql

 echo "show databases" |mysql -uroot -ppassword &>/dev/null
 if [ $? -ne 0 ]; then
 mysql --defaults-extra-file=/root/.mysql-default --connect-expired-password </tmp/remove-plugin.sql &>>$LOG_FILE
 Stat $? "Reset MYSQL Password\t"
 fi

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
 yum list installed | grep esl-erlang &>/dev/null
 if [ $? -ne 0 ]; then
 yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y &>>$LOG_FILE
 Stat $? "Install Erlang\t\t"
 fi
 
 curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
 Stat $? "SetUp RABBITMQ Repository"

 yum install rabbitmq-server -y &>>$LOG_FILE
 Stat $? "Instal RABBITMQ Server\t"

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
  Stat $? "Install REDIS\t\t"

  systemctl enable redis &>>$LOG_FILE
  systemctl start redis &>>$LOG_FILE
  Stat $? "Start REDIS Service\t"

}

NODEJS_SETUP() {
 APP_NAME=$1
 yum install nodejs gcc-c++ -y &>>$LOG_FILE
 Stat $? "Install NODEJS\t\t\t"
 APP_USER_SETUP
  Stat $? "Setup App User\t\t\t"
  curl -s -L -o /tmp/$APP_NAME.zip "$2" &>>$LOG_FILE
  Stat $? "Download Application Archieve\t"
  mkdir -p /home/roboshop/$APP_NAME
  cd /home/roboshop/$APP_NAME
  unzip -o /tmp/$APP_NAME.zip &>>$LOG_FILE
  Stat $? "Extract Application Archieve\t"
  npm --unsafe-perm install &>>$LOG_FILE
  Stat $? "Install NODEJS Dependencies\t"

  SETUP_PERMISSIONS
  SETUP_SERVICE $APP_NAME "/bin/node $APP_NAME.js"

}

APP_USER_SETUP() {
 id $APP_USER &>/dev/null
 if [ $? -ne 0 ]; then
 useradd $APP_USER
 fi

}

SETUP_PERMISSIONS() {
 chown $APP_USER:$APP_USER /home/$APP_USER -R

}

SETUP_SERVICE() {
 echo "[Unit]
Description = m$1 Service File
After = network.target

[Service]
User=$APP_USER
WorkingDirectory=/home/$APP_USER/$1
ExecStart = $2

[Install]
WantedBy = multi-user.target" >/etc/systemd/system/$1.service

systemctl daemon-reload
systemctl enable $1 &>>$LOG_FILE
systemctl restart $1
Stat $? "Start $1 Service \t"

}


CART() {
  Head "Installing Cart Service"
  NODEJS_SETUP CART "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/5ad6ea2d-d96c-4947-be94-9e0c84fc60c1/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
  

}

CATALOGUE() {
  Head "Installing Catalogue Service"
  NODEJS_SETUP CATALOGUE "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/73bf0c1f-1ba6-49fa-ae4e-e1d6df20786f/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE

}

USER() {
  Head "Installing User Service"
  NODEJS_SETUP USER "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/713e8842-5bdd-4c10-bc8e-f0c9a80d5efa/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE

}

SHIPPING() {
  Head "Installing Shipping Service"
  yum install maven -y &>>$LOG_FILE
  Stat $? "Instal MAVEN \t\t"
  APP_USER_SETUP

  curl -s -L -o /tmp/shipping.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/1d2e4e95-b279-4545-a344-f9064f2dc89f/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
  Stat $? "Download Application Archive\t"
  mkdir -p /home/$APP_USER/shipping
  cd /home/$APP_USER/shipping
  unzip -o /tmp/shipping.zip &>>$LOG_FILE
  Stat $? "Extract Application Archive\t"
  mvn clean package &>>$LOG_FILE
  Stat $? "Install MAVEN Dependencies\t"
  mv target/*dependencies.jar shipping.jar
  SETUP_PERMISSIONS
  SETUP_SERVICE shipping "/bin/java -jar shipping.jar"

}

PAYMENT() {
  Head "Installing Payment Service"
  yum install python36 gcc python3-devel -y &>>$LOG_FILE
  Stat $? "Install Python3\t\t"
  APP_USER_SETUP
  mkdir -p /home/$APP_USER/Payment
  cd /home/$APP_USER/Payment

  curl -L -s -o /tmp/payment.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/1a920b55-9858-4b25-872b-1aeeb1ababa7/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
  Stat $? "Download Application Archive\t"

  unzip -o /tmp/payment.zip &>>$LOG_FILE
  Stat $? "Extract Application Archive\t"

  pip3 install -r requirements.txt &>>$LOG_FILE
  Stat $? "Install Python Dependencies\t"
  ID_OF_USER=$(id -u $APP_USER)
  sed -i -e "/uid/ c uid = $ID_OF_USER" -e "/gid/ c gid = $ID_OF_USER" /home/roboshop/payment/payment.ini

  SETUP_PERMISSIONS
  SETUP_SERVICE payment "/usr/local/bin/uwsgi --ini payment.ini"





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
APP_USER=roboshop

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

  