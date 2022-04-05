#!/bin/bash

# Creates a new directory for a given year/month if none currently exists
# at $BACKUP_FS_DIR. For example, if the year becomes 2023, and a 2023/January
# directory doesnt exist, one will be created.
 
if [[ ! -d "$BACKUP_FS_DIR/$(date +%Y)/$(date +%B)" ]]; 
    then
        mkdir -p "$BACKUP_FS_DIR/$(date +%Y)/$(date +%B)"
fi
