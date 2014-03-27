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

for target in $input_dir/* ; do
    for model in $target/* ; do
        base=`basename $model .pdb`
        dirn=`dirname $model`
        if [ ! -f $dirn/$base.pdb ] ; then
            mv $model $dirn/$base.pdb
        fi
    done
done

