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
    # Back up the nVidia cache
    # Comment out these lines if you don't use an nVidia GPU.
    rsync -ar /mnt/shader-ram/.nv/ /home/$u/.nv/
    chown -Rf $u /home/$u/.nv/

    # Now for the Steam libraries.
    # If you don't use Steam, you'll wanna either comment out
    # or remove everything from here on except for the final
    # "fi" and blank lines at the end.

    # Check to make sure our Steam config file exists, and if not,
    # create it.
    if [ ! -f $shader_config/steamlibraries.config ]
    then
        /opt/shader-ram/cache-config.sh
    fi

    # Now back up each Steam library
    for i in `cat $shader_config/steamlibraries.config`; do
        cd $i
        d=$(echo $i | cut -d '/' -f2-3 | tr '/' '-')
        rsync -ar /mnt/shader-ram/steam-shader-$d/ ./shadercachelink/
    done
fi
