#!/bin/sh

# Author: Karolis Uziela

if [ $# != 2 ] ; then
    echo "
Usage: 

./make-backup.sh [Parameters]

Parameters:
<root-dir> 
<backup-dir>

"
    exit 1
fi

root_dir=$1
backup_dir=$2

#my_date=`date --rfc-3339=date`
out_dir=$backup_dir/`date +20%y-%m-%d-backup`
out_file=`date +20%y-%m-%d-backup`.tar.gz
#echo $out_dir


mkdir $out_dir

for i in $root_dir/* ; do
    if [ -d $i ] ; then
        base=`basename $i`
        mkdir $out_dir/$base
        if [ -d $i/scripts ] ; then
            cp -r $i/scripts $out_dir/$base
        fi
        cp $i/*.sh $out_dir/$base 2>/dev/null
    fi
done

cp -r $root_dir/general_scripts/* $out_dir/general_scripts/

for i in $root_dir/datasets/* ; do
    if [ -d $i ] ; then
        base=`basename $i`
        mkdir $out_dir/datasets/$base 2>/dev/null
        cp $i/*_dict.txt $out_dir/datasets/$base/ 2>/dev/null
    fi
done

current=`pwd`
cd $backup_dir
tar czf $out_file `basename $out_dir`
cd $current
rm -r $out_dir
