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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disabling current NodeJS" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enable NodeJS 18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing NodeJS 18" 

useradd roboshop &>> $LOGFILE

VALIDATE $? "user roboshop created" 

mkdir /app &>> $LOGFILE

VALIDATE $? "Creating app directory" 


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading the Application" 

cd /app &>> $LOGFILE

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping the App code"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

cp /home/centos/roboshop-shell/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalouge service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Catalogue service loading as daemon" 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "enable catalogue service" 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting Catalogue" 

cp /home/centos/roboshop-shell/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo&>> $LOGFILE

VALIDATE $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host mongodb.devopsju.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalogue data into mongodb"





