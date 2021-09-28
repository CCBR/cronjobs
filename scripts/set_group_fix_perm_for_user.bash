#!/bin/bash
# Author: Vishal Koparde
# 2021
# This "wrapper" script is intended to be added as a cronjob on a per user basis
# It will crawl through all user owned files and folders listed below and make the appropriate group/permission fixes
#
#| Folder                 | Fixes                                                        | Log Location                         |
#| ---------------------- | ------------------------------------------------------------ | ------------------------------------ |
#| `/data/CCBR`           | set group to CCBR, grant group read/write                    | `/data/CCBR/cronjobs/logs`           |
#| `/data/CCBR_Pipeliner` | set group to CCBR_Pipeliner, grant group read/write, grant all users read | `/data/CCBR_Pipeliner/cronjobs/logs` |
#

d=$(date +"%m%d%y")

# /data/CCBR
log="/data/CCBR/cronjobs/logs/${USER}.${d}.log"
bash /data/CCBR_Pipeliner/cronjobs/scripts/set_group_fix_perm_for_folder.bash /data/CCBR/ CCBR >> $log 2>>$log
gzip -f -n $log

# /data/CCBR
log="/data/CCBR_Pipeliner/cronjobs/logs/${USER}.${d}.log"
bash /data/CCBR_Pipeliner/cronjobs/scripts/set_group_fix_perm_for_folder.bash /data/CCBR_Pipeliner/ CCBR_Pipeliner >> $log 2>>$log
gzip -f -n $log

