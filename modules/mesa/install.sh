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

# Detect whether or not this module is necessary,
# and if so, install it.
echo "Looking for Mesa drivers."
if [ -d "/home/$u/.cache/mesa_shader_cache" ]
then
    echo "Mesa detected. Installing module."
    mkdir -p $shader_modules/$mod_name
    cp -rf $script_dir/* $shader_modules/$mod_name
else
    if [ -L "/home/$u/.cache/mesa_shader_cache" ]
    then
        echo "Mesa detected. Installing module."
        mkdir -p $shader_modules/$mod_name
        cp -rf $script_dir/* $shader_modules/$mod_name
    else
        echo "Mesa not detected."
        echo "Skipping installation."
    fi
fi
