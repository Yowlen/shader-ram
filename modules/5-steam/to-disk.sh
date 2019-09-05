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

# Check to make sure our Steam config file exists, and if not,
# create it.
if [ ! -f $shader_config/steamlibraries.config ]
then
     $script_dir/make-config.sh
fi

# Now back up each Steam library
IFS=$'\n'
for steam_folder in `cat $shader_config/steamlibraries.config`; do
    #steam_folder_trim=$(echo $steam_folder | cut -d '/' -f2-3 | tr '/' '-')
    steam_folder_trim=${steam_folder#?}
    mkdir -p "$steam_folder/$shader_backup"
    rsync -a --delete "$shader_ram/$steam_folder_trim/" "$steam_folder/$shader_backup/"
    chown -R $u "$steam_folder/$shader_backup"
done
unset $IFS
