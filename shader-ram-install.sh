#!/bin/bash

# Copy our files to the installation folder
sudo mkdir /opt/shader-ram
sudo cp ./* /opt/shader-ram
sudo chmod 755 /opt/shader-ram/*.sh

# Modify /etc/fstab for the RAM disk
echo "tmpfs  /mnt/shader-ram  tmpfs  rw,size=2G  0   0" | sudo tee -a /etc/fstab > /dev/null

# Create the RAM disk now to work without rebooting
sudo mkdir /mnt/shader-ram
sudo mount -t tmpfs -o size=2G tmpfs /mnt/shader-ram

# Install the systemd sync service
sudo cp /opt/shader-ram/ramdisk-sync.service /lib/systemd/system/
sudo systemctl enable ramdisk-sync.service
# And start it up to perform the initial sync so that
# it works without rebooting
sudo systemctl start ramdisk-sync.service
