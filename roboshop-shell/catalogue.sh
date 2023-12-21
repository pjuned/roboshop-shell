#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing t $TIMESTAMP" &>>  $LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then 
        echo -e "$2 ....$R Failed $N"
    else 
        echo -e "$2 ....$G Success $N"
    fi
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR :: Please run this script with root access $N"
    exit 1 
else
    echo "you are root user"
fi

dnf module disable nodejs -y

VALIDATE $? "disabling current NodeJS" &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "enable NodeJS 18" &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "installing NodeJS 18" &>> $LOGFILE

useradd roboshop

VALIDATE $? "user roboshop created" &>> $LOGFILE

mkdir /app

VALIDATE $? "Creating app directory" &>> $LOGFILE


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip


VALIDATE $? "Downloading the Application" &>> $LOGFILE

cd /app

unzip /tmp/catalogue.zip

VALIDATE $? "Unzipping the App code" &>> $LOGFILE

npm install 

VALIDATE $? "Installing Dependencies" &>> $LOGFILE

cp /home/centos/roboshop-shell/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "copying catalouge service file"

systemctl daemon-reload

VALIDATE $? "Catalogue service loading as daemon" &>> $LOGFILE

systemctl enable catalogue

VALIDATE $? "enable catalogue service" &>> $LOGFILE

systemctl start catalogue

VALIDATE $? "Starting Catalogue" &>> $LOGFILE

cp /home/centos/roboshop-shell/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongo repo"

dnf install mongodb-org-shell -y

VALIDATE $? "Installing mongodb client"

mongo --host mongodb.devopsju.online </app/schema/catalogue.js

VALIDATE $? "Loading catalogue data into mongodb"





