#!/bin/bash

# Start by wrapping everything into a big ol' error catcher
# in case the RAM disk wasn't mounted.
u=$(who | awk '{print $1}')
if [ ! -d '/mnt/shader-ram' ]
then
    rm -f /home/$u/steam-shader-ram.log
    echo 'Error: Shader RAM directory does not exist.' >> /home/$u/steam-shader-ram.log
    echo 'Please ensure your /etc/fstab settings are correct.' >> /home/$u/steam-shader-ram.log
else
    shader_temp=/mnt/shader-ram/.shader-config

    # Populate the global nVidia shader cache
    # Comment out these lines if you don't use an nVidia GPU.
    rsync -ar /home/$u/.nv/ /mnt/shader-ram/.nv/
    export __GL_SHADER_DISK_CACHE_PATH='/mnt/shader-ram/.nv'
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

    # Begin Steam library search
    # If you don't use Steam, you'll wanna either comment out
    # or remove everything from here on except for the final
    # "fi" line and the blank line at the end.
    #
    # Set temp dir
    mkdir /mnt/shader-ram/.shader-config

    # Find potential search points
    cat /proc/mounts | grep 'ext4\|xfs\|btrfs' | grep -v ' / ' | cut -d ' ' -f2 | sed '/home/d' > $shader_temp/partitions.txt
    echo /home/$u >> $shader_temp/partitions.txt

    # Now to do the actual search for all Steam libraries
    # and output them all to a file.
    echo $(find $(sed ':a;N;$!ba;s/\n/ \0/g' $shader_temp/partitions.txt) -mindepth 3 -type d -name "*steamapps" ; ) >> $shader_temp/steamlibraries.txt
    # Then separate with new lines.
    tr ' \/' '\n\/' < $shader_temp/steamlibraries.txt > $shader_temp/steamlibraries2.txt

    # Now to take each Steam library and...
    for i in `cat $shader_temp/steamlibraries2.txt`; do
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
fi
