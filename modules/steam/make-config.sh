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

# Begin Steam library search
# If you don't use Steam, you'll wanna either comment out
# or remove everything from here on except for the final
# "fi" line and the blank line at the end.
#
# Check if config folder exists, and if not, create it
mkdir -p $shader_config

# Begin Steam library detection
#
# Find potential search points
rm -f $shader_config/partitions.txt
cat /proc/mounts | grep 'ext4\|xfs\|btrfs' | grep -v ' / ' | cut -d ' ' -f2 | sed '/home/d' > $shader_config/partitions.txt
echo /home/$u >> $shader_config/partitions.txt

# Now to do the actual search for all Steam libraries
# and output them all to a file.
echo $(find $(sed ':a;N;$!ba;s/\n/ \0/g' $shader_config/partitions.txt) -mindepth 2 -type d -name "*steamapps" ; ) > $shader_config/steamlibraries.txt
rm $shader_config/partitions.txt
# Then separate with new lines.
cat $shader_config/steamlibraries.txt | sed 's/ \//\n\//g' > $shader_config/steamlibraries.config
rm $shader_config/steamlibraries.txt
