#!/bin/bash

# Copy our files to the installation folder
mkdir /opt/shader-ram
cp ./* /opt/shader-ram
chmod 755 /opt/shader-ram/*.sh

# Install the systemd sync service
cp /opt/shader-ram/ramdisk-sync.service /lib/systemd/system/
systemctl enable ramdisk-sync.service
# And start it up to perform the initial sync so that
# it works without rebooting
systemctl start ramdisk-sync.service
