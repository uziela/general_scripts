#!/bin/bash

# Written by Karolis Uziela in 2016

script_name=`basename $0`

if [ $# != 2 ] ; then
    echo "
Usage: 

$script_name [Parameters]

Parameters:
<input-dir>
<output-dir>

"
    exit 1
fi

input_dir=$1
output_dir=$2

echo_both "$script_name started with parameters: $*"

#count=`ls -1 $input_dir/*.txt 2>/dev/null | wc -l`
if [ ! -d $output_dir ] ; then
    echo_both "------------------- stage 1 -------------------"
    mkdir $output_dir
    mkdir $output_dir/native
    mkdir $output_dir/server_predictions
    mkdir $output_dir/target_seq
    for week_dir in $input_dir/* ; do
        echo $week_dir
        for target_dir in $week_dir/* ; do
            target=`basename $target_dir`
            cp $target_dir/target.fasta $output_dir/target_seq/$target.seq
            cp $target_dir/target.pdb $output_dir/native/$target.pdb
            mkdir $output_dir/server_predictions/$target
            for server_dir in $target_dir/servers/server* ; do
                for model_dir in $server_dir/model* ; do
                    server=`basename $server_dir`
                    model=`basename $model_dir`
                    model_name=$server-$model
                    mkdir $output_dir/server_predictions/$target/$model_name
                    if [ ! -f $model_dir/$model.pdb ] ; then
                        echo_both "WARNING: $model_dir/$model.pdb does not exist"
                    else
                        cp $model_dir/$model.pdb $output_dir/server_predictions/$target/$model_name/$model_name.pdb
                    fi
                done
            done
        done
    done
fi

echo_both "$script_name done."
