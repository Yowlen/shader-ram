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

rm "$shader_dir"
ln -s "$shader_ram" "$shader_dir"

# Tell the drivers to use the ramdisk instead of the hard drive.
# Also do another tweak to keep the drivers from limiting the size.
#export __GL_SHADER_DISK_CACHE_PATH='/mnt/shader-ram/nvidia-proprietary/.nv'
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
