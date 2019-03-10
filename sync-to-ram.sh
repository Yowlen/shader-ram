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

# First, let's check to see if the RAM disk is created,
# and if not, make it.
if [ ! -f $shader_test ]
then
    mkdir -p $shader_ram
    mount -t tmpfs -o size=2G tmpfs $shader_ram && touch $shader_test
fi

# And now we find and execute each module
for m in $shader_modules/*
do
    if [ -d $m ]
    then
        chmod +x $m/*.sh
        $m/to-ram.sh
    fi
done
