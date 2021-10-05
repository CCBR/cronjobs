#!/bin/bash
# Author: Vishal Koparde
# 2021
# This script take 2 arguments
# 1. folder to apply the script on
# 2. group to set the group to
# The script crawls through the give folder (argument1) and
# a. changes the "group" of all files and folders to the user provided group (argument2) recursively
# b. grants the "group" read+write permission to all files and folders, recursively
# c. if the "group" is CCBR_Pipeliner, then also grants all users read permissions, recursively
#

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


# source whats needed
if [ -f ~/.bashrc ]; then source ~/.bashrc ;fi
if [ -f ~/.bash_profile ]; then source ~/.bash_profile ;fi

echo "user: $USER"
echo "defaultgroup: $(echo $groups|awk '{print $1}')"
echo "groups: $groups"
echo "umask: $(umask)"
echo "mkdir: $(type mkdir)"
echo "folder2fix: $folder"
echo "group2set: $group"
echo "starttime: $(date +%m%d%y%H%M%S)"

if [ -f ~/.bashrc ];then
	echo "#####################################################"
	echo ".bashrc"
	echo "#####################################################"
	cat ~/.bashrc
	echo "#####################################################"
fi
if [ -f ~/.bash_profile ];then
	echo "#####################################################"
	echo ".bash_profile"
	echo "#####################################################"
	cat ~/.bash_profile
	echo "#####################################################"
fi

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
        	-execdir /usr/bin/chmod g\+rwX,a\+rX,\+t {} +
	else 
		find $folder \( -type d -or -type f \) \
		-user $USER \
		-not \( -group $group -and -perm -g+rwX \) \
        	-execdir /usr/bin/chgrp  $group {} + \
        	-execdir /usr/bin/chmod g\+rwX,\+t {} +
	fi
else
	echo "user: $USER is not a member of group: $group"

fi

echo "endtime: $(date +%m%d%y%H%M%S)"
