#!/bin/bash

#The script should be updated with the correct variable values before it is used.
#Set the cron pointing to the script which triggersthe script daily to take the mysql db backup.
#This script checks the backup file age and deletes the backup file older than 5 days. 

# Variables defined for credentials and other options 
user=""
password=""
host=""
db_name=""
backup_path="" # Path for the backup file to be stored 
date=$(date +"%d-%b-%Y")

# Dump database into SQL file
mysqldump --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql

# Delete files which are older than 5 days
find $backup_path/* -mtime +5 -exec rm {} \;
