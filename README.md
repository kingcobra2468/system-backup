# **Backup**
My backup pipeline for full and incremental backups. 

## **Architectures**
- Full Backup of specified directories into a tarball which then gets puts into
  the appropriate date directory on backup machine.
- Incremental Backup via restic.

### **Full Backup Method**
This architecture makes use of `fs_timelapse.sh` which runs on the backup machine as
a cron job and generates the appropriate year/month directories if they don't exist
yet from **$BACKUP_FS_DIR**. For example, if the year becomes 2023, and a 2023/January
directory doesn't exist, one will be created. From the client side, `system_clone.sh` will create 
tarballs and put it to the appropriate year/month.

### Incremental Backup
The `restic_backup.sh` is simply a wrapper over the backup subcommand of `restic`. 
Follow [this](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html)
on setting up a repo on the backup machine prior to running this script which assumes
that a repository has already been created.

## **Config**
This `template.backup_config` file needs to be renamed as `.backup_config`
and moved to the home directory of the user. Inside, the config is split up
into the following sections:

### **Backup Machine Config**
- **BACKUP_REMOTE_USER=** username of the backup machine
- **BACKUP_REMOTE_ADDRESS=** hostname of the backup machine

### **Restic Config**
- **BACKUP_RESTIC_EXCLUDES=** path to the restic excludes file
- **BACKUP_RESTIC_INCLUDES=** path to the restic includes file

# **FS Timelapse Config**
- **BACKUP_FS_DIR=** directory where to generate date directories

# **System Clone Config**
- **BACKUP_THIS_MACHINE_NAME=** alias under which tarballs should be named of this
   machine
- **BACKUP_PATH_TRUNCATION=** remove prefix of tarball (passthrough for `-C` arg)
- **BACKUP_CLONE_REMOTE_DIR=** root directory of which `fs_timelapse.sh` is run on
- **BACKUP_CLONE_DIRS=()** list of directories to backup

## **Setup**

### **Client**
Move or create symbolic links of the `fs_timelapse.sh` and `restic_backup.sh` scripts
into `/usr/local/bin`.

#### **Full Backup**
For the full backup, the following line can be added to the
user's crontab. Set the frequency to what is necessary.
```bash
/usr/bin/env bash -c "set -a && source $HOME/.backup_config && /usr/local/bin/system_clone.sh"
```

#### **Incremental Backup**
As root, create the restic password file inside of `/etc` with `600` permissions. Then,
add the following line to the root's crontab. Set the frequency to what is necessary. Replace
the placeolder `#1` with the path to the file and `#2` with the path to were `.backup_config`
is stored on the machine.

```bash
/usr/bin/env bash -c "set -a && source #1/.backup_config && RESTIC_PASSWORD_FILE=#2 && /usr/local/bin/restic_backup.sh"
```

### **Backup Machine**
Move or create symbolic link of the `fs_timelapse.sh` script into `/usr/local/bin`. Then,
add the following line to the user's crontab. Set the frequency to what is necessary. Replace
the placeolder #1 with the path equal to that set by BACKUP_FS_DIR.
```bash
BACKUP_FS_DIR=#1 && /usr/local/bin/fs_timelapse.sh
```
