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

# Check to see if it's already linked, and if not, make a backup on the
# hard drive. (i.e. First-time setup)
if [ ! -L $shader_dir ]
then
    mkdir -p "$shader_backup"
    rsync -a --delete "$shader_dir/*" "$shader_backup/"
    chown -R $u "$shader_backup"
    rm -r "$shader_dir"
    ln -s "$shader_backup" "$shader_dir"
fi

# Sync the backup to the ramdisk, then change the link to point to it.
mkdir -p "$shader_ram"
rsync -a --delete "$shader_backup/" "$shader_ram/"
chown -R $u "$shader_ram"
rm "$shader_dir"
ln -s "$shader_ram" "$shader_dir"
