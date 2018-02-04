#!/bin/bash

# Written by Karolis Uziela in 2017

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

#count=`ls -1 $input_dir/*.txt 2>/dev/null | wc -l`
if [ ! -d $input_dir ] ; then
    echo "------------------- stage 1 -------------------"
    mkdir $input_dir
fi

echo "$script_name done."
