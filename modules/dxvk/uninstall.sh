#!/bin/bash

# Define the stuff from the variables file
u=$(who | awk '{print $1}')
script_dir=$(dirname "$0")
home_dir=/opt/shader-ram

while read line
do
    if [ $(echo $line | cut -c1) != "#" ]
    then
        line=$(echo "${line/\$u/$u}")
        declare $line
    fi
done < $home_dir/variables

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

# Check to make sure our DXVK config file exists, and if not,
# create it.
if [ ! -f $shader_config/dxvkcaches.config ]
then
     $script_dir/make-config.sh
fi

# Begin module uninstallation
#
# Reset each DXVK cache
IFS=$'\n'
for dxvk_file in `cat $shader_config/dxvkcaches.config`; do
    # 1. Define additional variables
    shader_file="${dxvk_file##*/}"
    shader_folder="${dxvk_file%/*}"
    shader_ramfolder="$shader_ram/${shader_folder#?}"
    shader_backup="$shader_folder/ramdisk_backup"

    # 2. Restore the file to its original spot and remove the backup
    echo "Restoring $dxvk_file."
    rm -f "$dxvk_file"
    rsync -a --delete "$shader_backup/$shader_file" "$shader_folder/"
done

# And then to run back through them and delete the backup folders.
#
# This is separate because there can be more than one file in a given
# backup folder, so we need to make sure everything is properly synced
# before removing the folders.
for dxvk_file in `cat $shader_config/dxvkcaches.config`
do
    shader_backup="$shader_folder/ramdisk_backup"
    echo "Removing $shader_backup."
    rm -rf "$shader_backup"
done
unset $IFS
