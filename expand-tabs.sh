#!/bin/sh

# Written by Karolis Uziela in 2012

if [ $# != 1 ] ; then
    echo "
Usage: 

$0 [Parameters]

Parameters:
<input-file> - input file

"
    exit 1
fi

i=$1;

expand --tabs=2 $i > $i.notab
mv $i.notab $i
chmod a+x $i
