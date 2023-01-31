#!/usr/bin/expect 
set ACCESS_KEY_ID "YOUR_ACCESS_KEY_ID"
set SECRET_ACCESS_KEY "YOUR_SECRET_ACCESS_KEY"
set PASSWORD "YOUR_PASSWORD"

set timeout -1
spawn duplicacy backup -threads 4

expect "ID"
send "$ACCESS_KEY_ID\r"

expect "Secret"
send "$SECRET_ACCESS_KEY\r"

expect "password"
send "$PASSWORD\r"

##### (optional) Keep a revision every 7 days for revisions older than 30 days 
# expect "completed"
# spawn duplicacy prune -keep 7:30

# expect "ID"
# send "$ACCESS_KEY_ID\r"

# expect "Secret"
# send "$SECRET_ACCESS_KEY\r"

# expect "password"
# send "$PASSWORD\r"

expect eof

EOF