#!/bin/bash
#
# concrete5 remote copy shell:
# ----------
# Version 1.0
# By Toshiaki Endo

SSH_USER="SSH_USER"
SSH_HOST="SSH_HOST"
SSH_PASS="SSH_PASS"

WHERE_TO_SAVE="/home/toshi/backup"
SAVE_FILE="lastbackup.tar.gz"
LOCAL_SAVE_TO="/Users/toshi/backup"


function sshpass() {
    SSH_CMD=$1

    expect -c "
    set timeout -1
    spawn ssh ${SSH_USER}@${SSH_HOST} ${SSH_CMD}

    expect \"${SSH_USER}@${SSH_HOST}'s password:\"
    send \"${SSH_PASS}\n\"
    interact
    "
}


function scppass() {
    local SCP_FILE=$1
    local LOCAL_DIR=$2

    expect -c "
    set timeout -1
    spawn scp ${SSH_USER}@${SSH_HOST}:${SCP_FILE} ${LOCAL_DIR}

    expect \"${SSH_USER}@${SSH_HOST}'s password:\"
    send \"${SSH_PASS}\n\"
    interact
    "
}

if [ "$1" = "-p" ] || [ "$1" = "--pass" ]; then
    scppass ${WHERE_TO_SAVE}/${SAVE_FILE} ${LOCAL_SAVE_TO}
else
    scp ${SSH_USER}@${SSH_HOST}:${WHERE_TO_SAVE}/${SAVE_FILE} ${LOCAL_SAVE_TO}
fi
