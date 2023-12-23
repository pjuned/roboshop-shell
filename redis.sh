#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &$LOGFILE

echo "Script started executing t $TIMESTAMP" 

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y 

VALIDATE $? "installing Remi release repo fro redis" 

dnf module enable redis:remi-6.2 -y

VALIDATE $? "redis version 6 enabled"

dnf install redis -y 

VALIDATE $? "installing redis 6"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf 

VALIDATE $? "Allowing remote connections"

systemctl enable redis 

VALIDATE $? "enable redis"

systemctl start redis 

VALIDATE $? "Started redis"