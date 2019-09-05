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

$script_dir/to-disk.sh

# Restore Steam library links
IFS=$'\n'
for dxvk_file in `cat $shader_config/dxvkcaches.config`; do
    shader_file="${dxvk_file##*/}"
    rm -f "$dxvk_file"
    ln -s "$shader_backup/$shader_file" "$dxvk_file"
done
unset $IFS
