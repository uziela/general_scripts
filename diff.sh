#! /bin/bash

if [ $# != 2 ] ; then
    echo "
Usage: 

./runall.sh [Parameters]

Parameters:
<first-dir> 
<second-dir> 

"
    exit 1
fi

first=$1
second=$2

for i in $first/*.sh ; do
    base=`basename $i`
    echo $i
    if diff $first/$base $second/$base >/dev/null ; then :
    else
        tput setaf 1
        echo Different!!!
        tput sgr0
    fi
done

echo "-----------------------"

for i in $first/scripts/* ; do
    base=`basename $i`
    echo $i
    if diff $first/scripts/$base $second/scripts/$base >/dev/null ; then :
    else
        tput setaf 1
        echo Different!!!
        tput sgr0
    fi
done



