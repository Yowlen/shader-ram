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

# Steam only allows one library per partition, so we can
# eliminate any partitions that already have a known library.
#
# First, we check if there's already a config file and if so,
# make sure any libraries in there still exist.
IFS=$'\n'
if [ -e $shader_config/steamlibraries.config ]
then
    for i in `cat $shader_config/steamlibraries.config`; do
        if [ -d "$i" ]
        then
            echo "$i" >> $shader_config/steamlibraries.config.tmp
        fi
    done
    rm $shader_config/steamlibraries.config
    mv $shader_config/steamlibraries.config.tmp $shader_config/steamlibraries.config

    # Next, we can compare the updated list to the partition list
    # and remove any partitions that already have a library.
    for p in `cat $shader_config/partitions.txt`; do
        m="0"
        for n in `cat $shader_config/steamlibraries.config`; do
            if [[ "$n" == *"$p"* ]]; then
                m="1"
            fi
        done
        if [ "$m" = "0" ]; then
            echo "$p" >> $shader_config/partitions2.txt
        fi
    done
    rm -f $shader_config/partitions.txt
    awk '!a[$0]++' $shader_config/partitions2.txt > $shader_config/partitions.txt
    rm -f $shader_config/partitions2.txt
    touch $shader_config/partitions.txt
fi

IFS=$'\n '
# Now to do the actual search for all Steam libraries
# and output them all to a file
if [[ $(command -v locate) ]];then
    locate '*steamapps' > $shader_config/steamlibraries.txt
else
    echo $(find $(sed ':a;N;$!ba;s/\n/ \0/g' $shader_config/partitions.txt) -mindepth 2 -type d -name "*steamapps" ; ) > $shader_config/steamlibraries.txt
fi
rm $shader_config/partitions.txt
# Then separate with new lines.
cat $shader_config/steamlibraries.txt | sed 's/ \//\n\//g' >> $shader_config/steamlibraries.config
rm $shader_config/steamlibraries.txt
# And just in case, check for and remove any duplicates.
awk '!a[$0]++' $shader_config/steamlibraries.config > $shader_config/steamlibraries.config.tmp
rm $shader_config/steamlibraries.config
mv $shader_config/steamlibraries.config.tmp $shader_config/steamlibraries.config
unset $IFS

# Failsafe just in case nothing's found for some reason
# so that the rest of the script doesn't screw up.
touch $shader_config/steamlibraries.config
