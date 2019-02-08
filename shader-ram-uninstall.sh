#!/bin/bash

# Stop the sync service and sync shader cache to the default
# locations one last time
systemctl stop ramdisk-sync.service

# Remove the final backup links for the Steam shader caches
# and restore the folders back the way they should be so that
# it's like we weren't even here.
if [ -f $shader_temp/steamlibraries.config ]
then
    for i in `cat $shader_temp/steamlibraries.config`; do
        cd %i
        rm ./shadercache
        mv ./shadercachelink ./shadercache
    done
fi

# Remove the sync service
systemctl disable ramdisk-sync.service
rm /lib/systemd/system/ramdisk-sync.service

# Unmount the RAM disk and clean up the folder
umount /mnt/shader-ram
rmdir /mnt/shader-ram

# Remove the shader cache files
rm -R /opt/shader-ram/*
rmdir /opt/shader-ram
