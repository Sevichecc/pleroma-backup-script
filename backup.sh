#!/bin/bash
source /etc/profile
source ./.env

echo `date +"%Y-%m-%d %H:%M:%S"` " now starting backup"
echo "————————————backup to local directory——————————"
echo "1.dump database"
sudo -Hu postgres pg_dump -d $PLEROMA_DB --format=custom -f ${BACKUP_PATH}/pleroma.pgdump

echo "2.copy upload & static folder"
cp -r ${PLEROMA_PATH}/static ${BACKUP_PATH}
cp -r ${PLEROMA_PATH}/uploads ${BACKUP_PATH}

echo "3.copy config file"
cp ${PLEROMA_CONFIG_PATH} ${BACKUP_PATH}

echo `date +"%Y-%m-%d %H:%M:%S"` " done!"
