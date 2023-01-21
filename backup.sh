#!/bin/bash
source /etc/profile
source ./.env

echo `date +"%Y-%m-%d %H:%M:%S"` " now starting backup"
echo 'stop pleroma'
sudo systemctl stop pleroma 

echo "————————————backup to local directory——————————"
echo "1.dump database"
sudo -Hu postgres pg_dump -d $PLEROMA_DB --format=custom -f ${BACKUP_PATH}/pleroma.pgdump

echo "2.copy upload & static folder"
cp -r ${PLEROMA_PATH}/static ${BACKUP_PATH}
cp -r ${PLEROMA_PATH}/uploads ${BACKUP_PATH}

echo "3.copy config file"
cp ${PLEROMA_CONFIG_PATH} ${BACKUP_PATH}

echo "————————————upload to remote——————————"
echo "4.backup to remote"
/usr/bin/expect <<EOF
    set time 30
    spawn duplicacy backup -threads 4
    expect {
        "ID" { send "$ACCESS_KEY_ID\n"; exp_continue }
        "Secret" { send "$SECRET_ACCESS_KEY\n"; exp_continue }
        "password" { send "$PASSWORD\n" }
    }
    expect eof
EOF

echo "restart pleroma"
sudo systemctl start pleroma 
echo `date +"%Y-%m-%d %H:%M:%S"` " done!"

# 5. (optional)Keep a revision every 7 days for revisions older than 30 days 
# echo "5.prune snapshot"
# /usr/bin/expect <<EOF
#     set time 30
#     spawn duplicacy backup -threads 4
#     expect {
#         "ID" { send "$ACCESS_KEY_ID\n"; exp_continue }
#         "Secret" { send "$SECRET_ACCESS_KEY\n"; exp_continue }
#         "password" { send "$PASSWORD\n" }
#     }
#     spawn duplicacy prune -keep 7:30
#     expect {
#         "ID" { send "$ACCESS_KEY_ID\n"; exp_continue }
#         "Secret" { send "$SECRET_ACCESS_KEY\n"; exp_continue }
#         "password" { send "$PASSWORD\n" }
#     }
#     expect eof
# EOF
