#!/bin/bash

# Define the stuff from the variables file
u=$(who | awk '{print $1}')
script_dir=$(dirname "$0")

sed '/^\s*$/d' $script_dir/variables > $script_dir/.variables
while read line
do
    if [ $(echo $line | cut -c1) != "#" ]
    then
        line=$(echo "${line/\$u/$u}")
        declare $line
    fi
done < $script_dir/.variables
rm $script_dir/.variables

# Start by wrapping everything into a big ol' error catcher
# in case the ramdisk wasn't mounted.
if [ -f $shader_test ]
then
    # Find and execute each module
    for m in $shader_modules/*
    do
        if [ -d $m ]
        then
            chmod +x $m/*.sh
            $m/shutdown.sh
        fi
    done

    # Unmount the ramdisk
    umount $shader_ram && rmdir $shader_ram
fi
