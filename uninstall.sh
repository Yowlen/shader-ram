#!/bin/bash

if [ ! -e "/opt/shader-ram/reinstall" ]
then
    # Confirm all games are shut down in order to prevent issues with
    # uninstallation.
    echo "Make sure no games are currently running and that"
    echo "Steam isn't running if you're using it,"
    read -p "then press any key to continue or CTRL-C to cancel... " -n1 -s
fi

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
sync

# Perform uninstallation of each module
for m in $shader_modules/*
do
    if [ -d $m ]
    then
        if [ -f $m/uninstall.sh ]
        then
            mn=$(echo $m | rev | cut -d '/' -f1 | rev)
            echo "Uninstalling $mn."
            chmod +x "$m/uninstall.sh"
            "$m/uninstall.sh"
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
sync
