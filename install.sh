#!/bin/bash

# Copy our files to the installation folder
mkdir -p /opt/shader-ram
cp -fr ./* /opt/shader-ram
chmod 755 /opt/shader-ram/*.sh

# Install the systemd sync service
cp -f /opt/shader-ram/ramdisk-sync.service /lib/systemd/system/
systemctl enable ramdisk-sync.service
# And start it up to perform the initial sync so that
# it works without rebooting
systemctl start ramdisk-sync.service
