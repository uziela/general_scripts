#!/bin/bash

# Written by Karolis Uziela in 2016

script_name=`basename $0`

if [ $# != 1 ] ; then
    echo_both "
Usage: 

$script_name [Parameters]

Parameters:
<input-dir> - input directory

"
    exit 1
fi

input_dir=$1

echo_both "$script_name started with parameters: $*"

for i in $input_dir/* ; do
    year=`cat $i | grep 2016`
    if [ "$year" != "" ] ; then
        sed -i "s/2016/2016/" $i
    fi
done

echo_both "$script_name done."
