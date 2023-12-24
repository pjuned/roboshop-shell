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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading Erlang Scrpt"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading Rabbitmq script"

dnf install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Installing Rabbitmq server"

systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? "Enabling rabbitmq "

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e  "roboshop user alreadyy exists $y skipping.. $N"
fi


VALIDATE $? "User added"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? "Setting permissions"