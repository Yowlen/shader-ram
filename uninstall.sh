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

# Stop the sync service and sync shader cache to the default
# locations one last time
systemctl stop ramdisk-sync.service

# Perform uninstallation of each module
for m in $shader_modules/*
do
    if [ -d $m ]
    then
        if [ -f $m/uninstall.sh ]
        then
            chmod +x $m/uninstall.sh
            $m/uninstall.sh
        fi
    fi
done

# Remove the sync service
systemctl disable ramdisk-sync.service
rm /lib/systemd/system/ramdisk-sync.service

# Remove the shader cache files
rm -rf $shader_modules
rm -rf /etc/shader-ram
rm -rf /opt/shader-ram
