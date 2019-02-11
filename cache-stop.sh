#!/bin/bash

# Define some variables
u=$(who | awk '{print $1}')
shader_config=/home/$u/.config/shader-ram

# Start by wrapping everything into a big ol' error catcher
# in case the RAM disk wasn't mounted.
if [ ! -f '/mnt/shader-ram/.ramdisk' ]
then
    rm -f /home/$u/steam-shader-ram.log
    echo 'Error: Shader RAM directory does not exist.' >> /home/$u/steam-shader-ram.log
    echo 'Please ensure your /etc/fstab settings are correct.' >> /home/$u/steam-shader-ram.log
else
    # All actual sync stuff has been moved to a separate script.
    /opt/shader-ram/cache-sync-to-disk.sh

    # Restore Steam library links
    for i in `cat $shader_config/steamlibraries.config`; do
        cd $i
        rm ./shadercache
        ln -s ./shadercachelink ./shadercache
    done
fi
