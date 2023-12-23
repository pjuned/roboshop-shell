
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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? "Downloading Payment App code"

cd /app &>> $LOGFILE

VALIDATE $? "moving to app dir"

unzip -o /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "Unzipping the payment code"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "Installing the dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "copying payment service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Loading payment daemon"

systemctl enable payment &>> $LOGFILE

VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "Starting payment service"