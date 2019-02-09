#!/bin/bash

# Define some variables
u=$(who | awk '{print $1}')
shader_config=/home/$u/.config/shader-ram

# Begin Steam library search
# If you don't use Steam, you'll wanna either comment out
# or remove everything from here on except for the final
# "fi" line and the blank line at the end.
#
# Check if config folder exists, and if not, create it
if [ ! -d '$shader_config' ]
    mkdir $shader_config
fi

# Find potential search points
cat /proc/mounts | grep 'ext4\|xfs\|btrfs' | grep -v ' / ' | cut -d ' ' -f2 | sed '/home/d' > $shader_config/partitions.txt
echo /home/$u >> $shader_config/partitions.txt

# Now to do the actual search for all Steam libraries
# and output them all to a file.
echo $(find $(sed ':a;N;$!ba;s/\n/ \0/g' $shader_config/partitions.txt) -mindepth 3 -type d -name "*steamapps" ; ) >> $shader_config/steamlibraries.txt
rm $shader_config/partitions.txt
# Then separate with new lines.
tr ' \/' '\n\/' < $shader_config/steamlibraries.txt > $shader_config/steamlibraries.config
rm $shader_config/steamlibraries.txt
