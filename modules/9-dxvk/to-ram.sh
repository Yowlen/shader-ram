#!/bin/bash

# Define the stuff from the variables file
u=$(who | awk '{print $1}')
script_dir=$(dirname "$0")

sed '/^\s*$/d' $script_dir/variables > $script_dir/.variables
while read line
do
    if [ $(echo $line | cut -c1) != "#" ]
    then
        line=$(echo "${line/\$u/$u}")
        declare $line
    fi
done < $script_dir/.variables
rm $script_dir/.variables

# Detect DXVK caches
$script_dir/make-config.sh

# Make our folder on the ramdisk
mkdir -p "$shader_ram"

# Now to take each DXVK cache and...
IFS=$'\n'
for dxvk_file in `cat $shader_config/dxvkcaches.config`
do
    # 1. Define additional variables to use with it
    shader_file="${dxvk_file##*/}"
    shader_folder="${dxvk_file%/*}"
    shader_ramfolder="$shader_ram/${shader_folder#?}"
    shader_backup="$shader_folder/ramdisk_backup"

    # 2. Check to see if it's already linked, and if not, make a backup
    #    on the hard drive (for first-time setup of new libraries)
    if [ ! -L $dxvk_file ]
    then
        mkdir "$shader_backup"
        rsync -a --delete "$dxvk_file" "$shader_backup/"
        chown -R $u "$shader_backup"
        rm -f "$dxvk_file"
        ln -s "$shader_backup/$shader_file" "$dxvk_file"
    fi

    # 3. Sync the backup to the RAM disk, then change the link
    #    to the RAM disk
    #d=$(echo $i | cut -d '/' -f2-3 | tr '/' '-')
    mkdir -p "$shader_ramfolder"
    rsync -a --delete "$shader_backup/$shader_file" "$shader_ramfolder/"
    chown -R $u "$shader_ramfolder/*"
    rm -f "$dxvk_file"
    ln -s "$shader_ramfolder/$shader_file" "$dxvk_file"
done
unset $IFS
