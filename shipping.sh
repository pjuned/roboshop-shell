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
 
 dnf install maven -y

 VALIDATE $? "Installing maven"

 id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e  "roboshop user alreadyy exists $y skipping.. $N"
fi


mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directory" 

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VALIDATE $? "Downloading Shipping code"

cd /app &>> $LOGFILE

VALIDATE $? "moving to app dir"

unzip -o /tmp/shipping.zip &>> $LOGFILE

VALIDATE $? "Unzipping the code"

mvn clean package &>> $LOGFILE

VALIDATE $? "Installing Dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VALIDATE $? "Renaming JAR file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VALIDATE $? "Copying Shipping service "

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon reload"

systemctl enable shipping &>> $LOGFILE

VALIDATE $? "Enabling Shipping service"

systemctl start shipping

VALIDATE $? "Starting Shipping service"

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "Installing mysql client"

mysql -h mysql.devopsju.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE

VALIDATE $? "Loading Shipping Data"

systemctl restart shipping &>> $LOGFILE

VALIDATE $? "Restarted shipping service"



