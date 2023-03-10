#!/bin/bash
source /etc/profile
source ./.env

echo `date +"%Y-%m-%d %H:%M:%S"` " now starting backup"

echo "1.stop pleroma"
sudo systemctl stop pleroma 

echo "2.dump database"
sudo -Hu postgres pg_dump -d $PLEROMA_DB --format=custom -f ${BACKUP_PATH}/pleroma.pgdump

echo "3.pack uploads & static folder"
tar -czf static.tar.gz  --absolute-names ${PLEROMA_PATH}/static 
tar -czf uploads.tar.gz --absolute-names ${PLEROMA_PATH}/uploads

echo "4.copy config file"
cp ${PLEROMA_CONFIG_PATH} ${BACKUP_PATH}

echo "5.backup to remote"
./duplicacy.sh

echo "6.restart pleroma"
sudo systemctl start pleroma 

echo `date +"%Y-%m-%d %H:%M:%S"` " done!"