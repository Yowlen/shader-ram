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

# Look for an existing installation and if it exists, run the
# uninstall script for it.
if [ -f /opt/shader-ram/uninstall.sh ]
then
    /opt/shader-ram/uninstall.sh
fi

# Copy our files to the installation folder
mkdir -p /opt/shader-ram
cp -f ./* /opt/shader-ram >> /dev/null
chmod 755 /opt/shader-ram/*.sh

# Perform installation of each module
for m in $script_dir/modules/*
do
    if [ -d $m ]
    then
        chmod +x $m/install.sh
        $m/install.sh
    fi
done

# Install the systemd sync service
cp -f /opt/shader-ram/ramdisk-sync.service /lib/systemd/system/
systemctl enable ramdisk-sync.service
# And start it up to perform the initial sync so that
# it works without rebooting
systemctl start ramdisk-sync.service

rm $script_dir/.variables
