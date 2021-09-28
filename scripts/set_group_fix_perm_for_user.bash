#!/bin/bash
d=$(date +"%m%d%y")

# /data/CCBR
log="/data/CCBR/cronjobs/logs/${USER}.${d}.log"
bash /data/CCBR_Pipeliner/cronjobs/scripts/set_group_fix_perm_for_folder.bash /data/CCBR/ CCBR >> $log 2>>$log
gzip -f -n $log

# /data/CCBR
log="/data/CCBR_Pipeliner/cronjobs/logs/${USER}.${d}.log"
bash /data/CCBR_Pipeliner/cronjobs/scripts/set_group_fix_perm_for_folder.bash /data/CCBR_Pipeliner/ CCBR_Pipeliner >> $log 2>>$log
gzip -f -n $log

