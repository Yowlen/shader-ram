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

# Detect Steam libraries
$script_dir/make-config.sh

# Make our folder on the ramdisk
mkdir -p "$shader_ram"

# Now to take each Steam library and...
IFS=$'\n'
for i in `cat $shader_config/steamlibraries.config`
do
    # 1. Check to see if it's already linked, and if not, make a backup
    #    on the hard drive (for first-time setup of new libraries)
    if [ ! -L $i/$shader_dir ]
    then
        rsync -a --delete "$i/$shader_dir/" "$i/$shader_backup/"
        chown -R $u "$i/$shader_backup"
        rm -r "$i/$shader_dir"
        ln -s "$i/$shader_backup" "$i/$shader_dir"
    fi

    # 2. Sync the backup to the RAM disk, then change the link
    #    to the RAM disk
    d=$(echo $i | cut -d '/' -f2-3 | tr '/' '-')
    rsync -a --delete "$i/$shader_backup/" "$shader_ram/$d/"
    chown -R $u "$shader_ram/$d"
    rm "$i/$shader_dir"
    ln -s "$shader_ram/$d" "$i/$shader_dir"
done
unset $IFS
