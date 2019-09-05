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

$script_dir/to-ram.sh

IFS=$'\n'
for dxvk_file in `cat $shader_config/dxvkcaches.config`
do
    # 1. Define additional variables to use with it
    shader_file="${dxvk_file##*/}"
    shader_folder="${dxvk_file%/*}"
    shader_ramfolder="$shader_ram/${shader_folder#?}"
    shader_backup="$shader_folder/ramdisk_backup"

    rm -f "$dxvk_file"
    ln -s "$shader_ramfolder/$shader_file" "$dxvk_file"
done
unset $IFS
