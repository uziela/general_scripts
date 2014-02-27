#!/bin/sh

# Written by Karolis Uziela in 2012

if [ $# != 1 ] ; then
    echo "
Usage: 

$0 [Parameters]

Parameters:
<input-dir> - input directory

"
    exit 1
fi

input_dir=$1;

for i in $input_dir/* ; do
    if [ -f $i ] ; then
        expand --tabs=2 $i > $i.notab
        mv $i.notab $i
        chmod a+x $i
    fi
done
