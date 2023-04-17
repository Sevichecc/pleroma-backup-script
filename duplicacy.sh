#!/usr/bin/expect
set ACCESS_KEY_ID "YOUR_ACCESS_KEY_ID"
set SECRET_ACCESS_KEY "YOUR_SECRET_ACCESS_KEY"
set PASSWORD "YOUR_PASSWORD"

set timeout -1

# Function to handle authentication
proc authenticate {} {
    global ACCESS_KEY_ID SECRET_ACCESS_KEY PASSWORD

    expect "ID"
    send "$ACCESS_KEY_ID\r"

    expect "Secret"
    send "$SECRET_ACCESS_KEY\r"

    expect "password"
    send "$PASSWORD\r"
}

# Run duplicacy backup command
spawn duplicacy backup -threads 4
authenticate
expect "completed"

# Run duplicacy prune command (optional)
spawn duplicacy prune -keep 7:30
authenticate

# Allow user interaction after script completion
interact