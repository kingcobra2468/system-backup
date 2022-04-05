#!/bin/bash

# Creates a labeled tarball of the specified directories (provided as unnamed args)
# and moves them to the remote machine.

start=$(date +%s.%N)
day=$(date +%d)
month=$(date +%B)
year=$(date +%Y)
date="$day.$month.$year"

backup="$date.BackUp.$BACKUP_THIS_MACHINE_NAME"
serverBackUpDir="$BACKUP_FS_DIR/$year/$month/"
if [[ -e "/tmp/$backup.tar" ]]; then
    rm "/tmp/$backup.tar"
fi

tar -C $BACKUP_PATH_TRUNCATION -czf "/tmp/$backup.tar" ${BACKUP_CLONE_DIRS[@]}
scp "/tmp/$backup.tar" $BACKUP_REMOTE_USER@$BACKUP_REMOTE_ADDRESS:$serverBackUpDir
rm "/tmp/$backup.tar"

# calculate time delta of backup
end=$(date +%s.%N)
lapse=$(echo $end-$start | bc -l )
echo "Completed: $lapse seconds"
