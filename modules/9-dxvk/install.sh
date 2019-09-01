#!/bin/bash

# Define the stuff from the variables file
u=$(who | awk '{print $1}')
script_dir=$(dirname "$0")

while read line
do
    if [ $(echo $line | cut -c1) != "#" ]
    then
        line=$(echo "${line/\$u/$u}")
        declare $line
    fi
done < $script_dir/../../.variables

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

# Begin module installation
echo "Looking for DXVK."
s=$(whereis steam | tail -c +8)
w=$(whereis wine | tail -c +7)
if [ -n "$s" ] || [ -n "$w" ]
then
    echo "DXVK detected. Installing module."
    mkdir -p "$shader_modules/$mod_name"
    cp -rf "$script_dir/" "$shader_modules"
else
    echo "DXVK not detected."
    echo "Skipping module installation."
fi
