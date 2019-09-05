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
for i in `cat $shader_config/steamlibraries.config`; do
    rm "$i/$shader_dir"
    ln -s "$i/$shader_backup" "$i/$shader_dir"
done
