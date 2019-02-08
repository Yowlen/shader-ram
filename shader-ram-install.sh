#!/bin/bash

# Copy our files to the installation folder
sudo mkdir /opt/shader-ram
sudo cp ./* /opt/shader-ram
sudo chmod 755 /opt/shader-ram/*.sh

# Install the systemd sync service
sudo cp /opt/shader-ram/ramdisk-sync.service /lib/systemd/system/
sudo systemctl enable ramdisk-sync.service
# And start it up to perform the initial sync so that
# it works without rebooting
sudo systemctl start ramdisk-sync.service
