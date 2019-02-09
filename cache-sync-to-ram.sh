#!/bin/bash

# Define some variables
u=$(who | awk '{print $1}')
shader_config=/home/$u/.config/shader-ram

# First, let's check to see if the RAM disk is created,
# and if not, make it.
if [ ! -f '/mnt/shader-ram/.ramdisk' ]
then
    mkdir /mnt/shader-ram
    mount -t tmpfs -o size=2G tmpfs /mnt/shader-ram
    touch /mnt/shader-ram/.ramdisk
fi

# Next, let's set up the config files, including Steam library detection.
/opt/shader-ram/cache-config.sh

# Now to take each Steam library and...
for i in `cat $shader_config/steamlibraries.config`; do
    cd $i

    # 1. Check to see if it's already linked, and if not, make a backup
    #    on the hard drive (for first-time setup of new libraries)
    if [ ! -L ./shadercache ]
    then
        rsync -ar ./shadercache/ ./shadercachelink/
        rm -r ./shadercache
        ln -s ./shadercachelink ./shadercache
    fi

    # 2. Sync the backup to the RAM disk, then change the link
    #    to the RAM disk
    d=$(echo $i | cut -d '/' -f2-3 | tr '/' '-')
    rsync -ar ./shadercachelink/ /mnt/shader-ram/steam-shader-$d/
    rm ./shadercache
    ln -s /mnt/shader-ram/steam-shader-$d ./shadercache
done

# Populate the global nVidia shader cache
# Comment out these lines if you don't use an nVidia GPU.
rsync -ar /home/$u/.nv/ /mnt/shader-ram/.nv/
export __GL_SHADER_DISK_CACHE_PATH='/mnt/shader-ram/.nv'
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
