#!/bin/bash

instanceid=""
Jsonfile_path="/tmp/instance-details.json"
db_user=""
db_password=""
db_host=""
databasename=""
tablename=""

# Collects the Instances details and stores in Jsonfile_path
aws ec2 describe-instances --instance-ids $instanceid --profile prafullrean --region us-west-2 --query 'Reservations[].Instances[].[{Instances:{InstanceType:InstanceType,VpcId:VpcId,InstanceId:InstanceId,ImageId:ImageId},NetworkInterfaceId:NetworkInterfaces[*].{NetworkInterfaceId:NetworkInterfaceId,PrivateIP:PrivateIpAddress},BlockDeviceMappings:BlockDeviceMappings[*].{VolumeId:Ebs.VolumeId,DeviceName:DeviceName},Tags:Tags[*]}]' > $Jsonfile_path

# Inserts the instance details for Jsonfile_path to mysql database.
BlockDevice=`cat $Jsonfile_path | jq '.[0] | .[0] | .BlockDeviceMappings'`
Tags=`cat $Jsonfile_path | jq '.[0] | .[0] | .Tags'`
NetworkInterface=`cat $Jsonfile_path | jq '.[0] | .[0] | .NetworkInterfaceId'`
instances=`cat $Jsonfile_path | jq '.[0] | .[0] | .Instances'`
echo "INSERT INTO $tablename (BlockDeviceMappings,Tags,NetworkInterfaceId,Instances) VALUES ('$BlockDevice', '$Tags', '$NetworkInterface','$instances');" | mysql -u$db_user -p$db_password -h $db_host $databasename;

