#!/bin/bash
set -e
source /etc/profile 
source ./.env

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
echo "(${TIMESTAMP}) now starting backup"

echo "0.Deleting backups older than 7 days"
find ${BACKUP_PATH} -type f -name '*.pgdump' -mtime +7 -exec rm {} \;

echo "1.Stopping pleroma"
sudo systemctl stop pleroma  

echo "2.Dumping database"  
sudo -Hu postgres pg_dump -d $PLEROMA_DB --format=custom -f ${BACKUP_PATH}/pleroma_${TIMESTAMP}.pgdump

echo "3.Packing uploads & static folder"
tar -czf ${BACKUP_PATH}/static_${TIMESTAMP}.tar.gz -C ${PLEROMA_PATH} static  
tar -czf ${BACKUP_PATH}/uploads_${TIMESTAMP}.tar.gz -C ${PLEROMA_PATH} uploads

echo "4.Copying config file"
cp ${PLEROMA_CONFIG_PATH} ${BACKUP_PATH}  

echo "5.Backuping to remote"
./duplicacy.sh   

echo "6.Restarting pleroma"
sudo systemctl start pleroma   

echo "(${TIMESTAMP}) done!"