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
exit

# Begin module uninstallation
#
# Reset each DXVK cache
IFS=$'\n'
for dxvk_file in `cat "$shader_config/dxvkconfig.config"`
do
    # 1. Define additional variables
    shader_file="${dxvk_file##*/}"
    shader_folder="${dxvk_file%/*}"
    shader_ramfolder="$shader_ram/${shader_folder#?}"
    shader_backup="$shader_folder/ramdisk_backup"

    rm "$dxvk_file"
    rsync -a "$shader_backup/$shader_file" "$dxvk_file"
    rm -r "$shader_backup"
done
