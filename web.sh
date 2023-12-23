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
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ....$R Failed $N"
        exit 1
        
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

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOGFILE

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "Removing nginx default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VALIDATE $? "Downloading Web APP code"

cd /usr/share/nginx/html &>> $LOGFILE

VALIDATE $? "change directory to html"

unzip -o /tmp/web.zip &>> $LOGFILE

VALIDATE $? "Unzipped web.zip"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

VALIDATE $? "copying roboshop.conf reverse proxy"

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "Restarting nginx"

