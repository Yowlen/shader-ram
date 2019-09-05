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
for i in `cat $shader_config/steamlibraries.config`
do
    d=${i#?}
    rm -f "$i/$shader_dir"
    ln -s "$shader_ram/$d" "$i/$shader_dir"
done
unset $IFS
