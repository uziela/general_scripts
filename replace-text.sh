#!/bin/bash

# Written by Karolis Uziela in 2018

script_name=`basename $0`

if [ $# != 3 ] ; then
    echo "
Usage: 

$script_name [Parameters]

Parameters:
<input-dir> 
<text_to_search>
<text_to_replace>

"
    exit 1
fi

input_dir=$1
text_to_search=$2
text_to_replace=$3

echo "$script_name started with parameters: $*"

for i in $input_dir/* ; do
    if [ -f $i ] ; then
        mygrep=`cat $i | grep "$text_to_search"`
        if [ "$mygrep" != "" ] ; then
            echo "Replacing: $i"
            sed -i "s/$text_to_search/$text_to_replace/" $i
        fi
    fi
done

echo "$script_name done."
