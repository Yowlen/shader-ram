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

    # Back up the nVidia cache
    # Comment out this line if you don't use an nVidia GPU.
    rsync -ar /mnt/shader-ram/.nv/ /home/$u/.nv/
    chown -Rf $u /home/$u/.nv/

    # Now for the Steam libraries.
    # If you don't use Steam, you'll wanna either comment out
    # or remove everything from here on except for the final
    # "fi" and blank lines at the end.

    if [ ! -f $shader_temp/steamlibraries2.txt ]
    then
        # Begin Steam library search
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
    fi

    # Now back up each Steam library
    for i in `cat $shader_temp/steamlibraries2.txt`; do
        cd $i
        d=$(echo $i | cut -d '/' -f2-3 | tr '/' '-')
        rsync -ar /mnt/shader-ram/steam-shader-$d/ ./shadercachelink/
        rm ./shadercache
        ln -s ./shadercachelink ./shadercache
    done
fi
