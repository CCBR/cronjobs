#!/bin/bash

function usage(){
echo "Usage bash $0 <absolute/path/to/folder> <group_name>"
echo "   arg1: <absolute/path/to/folder>: Absolute path to the folder whose permissions and ownership needs fixing"
echo "   arg2: <group_name>: This is the group that should have ownership to arg1"
}

if [ "$#" != "2" ];then
	usage
	exit 1
fi

folder=$1
folder="${folder%/}/"
group=$2
groups=$(groups)

echo "user: $USER"
echo "defaultgroup: $(echo $groups|awk '{print $1}')"
echo "groups: $groups"
echo "umask: $(umask)"
echo "folder2fix: $folder"
echo "group2set: $group"
echo "starttime: $(date +%m%d%y%H%M%S)"

ingroup="N"
for g in $groups
do
	if [ "$g" == "$group" ];then
		ingroup="Y"
		break
	fi
done

if [ "$ingroup" != "N" ];then
	if [ "$group" == "CCBR_Pipeliner" ];then
		find $folder \( -type d -or -type f \) \
		-user $USER \
		-not \( -group $group -and -perm -g+rwX,a+rX  \) \
        	-execdir /usr/bin/chgrp $group {} + \
        	-execdir /usr/bin/chmod g\+rwX,a\+rX {} +
	else 
		find $folder \( -type d -or -type f \) \
		-user $USER \
		-not \( -group $group -and -perm -g+rwX \) \
        	-execdir /usr/bin/chgrp  $group {} + \
        	-execdir /usr/bin/chmod g\+rwX {} +
	fi
else
	echo "user: $USER is not a member of group: $group"

fi

echo "endtime: $(date +%m%d%y%H%M%S)"