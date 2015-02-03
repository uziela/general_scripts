#!/bin/bash

# Written by Karolis Uziela in 2015

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
    year=`cat $i | grep 2014`
    if [ "$year" != "" ] ; then
        sed -i "s/2014/2015/" $i
    fi
done

echo_both "$script_name done."
