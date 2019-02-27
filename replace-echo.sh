#!/bin/bash

# Written by Karolis Uziela in 2016

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

for i in $input_dir/* ; do
    year=`cat $i | grep echo_both`
    if [ "$year" != "" ] ; then
        sed -i "s/echo_both/echo/" $i
    fi
done

echo "$script_name done."
