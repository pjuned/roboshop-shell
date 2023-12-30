#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-007049cd4bbc2dbd8
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping"
"payment" "dispatch" "web") 

for i in "${INSTANCES[@]}"
do 

echo "Instance is :  $i"
if [ $i =="mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
 then 
    INSTANCE_TYPE="t3.small"
 else
    INSTANCE_TYPE="t2.micro"
fi

aws ec2 run-instances --image-id ami-03265a0778a880afb  --instance-type t2.micro --security-group-ids sg-007049cd4bbc2dbd8

done

