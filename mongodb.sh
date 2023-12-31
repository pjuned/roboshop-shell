#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/monogodb.log"

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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongodb"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing Mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting mongodb service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Editing remote access to mongodb"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restart Mongodb"