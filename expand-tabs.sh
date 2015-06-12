#!/bin/sh

# Written by Karolis Uziela in 2012

if [ $# != 2 ] ; then
    echo "
Usage: 

$0 [Parameters]

Parameters:
<input-file> - input file
<tab-size>

"
    exit 1
fi

i=$1
n=$2

expand --tabs=$n $i > $i.notab
mv $i.notab $i
chmod a+x $i
