#!/bin/bash

# Written by Karolis Uziela in 2014

script_name=`basename $0`

if [ $# != 1 ] ; then
    echo "
Usage: 

$script_name [Parameters]

Parameters:
<input-dir> - input directory

"
    exit 1
fi

input_dir=$1

echo "$script_name started with parameters: $*"

for i in $input_dir/*.sh $input_dir/scripts/* ; do
    nobackup=`cat $i | grep nobackup/global`
    if [ "$nobackup" != "" ] ; then
        sed -i "s/\/nobackup\/global/\/proj\/wallner\/users/" $i
    fi
done

echo "$script_name done."
