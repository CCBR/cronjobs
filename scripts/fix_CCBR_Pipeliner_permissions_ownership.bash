#!/bin/bash

find /data/CCBR_Pipeliner/ \( -type d -or -type f \) \
	-user $USER \
	-not \( -group CCBR_Pipeliner -and -perm -g+rwX,a+rX  \) 
        -execdir /usr/bin/chgrp -v CCBR_Pipeliner {} + \
        -execdir /usr/bin/chmod -v g\+rwX,a\+rX {} +
