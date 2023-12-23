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

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e  "roboshop user alreadyy exists $y skipping.. $N"
fi


useradd roboshop &>> $LOGFILE

#VALIDATE $? "user roboshop created" 

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directory" 


curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading the Application" 

cd /app &>> $LOGFILE

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping the App code"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies" 

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart service loading as daemon" 

systemctl enable cart &>> $LOGFILE

VALIDATE $? "enable catalogue service" 

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting Catalogue" 





