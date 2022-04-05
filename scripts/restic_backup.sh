#!/bin/bash

# Wrapper for backups using Restic.

restic -r sftp://$BACKUP_REMOTE_USER@$BACKUP_REMOTE_ADDRESS/$BACKUP_RESTIC_REPO_PATH backup \
  --exclude-file=$BACKUP_RESTIC_EXCLUDES \
  --files-from=$BACKUP_RESTIC_INCLUDES
