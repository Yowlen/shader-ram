#!/bin/bash

# Stop the sync service and sync shader cache to the default
# locations one last time
sudo systemctl stop ramdisk-sync.service

# Remove the final backup links for the Steam shader caches
# and restore the folders back the way they should be so that
# it's like we weren't even here.
if [ -f $shader_temp/steamlibraries2.txt ]
then
    for i in `cat $shader_temp/steamlibraries2.txt`; do
        cd %i
        rm ./shadercache
        mv ./shadercachelink ./shadercache
    done
fi

# Remove the sync service
sudo systemctl disable ramdisk-sync.service
sudo rm /lib/systemd/system/ramdisk-sync.service

# Unmount the RAM disk and clean up the folder
sudo umount /mnt/shader-ram
sudo rmdir /mnt/shader-ram

# Restore /etc/fstab
sed -n '/tmpfs  \/mnt\/shader-ram  tmpfs  rw,size=2G  0   0/!p' /etc/fstab | sudo tee /etc/fstab.new > /dev/null
sudo rm /etc/fstab
sudo mv /etc/fstab.new /etc/fstab

# Remove the shader cache files
sudo rm -R /opt/shader-ram/*
sudo rmdir /opt/shader-ram
