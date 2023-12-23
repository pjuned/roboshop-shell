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

dnf install nginx -y 

VALIDATE $? "installing nginx"

systemctl enable nginx

VALIDATE $? "Enabled nginx"

systemctl start nginx

VALIDATE $? "Started nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "removing default content of nginx"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading Web  content"

cd /usr/share/nginx/html

VALIDATE $? "Moving to nginx HTML Dir"

unzip /tmp/web.zip

VALIDATE $? "Unzipping the Web App code"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

VALIDATE $? "configured reverse proxy to nginx"

systemctl restart nginx

VALIDATE $? "Restarted nginx"

